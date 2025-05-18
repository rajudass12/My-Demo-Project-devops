pipeline {
    agent any

    tools {
        maven 'maven' // This must match the Maven name in Jenkins tools config
    }

    environment {
        SONARQUBE_ENV = 'SonarQube'
        ECR_REPO = '390168495077.dkr.ecr.us-east-1.amazonaws.com/my_ecr_demo'
        AWS_REGION = 'us-east-1'
        IMAGE_NAME = 'my-java-app'
    }

    stages {
        stage('SCM Checkout') {
            steps {
                echo "Cloning the repository..."
                git 'https://github.com/vikki-iam/My-Demo-Project.git'
            }
        }

        stage('Maven Build') {
            steps {
                echo "Running Maven clean and install..."
                sh 'mvn clean install -DskipTests=true'
            }
        }

        stage('Unit Test (Optional)') {
            steps {
                echo "Running unit tests..."
                sh 'mvn test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo "Starting SonarQube static code analysis..."
                withSonarQubeEnv("${env.SONARQUBE_ENV}") {
                    withCredentials([string(credentialsId: 'sonar_token', variable: 'SONAR_TOKEN')]) {
                        sh """
                            mvn sonar:sonar \\
                              -Dsonar.projectKey=vignesh \\
                              -Dsonar.projectName='my-proj' \\
                              -Dsonar.host.url=http://localhost:9000 \\
                              -Dsonar.login=$SONAR_TOKEN
                        """
                    }
                }
            }
        }

        // stage('Wait for Quality Gate') {
        //     steps {
        //         timeout(time: 2, unit: 'MINUTES') {
        //             waitForQualityGate abortPipeline: true
        //         }
        //     }
        // }

        stage('Docker Build & Push to ECR') {
            steps {
                script {
                    echo "Building Docker image and pushing to ECR..."
                    withAWS(region: "${env.AWS_REGION}", credentials: 'AWS_CREDS') {
                        sh 'docker build -t $IMAGE_NAME .'
                        sh "aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${ECR_REPO.split('/')[0]}"
                        sh 'docker tag $IMAGE_NAME:latest $ECR_REPO:latest'
                        sh 'docker push $ECR_REPO:latest'
                    }
                }
            }
        }

        stage('Deploy Application (Docker Run)') {
            steps {
                echo "Deploying container locally for testing..."
                sh 'docker stop $IMAGE_NAME || true'
                sh 'docker rm $IMAGE_NAME || true'
                sh "docker run --name $IMAGE_NAME -d -p 8081:8080 $ECR_REPO:latest"
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully."
        }
        failure {
            echo "❌ Pipeline failed."
        }
    }
}
