pipeline {
    agent { label 'linux-worker' } // Ensures execution on your optimized slave [cite: 1240, 1278]
    
    triggers {
        githubPush() // Automatically starts the build when GitHub sends a webhook "ping" 
    }

    stages {
        stage('Checkout') {
            steps {
                // Pulls code from the repository where this Jenkinsfile is stored [cite: 1277]
                checkout scm 
            }
        }
        stage('Identify Environment') {
            steps {
                echo 'Build triggered automatically via Webhook!'
                sh 'hostname'     // Confirms it is running on the slave node [cite: 1313]
                sh 'free -h'      // Verifies your 2GB Swap space is active [cite: 1604, 1779]
            }
        }
        stage('Verify Files') {
            steps {
                sh 'ls -lthr'     // Lists the files pulled from your GitHub repo [cite: 1643, 1644]
            }
        }
    }
}
