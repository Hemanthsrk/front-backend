pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Hemanthsrk/front-backend.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    sh 'docker build -t Docker.frontend'
                    sh 'docker build -t Docker.backend'
                }
            }
        }
        stage('Deploy using Terraform') {
            steps {
                script {
                    sh 'cd terraform && terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f frontend-deployment.yaml'
		sh 'kubectl apply -f backend-deployment.yaml'
		sh 'kubectl apply -f service,yaml'
            }
        }    
    }
}
                     
