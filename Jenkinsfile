pipeline {
    agent {
        label 'agent1'
    }

    environment {
        GIT_COMMIT_HASH = ''
        BRANCH_NAME = ''
        dockerTag = ''
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    GIT_COMMIT_HASH = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    BRANCH_NAME = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    def rawTag = sh(script: "git describe --tags --exact-match || true", returnStdout: true).trim()

                    if (rawTag) {
                        dockerTag = rawTag
                    } else if (BRANCH_NAME == "main") {
                        dockerTag = "latest"
                    } else if (BRANCH_NAME == "develop") {
                        dockerTag = "develop-${GIT_COMMIT_HASH}"
                    } else {
                        dockerTag = "${BRANCH_NAME}-${GIT_COMMIT_HASH}"
                    }

                    echo "📦 Docker Tag determinato: ${dockerTag}"
                }
            }
        }

        stage('Login a Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Build immagine Docker') {
            steps {
                script {
                    sh "docker build -t valentinlisci/flask-app-example-build:${dockerTag} ."

                    if (dockerTag == "latest") {
                        sh "docker tag valentinlisci/flask-app-example-build:latest valentinlisci/flask-app-example-build:latest"
                    }
                }
            }
        }

        stage('Push immagine Docker') {
            steps {
                script {
                    sh "docker push valentinlisci/flask-app-example-build:${dockerTag}"

                    if (dockerTag == "latest") {
                        sh "docker push valentinlisci/flask-app-example-build:latest"
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                sh 'docker logout || true'
            }
        }
    }
}
