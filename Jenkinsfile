pipeline {
    agent any
    environment {
        DEV_IMAGE = "ponvel123/dev:latest"
        PROD_IMAGE = "ponvel123/prod:latest"
        DOCKERHUB_CREDENTIALS = "ec2-ssh-key" // Your Docker Hub credentials ID
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/ponvelm/devops-build.git'
            }
        }
        stage('Build Docker') {
            steps {
                sh 'chmod +x build.sh'
                sh './build.sh'
            }
        }
        stage('Push Docker') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", 
                                                     usernameVariable: 'DOCKER_USER', 
                                                     passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                        if (env.BRANCH_NAME == 'dev') {
                            sh "docker push ${DEV_IMAGE}"
                        } else if (env.BRANCH_NAME == 'main') {
                            sh "docker push ${PROD_IMAGE}"
                        }
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                sh 'chmod +x deploy.sh'
                sh './deploy.sh'
            }
        }
    }
    post {
        always {
            echo "Pipeline completed for branch: ${env.BRANCH_NAME}"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
