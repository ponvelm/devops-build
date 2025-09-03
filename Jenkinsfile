pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS = credentials('dockerhub-creds')
        DOCKER_USER = "${DOCKER_CREDENTIALS_USR}"
        DOCKER_PASS = "${DOCKER_CREDENTIALS_PSW}"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t myapp:latest .'
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'

                    if (env.BRANCH_NAME == "dev") {
                        sh 'docker tag myapp:latest ponvel123/dev:latest'
                        sh 'docker push ponvel123/dev:latest'
                    } else if (env.BRANCH_NAME == "master") {
                        sh 'docker tag myapp:latest ponvel123/prod:latest'
                        sh 'docker push ponvel123/prod:latest'
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
}
