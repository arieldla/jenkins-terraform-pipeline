pipeline {
    agent any

    environment {
        AWS_CONFIG_FILE = '/var/jenkins_home/.aws/config'
        AWS_PROFILE     = 'rolesanywhere'
        TF_DIR          = 'terraform'
        TF_VAR_environment = 'lab'
    }

    stages {
        stage('Verify AWS Auth') {
            steps {
                sh '''
                    echo "=== Verifying IAM Roles Anywhere ==="
                    aws sts get-caller-identity
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    sh '''
                        echo "=== Terraform Init ==="
                        terraform init -input=false
                    '''
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_DIR}") {
                    sh '''
                        echo "=== Terraform Plan ==="
                        terraform plan -input=false -out=tfplan
                    '''
                }
            }
        }

        stage('Approval') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    input message: 'Apply Terraform plan?', ok: 'Apply'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                dir("${TF_DIR}") {
                    sh '''
                        echo "=== Terraform Apply ==="
                        terraform apply -input=false tfplan
                    '''
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                dir("${TF_DIR}") {
                    timeout(time: 10, unit: 'MINUTES') {
                        input message: 'DESTROY all resources?', ok: 'Destroy'
                    }
                    sh 'terraform destroy -input=false -auto-approve'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo "Pipeline completed successfully - deployed via IAM Roles Anywhere"
        }
        failure {
            echo "Pipeline failed - check logs above"
        }
    }
}
