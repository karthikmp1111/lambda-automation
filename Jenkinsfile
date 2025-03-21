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
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY
                    export AWS_REGION=$AWS_REGION
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
            cleanWs()
        }
    }
}
