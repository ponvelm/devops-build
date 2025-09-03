pipeline {
    agent any

    environment {
        // DockerHub credentials stored in Jenkins with ID = "dockerhub"
        DOCKERHUB = credentials('dockerhub')
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies & Build React App') {
            steps {
                sh '''
                echo "📦 Installing dependencies..."
                npm install
                echo "⚡ Building React App..."
                npm run build
                '''
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    def dockerRepo = ""
                    
                    // Select DockerHub repo based on branch
                    if (env.BRANCH_NAME == "dev") {
                        dockerRepo = "ponvel123/dev"
                    } else if (env.BRANCH_NAME == "main") {
                        dockerRepo = "ponvel123/prod"
                    } else {
                        error("❌ Unsupported branch: ${env.BRANCH_NAME}")
                    }

                    sh """
                    echo "🔑 Logging into DockerHub..."
                    echo "${DOCKERHUB_PSW}" | docker login -u "${DOCKERHUB_USR}" --password-stdin
                    
                    echo "🐳 Building Docker image..."
                    docker build -t ${dockerRepo}:${BUILD_NUMBER} .
                    docker tag ${dockerRepo}:${BUILD_NUMBER} ${dockerRepo}:latest
                    
                    echo "📤 Pushing Docker image to DockerHub..."
                    docker push ${dockerRepo}:${BUILD_NUMBER}
                    docker push ${dockerRepo}:latest
                    """
                }
            }
        }

        // (Optional) Deployment stage for later
        stage('Deploy to Server') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                echo "🚀 Deploying to AWS EC2..."
                ./deploy.sh
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Build & Push successful for branch: ${env.BRANCH_NAME}"
        }
        failure {
            echo "❌ Build failed for branch: ${env.BRANCH_NAME}"
        }
    }
}
