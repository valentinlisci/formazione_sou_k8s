pipeline {
    agent { label 'agent1' }

    environment {
        DOCKER_USER = 'valentinlisci'
        DOCKER_REPO = 'flask-app-example-build'
        GIT_BRANCH_NAME = env.GIT_BRANCH?.replaceFirst(/^origin\//, '') ?: 'main'
        COMMIT_SHA = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
        GIT_TAG_NAME = sh(script: 'git describe --tags --exact-match || echo ""', returnStdout: true).trim()
    }

    stages {
        stage('Login a Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Build immagine Docker') {
            steps {
                script {
                    def tag = 'latest'

                    if (GIT_TAG_NAME) {
                        tag = GIT_TAG_NAME
                    } else if (GIT_BRANCH_NAME == 'develop') {
                        tag = "develop-${COMMIT_SHA}"
                    }

                    env.TAG = tag
                    sh "docker build -t $DOCKER_USER/$DOCKER_REPO:$TAG ."
                }
            }
        }

        stage('Push su Docker Hub') {
            steps {
                script {
                    sh "docker push $DOCKER_USER/$DOCKER_REPO:$TAG"

                    // Pusha anche latest se su main
                    if (GIT_BRANCH_NAME == 'main') {
                        sh "docker tag $DOCKER_USER/$DOCKER_REPO:$TAG $DOCKER_USER/$DOCKER_REPO:latest"
                        sh "docker push $DOCKER_USER/$DOCKER_REPO:latest"
                    }
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
        }
    }
}
