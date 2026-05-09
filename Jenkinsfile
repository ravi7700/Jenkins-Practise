pipeline {
    agent { label 'linux-worker' }

    // This block creates the interactive UI in Jenkins
    parameters {
        choice(name: 'ENVIRONMENT', choices: ['Dev', 'Staging', 'Production'], description: 'Select the target environment')
        booleanParam(name: 'RUN_SECURITY_SCAN', defaultValue: true, description: 'Check this to run a security check')
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

        stage('Input Validation') {
            steps {
                // We access parameters using the 'params' object
                echo "Target Environment: ${params.ENVIRONMENT}"
                echo "Security Scan Enabled: ${params.RUN_SECURITY_SCAN}"
            }
        }

        stage('Conditional Security Scan') {
            when {
                expression { params.RUN_SECURITY_SCAN == true }
            }
            steps {
                echo "Performing security scan on ${params.ENVIRONMENT} environment..."
                sh 'sleep 2' // Simulating a scan
            }
        }
    }

    post {
        success {
            emailext (
                to: 'ravimali7700@gmail.com',
                subject: "SUCCESS: Build #${env.BUILD_NUMBER} for ${params.ENVIRONMENT}",
                body: "Environment: ${params.ENVIRONMENT}\nScan Performed: ${params.RUN_SECURITY_SCAN}\nLogs: ${env.BUILD_URL}",
                attachLog: true
            )
        }
    }
}
