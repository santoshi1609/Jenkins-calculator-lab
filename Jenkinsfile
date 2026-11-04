pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 15, unit: 'MINUTES')
    }

    environment {
        APP_NAME = 'calculator-app'
    }

    stages {
        stage('Build') {
            steps {
                sh 'python3 -m py_compile calculator.py'
                echo 'Build successful'
            }
        }

        stage('Test') {
            steps {
                sh 'python3 -m pytest -v --junitxml=test-results.xml'
            }
        }

        stage('Package') {
            steps {
                sh 'mkdir -p dist'
                sh 'tar -czf dist/${APP_NAME}-${BUILD_NUMBER}.tar.gz calculator.py'
                archiveArtifacts artifacts: 'dist/*.tar.gz'
            }
        }

        stage('Docker Image') {
            steps {
                sh 'docker build -t ${APP_NAME}:${BUILD_NUMBER} .'
                sh 'docker run --rm ${APP_NAME}:${BUILD_NUMBER}'
            }
        }

        stage('Deploy to Staging') {
            steps {
                input message: 'Deploy to staging?', ok: 'Deploy'
                sh 'mkdir -p /tmp/usn-staging'
                sh 'cp calculator.py /tmp/usn-staging/'
                sh 'ls -l /tmp/usn-staging'
            }
        }
    }

    post {
        always {
            junit allowEmptyResults: true, testResults: 'test-results.xml'
        }
        success {
            echo 'CI/CD Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check Console Output.'
        }
    }
}
