pipeline {
    agent { label 'linux-worker' } // Forces the job to run on your optimized Slave [cite: 1802]

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm 
            }
        }
        stage('System Health Check') {
            steps {
                echo 'Verifying Slave Node environment...'
                sh 'hostname'     // Confirms it is the jenkins-slave [cite: 1401]
                sh 'free -h'      // Confirms your 2GB Swap space is active [cite: 1401, 1562]
            }
        }
        stage('Verify Files') {
            steps {
                echo 'Listing files pulled from GitHub:'
                sh 'ls -lthr'     // Shows the repository contents in the slave workspace [cite: 1427, 1805]
            }
        }
    }
    
    post {
        always {
            echo 'Build process completed.'
        }
    }
}
