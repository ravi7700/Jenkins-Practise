pipeline {
    agent { label 'linux-worker' }

    // Define variables to be used throughout the pipeline
    environment {
        // REPLACE THIS with your actual Docker Hub username!
        DOCKER_HUB_USER = 'YOUR_DOCKERHUB_USERNAME' 
        IMAGE_NAME = 'my-first-container'
        IMAGE_TAG = "${env.BUILD_NUMBER}" // Tags the image with the Jenkins build number
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

        stage('Build Docker Image') {
            steps {
                echo "Building image: ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}..."
                // Uses the Dockerfile in your repo to build the image
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Authenticating and pushing image to Docker Hub..."
                // This block securely injects your credentials without exposing them in the logs
                withCredentials([usernamePassword(credentialsId: 'docker-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    // Log in to Docker Hub
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                    
                    // Push the image
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }

    post {
        success {
            emailext (
                to: 'ravimali7700@gmail.com',
                subject: "SUCCESS: Image Pushed - Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Build successful. The new Docker image is available on Docker Hub as ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}\n\nLogs: ${env.BUILD_URL}",
                attachLog: true
            )
        }
        failure {
            emailext (
                to: 'ravimali7700@gmail.com',
                subject: "FAILURE: Docker Build Failed - Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "The Docker build or push failed. Check logs here: ${env.BUILD_URL}",
                attachLog: true
            )
        }
        always {
            // CRITICAL: Clean up the local slave disk so your 2GB server doesn't run out of space!
            echo "Cleaning up local Docker images..."
            sh "docker rmi ${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} || true"
            sh "docker image prune -f"
        }
    }
}
