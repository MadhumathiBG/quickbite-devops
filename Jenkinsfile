pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'madhumathibganeshappa'
        IMAGE_NAME = 'quickbite-frontend'
        DOCKER_CREDENTIALS = credentials('dockerhub-creds')
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh '''
                    docker build \
                      -t ${DOCKERHUB_USER}/${IMAGE_NAME}:latest \
                      ./app/frontend
                '''
            }
        }

        stage('Tag') {
            steps {
                sh '''
                    docker tag \
                      ${DOCKERHUB_USER}/${IMAGE_NAME}:latest \
                      ${DOCKERHUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER}
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh '''
                    echo "$DOCKER_CREDENTIALS_PSW" | docker login \
                      -u "$DOCKER_CREDENTIALS_USR" \
                      --password-stdin

                    docker push \
                      ${DOCKERHUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER}

                    docker push \
                      ${DOCKERHUB_USER}/${IMAGE_NAME}:latest

                    docker logout
                '''
            }
        }

        stage('Deploy to App Server') {
    steps {
        sshagent(['app-server-ssh']) {
            sh '''
                ssh -o StrictHostKeyChecking=no ubuntu@10.0.1.9 "
                    if [ ! -d ~/quickbite-devops/.git ]; then
                        git clone https://github.com/MadhumathiBG/quickbite-devops.git ~/quickbite-devops
                    else
                        cd ~/quickbite-devops && git pull --ff-only origin main
                    fi

                    cd ~/quickbite-devops

                    IMAGE_TAG=${BUILD_NUMBER} docker compose pull frontend
                    IMAGE_TAG=${BUILD_NUMBER} docker compose up -d
                "
            '''
        }
    }
}
           
    }

    post {
        success {
            echo 'QuickBite pipeline completed successfully!'
        }
        failure {
            echo 'QuickBite pipeline failed.'
        }
    }
}
