pipeline {
    agent { label 'linux-worker' }
    triggers {
        githubPush() 
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm 
            }
        }
        stage('Test Email Logic') {
            steps {
                echo 'Validating environment and sending notification...'
                sh 'hostname'     
                sh 'free -h'     
            }
        }
    }

    post {
        success {
            
            emailext (
                to: 'ravimali7700@gmail.com',
                subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "The build was successful! Review the results here: ${env.BUILD_URL}",
                attachLog: true 
            )
        }
        failure {
            
            emailext (
                to: 'ravimali7700@gmail.com',
                subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "The build failed. Check the console output: ${env.BUILD_URL}",
                attachLog: true
            )
        }
    }
}
