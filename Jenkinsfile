pipeline {

    agent any

    environment {
        clusterName = "roboshop-eks-cluster-demo"
        awsRegion = "us-east-1"
    }

    stages {
        stage('Import EKS Cluster') {
            steps {
                withAWS(credentials: 'awsCreds', region: 'us-east-1') {
                    sh "aws eks update-kubeconfig --region ${awsRegion} --name ${clusterName}"
                }
            }
        }
        stage('Deploy gitLab') {
            steps {
                withAWS(credentials: 'awsCreds', region: 'us-east-1') {
                    sh "sh install.sh"
                }
            }
        }
    }
    options {
        preserveStashes()
        timestamps()
    }
    post {
        always {
            cleanWs()
        }
    }
}
