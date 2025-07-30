pipeline {
    agent {
        label 'agent1'
    }

    environment {
        DOCKER_USER = 'valentinlisci'
        DOCKER_REPO = 'flask-app-example-build'
        TAG = "${env.BRANCH_NAME ?: 'latest'}"
    }

    stages {
        stage('Login a Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                }
            }
        }

        stage('Build immagine Docker') {
            steps {
                sh 'docker build -t $DOCKER_USER/$DOCKER_REPO:$TAG .'
            }
        }

        stage('Push su Docker Hub') {
            steps {
                script {
                    sh "docker tag $DOCKER_USER/$DOCKER_REPO:$TAG $DOCKER_USER/$DOCKER_REPO:latest"
                    sh "docker push $DOCKER_USER/$DOCKER_REPO:$TAG"
                    sh "docker push $DOCKER_USER/$DOCKER_REPO:latest"
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout || echo "Docker logout fallito ma continuo"'
        }
    }
}
