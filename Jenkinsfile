pipeline {
    agent any

    environment {
        IMAGE_NAME = "valentinlisci/flask-app-example-build"
        TAG = "latest"
    }

    stages {
        stage('Login a Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'ade514a3-2a15-4b04-bd34-a909ff2b09cf', 
                    usernameVariable: 'DOCKER_USER', 
                    passwordVariable: 'DOCKER_PASS')]) {
                        sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                }
            }
        }
        stage('Build immagine Docker') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$TAG .'
            }
        }
        stage('Push su Docker Hub') {
            steps {
                sh 'docker push $IMAGE_NAME:$TAG'
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}

