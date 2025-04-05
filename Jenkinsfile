pipeline {
    agent any

    environment {
        OCP_SERVER = 'https://api.ocptest.demo.local:6443'
        OCP_TOKEN = credentials('ocp-external-token') // Defined in Jenkins Credentials
    }

    stages {
        stage('Download oc CLI') {
            steps {
                sh '''
                echo "Downloading oc CLI into /tmp..."
                cd /tmp
                curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz
                tar -xvzf openshift-client-linux.tar.gz oc
                chmod +x oc
                ./oc version
                '''
            }
        }

        stage('Login to OpenShift') {
            steps {
                sh '''
                cd /tmp
                ./oc login $OCP_SERVER --token=$OCP_TOKEN --insecure-skip-tls-verify
                ./oc project cicd-pipelines
                '''
            }
        }

        stage('Check Access') {
            steps {
                sh '''
                cd /tmp
                echo "Logged in as: $(./oc whoami)"
                ./oc get pods -n cicd-pipelines
                '''
            }
        }

        stage('Build and Deploy') {
            steps {
                sh '''
                cd /tmp
                # Assuming deployment.yaml exists in repo root
                ./oc new-build --binary --name=my-app -l app=my-app || true
                ./oc start-build my-app --from-dir=${WORKSPACE} --follow
                ./oc apply -f ${WORKSPACE}/deployment.yaml
                '''
            }
        }
    }
}
