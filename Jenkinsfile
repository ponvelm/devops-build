pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'ec2-ssh-key' // Your Docker Hub credentials ID
        DEV_REPO = 'ponvel123/dev'
        PROD_REPO = 'ponvel123/prod'
    }

    stages {
        stage('Checkout') {
            steps {
                git(
                    branch: "${env.BRANCH_NAME ?: 'dev'}", 
                    url: 'https://github.com/ponvelm/devops-build.git',
                    credentialsId: ''
                )
            }
        }

        stage('Build Docker') {
            steps {
                sh 'chmod +x build.sh deploy.sh'
                sh './build.sh'
            }
        }

        stage('Push Docker') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                            sh "docker login -u $DOCKER_USER -p $DOCKER_PASS"
                            sh "docker tag devops-build:latest ${DEV_REPO}:latest"
                            sh "docker push ${DEV_REPO}:latest"
                        }
                    } else if (env.BRANCH_NAME == 'main') {
                        withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                            sh "docker login -u $DOCKER_USER -p $DOCKER_PASS"
                            sh "docker tag devops-build:latest ${PROD_REPO}:latest"
                            sh "docker push ${PROD_REPO}:latest"
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                sh './deploy.sh'
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully for branch: ${env.BRANCH_NAME}"
        }
        failure {
            echo "Pipeline failed for branch: ${env.BRANCH_NAME}"
        }
    }
}
