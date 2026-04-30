pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git 'https://github.com/nileshwanare1/Terraform_CICD.git'
            }
        }

        stage('Deploy to Nginx') {
            steps {
                sh '''
                sudo rm -rf /var/www/html/*
                sudo cp -r app/* /var/www/html/
                '''
            }
        }
    }
}