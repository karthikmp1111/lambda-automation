pipeline {
    agent any

    environment {
        AWS_REGION = "us-west-1"
    }

    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'main', 
                    credentialsId: 'your-git-credentials', 
                    url: 'https://github.com/karthikmp1111/multi-lambda.git'
            }
        }

        stage('Setup AWS Credentials') {
            steps {
                withCredentials([aws(credentialsId: 'your-aws-credentials-id')]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    export AWS_REGION=us-west-1
                    '''
                }
            }
        }

        stage('Build Lambda Packages') {
            steps {
                script {
                    def lambdas = ["lambda1", "lambda2", "lambda3"]
                    lambdas.each { lambdaName ->
                        def packagePath = "lambda-functions/${lambdaName}/package.zip"
                        
                        // Check if package.zip exists OR if the Lambda function has changed
                        def packageExists = sh(script: "[ -f ${packagePath} ] && echo 'exists'", returnStdout: true).trim()
                        def lambdaChanged = sh(script: "git diff --quiet HEAD~1 lambda-functions/${lambdaName}", returnStatus: true)

                        if (packageExists != "exists" || lambdaChanged != 0) {
                            echo "🔄 Rebuilding ${lambdaName} because package.zip is missing or Lambda changed"
                            sh "bash lambda-functions/${lambdaName}/build.sh"
                        } else {
                            echo "✅ No changes detected in ${lambdaName}, skipping build."
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
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
