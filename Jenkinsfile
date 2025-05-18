pipeline {
    agent any
    tools {
        maven 'MAVEN_HOME'
        jdk 'JDK11'
    }
    environment {
        SONARQUBE = 'MySonarQube'
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/your-user/java-app.git'
            }
        }
        stage('Code Quality - SonarQube') {
            steps {
                withSonarQubeEnv("${SONARQUBE}") {
                    sh 'mvn clean verify sonar:sonar'
                }
            }
        }
        stage('Build') {
            steps {
                sh 'mvn package'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t java-app:1.0 .'
            }
        }
        stage('Docker Run') {
            steps {
                sh 'docker run -d -p 8080:8080 java-app:1.0'
            }
        }
    }
}