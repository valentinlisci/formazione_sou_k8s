pipeline {
    agent { label 'agent1' }

    environment {
        DOCKER_USER = "valentinlisci"
        IMAGE_NAME = "flask-app-example-build"
        DOCKER_REPO = "${DOCKER_USER}/${IMAGE_NAME}"
        DOCKER_PASS = credentials('dockerhub-token') // ID Jenkins del token Docker
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Calcolo tag immagine') {
            steps {
                script {
                    def branch = env.GIT_BRANCH?.split('/')[-1]
                    def commitSha = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    def gitTag = sh(script: "git describe --tags --exact-match || echo ''", returnStdout: true).trim()

                    if (gitTag) {
                        env.DOCKER_TAG = gitTag
                        echo "Costruzione da tag Git: $gitTag"
                    } else if (branch == "main" || branch == "master") {
                        env.DOCKER_TAG = "latest"
                        echo "Costruzione da branch principale: $branch"
                    } else if (branch == "develop") {
                        env.DOCKER_TAG = "develop-${commitSha}"
                        echo "Costruzione da develop: ${env.DOCKER_TAG}"
                    } else {
                        env.DOCKER_TAG = "custom-${commitSha}"
                        echo "Costruzione da branch generico: ${env.DOCKER_TAG}"
                    }
                }
            }
        }

        stage('Login a Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-token', variable: 'DOCKER_PASS')]) {
                    sh 'echo "$DOCKER_PASS" | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Build immagine Docker') {
            steps {
                sh """
                    docker build -t ${DOCKER_REPO}:${DOCKER_TAG} .
                    docker tag ${DOCKER_REPO}:${DOCKER_TAG} ${DOCKER_REPO}:latest
                """
            }
        }

        stage('Push su Docker Hub') {
            steps {
                sh """
                    docker push ${DOCKER_REPO}:${DOCKER_TAG}
                    docker push ${DOCKER_REPO}:latest
                """
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}
