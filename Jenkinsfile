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
                // This creates a dummy file to represent our application output
                sh 'echo "Version: ${env.BUILD_ID}" > my-app-v${env.BUILD_ID}.jar'
                sh 'ls -l *.jar'
            }
        }
    }

    post {
        success {
            // This command tells Jenkins to "grab" the file and store it on the Master
            archiveArtifacts artifacts: '*.jar', followSymlinks: false
            
            emailext (
                to: 'ravimali7700@gmail.com',
                subject: "SUCCESS: Artifact Stored - Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Build successful. Download artifact here: ${env.BUILD_URL}artifact/",
                attachLog: true
            )
        }
    }
}
