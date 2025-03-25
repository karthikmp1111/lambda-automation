pipeline {
    agent any

    environment {
        AWS_REGION = 'us-west-1'
    }

    parameters {
        choice(name: 'APPLY_OR_DESTROY', choices: ['apply', 'destroy'], description: 'Choose whether to apply or destroy Terraform resources')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/karthikmp1111/multi-lambda.git'
            }
        }

        stage('Setup AWS Credentials') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_KEY')
                ]) {
                    sh '''
                    aws configure set aws_access_key_id $AWS_ACCESS_KEY
                    aws configure set aws_secret_access_key $AWS_SECRET_KEY
                    aws configure set region $AWS_REGION
                    '''
                }
            }
        }

        stage('Build Lambda Packages') {
            steps {
                script {
                    def lambdas = ["lambda1", "lambda2", "lambda3"]
                    lambdas.each { lambdaName ->
                        def packageZip = "lambda-functions/${lambdaName}/package.zip"
                        if (sh(script: "git diff --quiet HEAD~1 lambda-functions/${lambdaName}", returnStatus: true) != 0 || !fileExists(packageZip)) {
                            echo "Building ${lambdaName}..."
                            sh "bash lambda-functions/${lambdaName}/build.sh"
                        } else {
                            echo "No changes detected in ${lambdaName}, skipping build."
                        }
                    }
                }
            }
        }

        stage('Verify Lambda Packages') {
            steps {
                script {
                    def lambdas = ["lambda1", "lambda2", "lambda3"]
                    lambdas.each { lambdaName ->
                        def packageZip = "lambda-functions/${lambdaName}/package.zip"
                        if (!fileExists(packageZip)) {
                            error "❌ ERROR: ${packageZip} is missing. Ensure the build step executed correctly."
                        }
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.APPLY_OR_DESTROY == 'apply' }
            }
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.APPLY_OR_DESTROY == 'destroy' }
            }
            steps {
                dir('terraform') {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up Jenkins workspace..."
            deleteDir() // Ensures the workspace is cleaned up after execution
        }
    }
}
