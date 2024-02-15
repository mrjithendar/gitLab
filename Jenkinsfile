pipeline {

    agent any

    environment {
        clusterName = "roboshop-eks-cluster-demo"
        awsRegion = "us-east-1"
        APP       = "gitlab"
    }

    parameters {
        choice(name: 'infra', choices: ['create', 'delete'], description: 'Pick an option to Create/Delete Infrastructure')
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
            when {
                expression {infra == 'create'}
            }
            steps {
                withAWS(credentials: 'awsCreds', region: 'us-east-1') {
                    sh "terraform init -reconfigure"
                    sh "terraform plan -out planfile"
                    sh "terraform apply planfile"
                    sh "sh kubectl get ingress -lrelease=gitlab -n ${APP}"
                    sh """
                        PASSWORD=$(kubectl get secret ${APP}-${APP}-initial-root-password -o jsonpath='{.data.password}' -n ${APP})
                        sh echo '${APP} Credentials Username: admin and Password is: $(echo ${PASSWORD} | base64 --decode)'
                        """
                }
            }
        }

        stage('Deploy gitLab') {
            when {
                expression {infra == 'delete'}
            }
            steps {
                withAWS(credentials: 'awsCreds', region: 'us-east-1') {
                    sh "terraform init -reconfigure"
                    sh "terraform destroy --auto-approve"
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
