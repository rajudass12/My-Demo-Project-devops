pipeline {
    agent { label 'proj' }
    tools {
        maven 'vignesh' // This must match the Maven name in Jenkins tools config
    }
    environment {
        SONARQUBE_ENV = 'sonar'
        ECR_REPO = 'xyz'
        AWS_REGION = 'us-east-1'
        IMAGE_NAME = 'we-repo'
    }
    stages {
        stage('CheckOut') {
            steps {
               git 'https://github.com/vikki-iam/My-Demo-Project.git'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                echo "Starting SonarQube static code analysis..."
                withSonarQubeEnv("${env.SONARQUBE_ENV}") {
                    withCredentials([string(credentialsId: 'vigneshhh', variable: 'SONAR_TOKEN')]) {
                        sh """
                            mvn clean verify sonar:sonar \
                              -Dsonar.projectKey=demo \
                              -Dsonar.projectName='demo' \
                              -Dsonar.host.url=http://54.164.182.242:9000 \
                              -Dsonar.token=$SONAR_TOKEN
                        """
                    }
                }
            }
        }
        stage('Wait for Quality Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                 }
            }
         }
        stage('MVN-BUILD') {
            steps {
               sh 'mvn clean install'
            }
        }
        stage('Docker Build & Push to ECR') {
            steps {
                script {
                    echo "Building Docker image and pushing to ECR..."
                    withAWS(region: "${env.AWS_REGION}", credentials: 'demo') {
                        sh 'docker build -t $IMAGE_NAME .'
                        sh "aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${ECR_REPO.split('/')[0]}"
                        sh 'docker tag $IMAGE_NAME:latest $ECR_REPO:latest'
                        sh 'docker push $ECR_REPO:latest'
                    }
                }
            }
        }
       stage('Deploy') {
            steps {
                script {
                    echo "Building Docker image and pushing to ECR..."
                    withAWS(region: "${env.AWS_REGION}", credentials: 'demo') {
                       sh "aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${ECR_REPO.split('/')[0]}"
                       sh 'docker pull $ECR_REPO:latest'
                       sh 'docker stop con-2'
                       sh 'docker rm cont-2'
                       sh 'docker run -itd --name con-2 -p "81:8080" $ECR_REPO:latest '
                    }
                }
            }
        }
    }
}
