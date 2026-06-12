pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                url: 'https://github.com/2004Pruthvi/enterprise-devops-project.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Unit Test') {
            steps {
                sh 'mvn test'
            }
        }

        withSonarQubeEnv('SonarQube') {
            sh '''
            mvn sonar:sonar \
            -Dsonar.projectKey=enterprise-devops-app
            '''
        }
        stage('Deploy Artifact to Nexus') {
            steps {
                sh 'mvn deploy'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t enterprise-devops-app:v1 .'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                TMPDIR=/home/ubuntu/trivy-temp \
                trivy image \
                --cache-dir /home/ubuntu/trivy-cache \
                --severity HIGH,CRITICAL \
                enterprise-devops-app:v1
                '''
            }
        }

        stage('Push to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region us-east-1 | \
                docker login --username AWS --password-stdin \
                225823724207.dkr.ecr.us-east-1.amazonaws.com

                docker tag enterprise-devops-app:v1 \
                225823724207.dkr.ecr.us-east-1.amazonaws.com/enterprise-devops-app:v1

                docker push \
                225823724207.dkr.ecr.us-east-1.amazonaws.com/enterprise-devops-app:v1
                '''
            }
        }
    }
}
