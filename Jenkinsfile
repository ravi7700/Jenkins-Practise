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
        
        stage('Build Artifact') {
            steps {
                echo 'Simulating Java Compilation...'
                // FIXED: Using double quotes allows Jenkins to replace ${env.BUILD_ID}
                sh "echo 'Version: ${env.BUILD_ID}' > my-app-v${env.BUILD_ID}.jar"
                sh "ls -l *.jar"
            }
        }

        stage('Archive & Test Notification') {
            steps {
                echo 'Build successful, archiving artifact...'
                // This will store the JAR file on the Master node
                archiveArtifacts artifacts: '*.jar', followSymlinks: false
            }
        }
    }

    post {
        success {
            emailext (
                to: 'ravimali7700@gmail.com',
                subject: "SUCCESS: Artifact Created - Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Build successful. You can download the artifact here: ${env.BUILD_URL}artifact/",
                attachLog: true
            )
        }
        failure {
            emailext (
                to: 'ravimali7700@gmail.com',
                subject: "FAILURE: Build Failed - Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "The build failed. Please check the logs here: ${env.BUILD_URL}",
                attachLog: true
            )
        }
    }
}
