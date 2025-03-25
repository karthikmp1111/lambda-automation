// pipeline {
//     agent any

//     environment {
//         AWS_REGION = 'us-west-1'
//     }

//     parameters {
//         choice(name: 'APPLY_OR_DESTROY', choices: ['apply', 'destroy'], description: 'Choose whether to apply or destroy Terraform resources')
//     }

//     stages {
//         stage('Checkout Code') {
//             steps {
//                 git branch: 'main', url: 'https://github.com/karthikmp1111/lambda-automation.git'
//                 sh 'git fetch --unshallow || git fetch --all'
//                 sh 'ls -la'
//             }
//         }

//         stage('Setup AWS Credentials') {
//             steps {
//                 withCredentials([
//                     string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY'),
//                     string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_KEY')
//                 ]) {
//                     sh '''
//                     set -e
//                     aws configure set aws_access_key_id $AWS_ACCESS_KEY
//                     aws configure set aws_secret_access_key $AWS_SECRET_KEY
//                     aws configure set region $AWS_REGION
//                     '''
//                 }
//                 sh 'ls -la'
//             }
//         }

//         stage('Build Lambda Packages') {
//             steps {
//                 script {
//                     def lambdas = ["lambda1", "lambda2", "lambda3"]
//                     def changesDetected = false

//                     lambdas.each { lambdaName ->
//                         def packagePath = "lambda-functions/${lambdaName}/package.zip"
//                         def status = sh(script: "git diff --quiet HEAD~1 lambda-functions/${lambdaName}", returnStatus: true)

//                         if (status != 0 || !fileExists(packagePath)) {
//                             echo "🔄 Changes detected or package missing for ${lambdaName}, building..."
//                             sh "bash lambda-functions/${lambdaName}/build.sh"
//                             changesDetected = true
//                         } else {
//                             echo "✅ No changes detected in ${lambdaName}, skipping build."
//                         }
//                     }

//                     if (!changesDetected) {
//                         echo "🚀 No Lambda changes detected, skipping deployment."
//                     }
//                 }
//             }
//         }

//         stage('Terraform Init') {
//             steps {
//                 dir('terraform') {
//                     sh 'ls -la'
//                     sh 'terraform init'
//                     sh 'ls -la'
//                 }
//             }
//         }

//         stage('Terraform Validate') {
//             steps {
//                 dir('terraform') {
//                     sh 'ls -la'
//                     sh 'terraform validate'
//                 }
//             }
//         }

//         stage('Terraform Plan') {
//             steps {
//                 dir('terraform') {
//                     sh 'ls -la'
//                     sh 'terraform plan'
//                 }
//             }
//         }

//         stage('Terraform Apply') {
//             when {
//                 expression { params.APPLY_OR_DESTROY == 'apply' }
//             }
//             steps {
//                 dir('terraform') {
//                     sh 'ls -la'
//                     sh 'terraform apply -auto-approve'
//                 }
//             }
//         }

//         stage('Terraform Destroy') {
//             when {
//                 expression { params.APPLY_OR_DESTROY == 'destroy' }
//             }
//             steps {
//                 dir('terraform') {
//                     sh 'ls -la'
//                     sh 'terraform destroy -auto-approve'
//                 }
//             }
//         }
//     }
// }



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
                sh 'git fetch --unshallow || true' // Ensure full Git history for diff check
            }
        }

        stage('Setup AWS Credentials') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_KEY')
                ]) {
                    sh '''
                    set -e
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
                    def changesDetected = false

                    lambdas.each { lambdaName ->
                        def packagePath = "lambda-functions/${lambdaName}/package.zip"
                        def status = sh(script: "git diff --quiet HEAD~1 lambda-functions/${lambdaName}", returnStatus: true)

                        // Build if package.zip is missing OR there are Git changes
                        if (status != 0 || !fileExists(packagePath)) {
                            echo "🔄 Changes detected or package missing for ${lambdaName}, building..."
                            sh "bash lambda-functions/${lambdaName}/build.sh"
                            changesDetected = true
                        } else {
                            echo "✅ No changes detected in ${lambdaName}, skipping build."
                        }
                    }

                    if (!changesDetected) {
                        echo "🚀 No Lambda changes detected, skipping deployment."
                    }
                }
            }
        }

        stage('Check for Package Files') {
            steps {
                sh '''
                echo "🔍 Checking if Lambda package files exist..."
                ls -la lambda-functions/lambda1/
                ls -la lambda-functions/lambda2/
                ls -la lambda-functions/lambda3/
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
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
}
