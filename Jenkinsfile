pipeline {
    agent any

    environment {
        OCP_SERVER = 'https://api.ocptest.demo.local:6443'
        OCP_TOKEN = credentials('ocp-external-token') // Defined in Jenkins Credentials
    }

    stages {
        stage('Login to OpenShift') {
            steps {
                sh '''
                oc login $OCP_SERVER --token=$OCP_TOKEN --insecure-skip-tls-verify
                oc project cicd-pipelines
                '''
            }
        }

        stage('Check Access') {
            steps {
                sh '''
                echo "Logged in as: $(oc whoami)"
                oc get pods -n cicd-pipelines
                '''
            }
        }

        stage('Build and Deploy') {
            steps {
                sh '''
                # Assuming deployment.yaml exists in repo
                oc new-build --binary --name=my-app -l app=my-app || true
                oc start-build my-app --from-dir=. --follow
                oc apply -f deployment.yaml
                '''
            }
        }
    }
}
