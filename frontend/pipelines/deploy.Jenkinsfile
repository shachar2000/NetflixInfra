pipeline {
    agent any

    parameters {
        string(name: 'SERVICE_NAME', defaultValue: 'frontend-deployment.yaml', description: 'The name of the YAML manifest file')
        string(name: 'IMAGE_FULL_NAME_PARAM', defaultValue: 'shacharavraham/netflix-images-frontend:v1.0.9', description: 'The full name of the Docker image to deploy')
    }

    environment {
        // הגדרת credentials
        GIT_CREDENTIALS_ID = '6f109c2d-f7f2-481b-991c-f202f8eb10ed'
    }

    stages {
        stage('Deploy') {
            steps {
                script {
                    echo "SERVICE_NAME: ${params.SERVICE_NAME}"
                    echo "IMAGE_FULL_NAME_PARAM: ${params.IMAGE_FULL_NAME_PARAM}"

                    // שינוי שם התמונה בקובץ YAML
                    sh """
                    sed -i "s|image: shacharavraham/netflix-images-frontend:.*|image: ${params.IMAGE_FULL_NAME_PARAM}|" ${params.SERVICE_NAME}
                    """

                    // התחייבות לשינויים
                    withCredentials([usernamePassword(credentialsId: "${env.GIT_CREDENTIALS_ID}", usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_TOKEN')]) {
                        sh """
                        git config user.name "shachar2000"
                        git config user.email "shacharavrahm123@gmail.com"
                        git add ${params.SERVICE_NAME}
                        git commit -m "Update Docker image to ${params.IMAGE_FULL_NAME_PARAM}"
                        git push https://github.com/shachar2000/NetflixInfra.git
                        """
                    }
                }
            }
        }
    }
    post {
        cleanup {
            cleanWs()
        }
    }
}
