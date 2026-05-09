pipeline {
    agent { label 'linux-worker' }

    environment {
        // Replace with your actual Docker Hub username
        DOCKER_HUB_USER = 'ravikumarr10839' 
        IMAGE_NAME = 'my-first-container'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['Dev', 'Staging', 'Production'], description: 'Select the target environment')
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps { 
                checkout scm 
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                echo "Building and pushing image to Docker Hub..."
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
                
                withCredentials([usernamePassword(credentialsId: 'docker-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Environment') {
            steps {
                echo "Deploying application to ${params.ENVIRONMENT} environment..."
                
                // 1. Stop and remove any old version of the app running in this environment
                sh "docker rm -f my-app-${params.ENVIRONMENT} || true"
                
                // 2. Run the new Docker container in the background
                // Maps port 80 inside the container to port 8080 on your Slave server
                sh "docker run -d -p 8080:80 --name my-app-${params.ENVIRONMENT} ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
    }

    post {
        success {
            emailext (
                to: 'ravimali7700@gmail.com',
                subject: "SUCCESS: Deployed to ${params.ENVIRONMENT} - Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Deployment successful!\n\nEnvironment: ${params.ENVIRONMENT}\nImage: ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}\n\nYou can view the build logs here: ${env.BUILD_URL}",
                attachLog: true
            )
        }
        failure {
            emailext (
                to: 'ravimali7700@gmail.com',
                subject: "FAILURE: Pipeline Failed - Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "The build or deployment failed. Please check the attached logs or view them here: ${env.BUILD_URL}",
                attachLog: true
            )
        }
        always {
            echo "Cleaning up local Docker images to save space..."
            sh "docker rmi ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} || true"
            sh "docker image prune -f"
        }
    }
}
