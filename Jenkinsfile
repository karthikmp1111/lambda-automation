// // pipeline {
// //     agent any

// //     environment {
// //         AWS_REGION = 'us-west-1'
// //     }

// //     parameters {
// //         choice(name: 'APPLY_OR_DESTROY', choices: ['apply', 'destroy'], description: 'Choose whether to apply or destroy Terraform resources')
// //     }

// //     stages {
// //         stage('Checkout Code') {
// //             steps {
// //                 git branch: 'main', url: 'https://github.com/karthikmp1111/lambda-automation.git'
// //             }
// //         }

// //         stage('Setup AWS Credentials') {
// //             steps {
// //                 withCredentials([
// //                     string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY'),
// //                     string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_KEY')
// //                 ]) {
// //                     sh '''
// //                     aws configure set aws_access_key_id $AWS_ACCESS_KEY
// //                     aws configure set aws_secret_access_key $AWS_SECRET_KEY
// //                     aws configure set region $AWS_REGION
// //                     '''
// //                 }
// //             }
// //         }

// //         // stage('Build Lambda Packages') {
// //         //     steps {
// //         //         script {
// //         //             def lambdas = ["lambda1", "lambda2", "lambda3"]
// //         //             lambdas.each { lambdaName ->
// //         //                 def packageZip = "lambda-functions/${lambdaName}/package.zip"
// //         //                 if (sh(script: "git diff --quiet HEAD~1 lambda-functions/${lambdaName}", returnStatus: true) != 0 || !fileExists(packageZip)) {
// //         //                     echo "Building ${lambdaName}..."
// //         //                     sh "bash lambda-functions/${lambdaName}/build.sh"
// //         //                 } else {
// //         //                     echo "No changes detected in ${lambdaName}, skipping build."
// //         //                 }
// //         //             }
// //         //         }
// //         //     }
// //         // }
// //         stage('Build Lambda Packages') {
// //             when {
// //                 expression { params.APPLY_OR_DESTROY == 'apply' }
// //             }
// //             steps {
// //                 script {
// //                     def lambdas = ["lambda1", "lambda2", "lambda3"]
// //                     lambdas.each { lambdaName ->
// //                         def packageZip = "lambda-functions/${lambdaName}/package.zip"
// //                         if (sh(script: "git diff --quiet HEAD~1 lambda-functions/${lambdaName}", returnStatus: true) != 0 || !fileExists(packageZip)) {
// //                             echo "Building ${lambdaName}..."
// //                             sh "bash lambda-functions/${lambdaName}/build.sh"
// //                         } else {
// //                             echo "No changes detected in ${lambdaName}, skipping build."
// //                         }
// //                     }
// //                 }
// //             }
// //         }


// //         stage('Verify Lambda Packages') {
// //             steps {
// //                 script {
// //                     def lambdas = ["lambda1", "lambda2", "lambda3"]
// //                     lambdas.each { lambdaName ->
// //                         def packageZip = "lambda-functions/${lambdaName}/package.zip"
// //                         if (!fileExists(packageZip)) {
// //                             error "❌ ERROR: ${packageZip} is missing. Ensure the build step executed correctly."
// //                         }
// //                     }
// //                 }
// //             }
// //         }

// //         stage('Terraform Init') {
// //             steps {
// //                 dir('terraform') {
// //                     sh 'terraform init'
// //                 }
// //             }
// //         }

// //         stage('Terraform Plan') {
// //             steps {
// //                 dir('terraform') {
// //                     sh 'terraform plan'
// //                 }
// //             }
// //         }

// //         stage('Terraform Apply') {
// //             when {
// //                 expression { params.APPLY_OR_DESTROY == 'apply' }
// //             }
// //             steps {
// //                 dir('terraform') {
// //                     sh 'terraform apply -auto-approve'
// //                 }
// //             }
// //         }

// //         stage('Terraform Destroy') {
// //             when {
// //                 expression { params.APPLY_OR_DESTROY == 'destroy' }
// //             }
// //             steps {
// //                 catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
// //                     dir('terraform') {
// //                         sh 'terraform destroy -auto-approve'
// //                     }
// //                 }
// //             }
// //         }
// //     }

// //     post {
// //         always {
// //             echo "Cleaning up Jenkins workspace..."
// //             deleteDir()
// //         }
// //     }
// // }


// // pipeline {
// //     agent any

// //     environment {
// //         AWS_REGION = 'us-west-1'
// //     }

// //     parameters {
// //         choice(name: 'APPLY_OR_DESTROY', choices: ['apply', 'destroy'], description: 'Choose whether to apply or destroy Terraform resources')
// //     }

// //     stages {
// //         stage('Checkout Code') {
// //             steps {
// //                 checkout([
// //                     $class: 'GitSCM',
// //                     branches: [[name: '*/main']],
// //                     userRemoteConfigs: [[url: 'https://github.com/karthikmp1111/lambda-automation.git']],
// //                     extensions: [[$class: 'CleanCheckout']]
// //                 ])
// //             }
// //         }

// //         stage('Setup AWS Credentials') {
// //             steps {
// //                 withCredentials([
// //                     string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY'),
// //                     string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_KEY')
// //                 ]) {
// //                     sh '''
// //                     aws configure set aws_access_key_id $AWS_ACCESS_KEY
// //                     aws configure set aws_secret_access_key $AWS_SECRET_KEY
// //                     aws configure set region $AWS_REGION
// //                     '''
// //                 }
// //             }
// //         }

// //         stage('Build Lambda Packages') {
// //             when {
// //                 expression { params.APPLY_OR_DESTROY == 'apply' }
// //             }
// //             steps {
// //                 script {
// //                     def lambdas = ["lambda1", "lambda2", "lambda3"]
// //                     lambdas.each { lambdaName ->
// //                         def packageZip = "lambda-functions/${lambdaName}/package.zip"
// //                         echo "Checking if ${lambdaName} needs to be rebuilt..."
// //                         def diffResult = sh(script: "git diff --quiet HEAD~1 lambda-functions/${lambdaName}", returnStatus: true)
// //                         echo "Git diff result for ${lambdaName}: ${diffResult}"

// //                         if (diffResult != 0 || !fileExists(packageZip)) {
// //                             echo "Building ${lambdaName}..."
// //                             sh "bash lambda-functions/${lambdaName}/build.sh"
// //                         } else {
// //                             echo "✅ No changes detected in ${lambdaName}, skipping build."
// //                         }
// //                     }
// //                 }
// //             }
// //         }

// //         stage('Verify Lambda Packages') {
// //             when {
// //                 expression { params.APPLY_OR_DESTROY == 'apply' }
// //             }
// //             steps {
// //                 script {
// //                     def lambdas = ["lambda1", "lambda2", "lambda3"]
// //                     lambdas.each { lambdaName ->
// //                         def packageZip = "lambda-functions/${lambdaName}/package.zip"
// //                         if (!fileExists(packageZip)) {
// //                             error "❌ ERROR: ${packageZip} is missing. Ensure the build step executed correctly."
// //                         } else {
// //                             echo "✅ Found package: ${packageZip}"
// //                         }
// //                     }
// //                 }
// //             }
// //         }

// //         stage('Terraform Init') {
// //             steps {
// //                 dir('terraform') {
// //                     sh '''
// //                     terraform init -backend-config="bucket=bg-kar-terraform-state" \
// //                                    -backend-config="key=multi-lambda/terraform.tfstate" \
// //                                    -backend-config="region=us-west-1"
// //                     '''
// //                 }
// //             }
// //         }

// //         stage('Terraform Plan') {
// //             steps {
// //                 dir('terraform') {
// //                     sh 'terraform plan'
// //                 }
// //             }
// //         }

// //         stage('Terraform Apply') {
// //             when {
// //                 expression { params.APPLY_OR_DESTROY == 'apply' }
// //             }
// //             steps {
// //                 dir('terraform') {
// //                     sh 'terraform apply -auto-approve'
// //                 }
// //             }
// //         }

// //         stage('Terraform Destroy') {
// //             when {
// //                 expression { params.APPLY_OR_DESTROY == 'destroy' }
// //             }
// //             steps {
// //                 catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
// //                     dir('terraform') {
// //                         sh 'terraform destroy -auto-approve'
// //                     }
// //                 }
// //             }
// //         }
// //     }

// //     post {
// //         always {
// //             echo "Cleaning up Jenkins workspace..."
// //             deleteDir()
// //         }
// //     }
// // }


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
//                 checkout([
//                     $class: 'GitSCM',
//                     branches: [[name: '*/main']],
//                     userRemoteConfigs: [[url: 'https://github.com/karthikmp1111/lambda-automation.git']],
//                     extensions: [[$class: 'CleanBeforeCheckout']]
//                 ])
//             }
//         }

//         stage('Setup AWS Credentials') {
//             steps {
//                 withCredentials([
//                     string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY'),
//                     string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_KEY')
//                 ]) {
//                     sh '''
//                     aws configure set aws_access_key_id $AWS_ACCESS_KEY
//                     aws configure set aws_secret_access_key $AWS_SECRET_KEY
//                     aws configure set region $AWS_REGION
//                     '''
//                 }
//             }
//         }

//         stage('Build Lambda Packages') {
//             steps {
//                 script {
//                     def lambdas = ["lambda1", "lambda2", "lambda3"]
//                     lambdas.each { lambdaName ->
//                         def packageZip = "lambda-functions/${lambdaName}/package.zip"
//                         echo "Checking if ${lambdaName} needs to be rebuilt..."
//                         def diffResult = sh(script: "git diff --quiet HEAD~1 lambda-functions/${lambdaName}", returnStatus: true)
//                         echo "Git diff result for ${lambdaName}: ${diffResult}"

//                         if (diffResult != 0 || !fileExists(packageZip)) {
//                             echo "Building ${lambdaName}..."
//                             sh "bash lambda-functions/${lambdaName}/build.sh"
//                         } else {
//                             echo "✅ No changes detected in ${lambdaName}, skipping build."
//                         }
//                     }
//                 }
//             }
//         }

//         stage('Verify Lambda Packages') {
//             steps {
//                 script {
//                     def lambdas = ["lambda1", "lambda2", "lambda3"]
//                     lambdas.each { lambdaName ->
//                         def packageZip = "lambda-functions/${lambdaName}/package.zip"
//                         if (!fileExists(packageZip)) {
//                             error "❌ ERROR: ${packageZip} is missing. Ensure the build step executed correctly."
//                         } else {
//                             echo "✅ Found package: ${packageZip}"
//                         }
//                     }
//                 }
//             }
//         }

//         stage('Terraform Init') {
//             steps {
//                 dir('terraform') {
//                     sh '''
//                     terraform init -backend-config="bucket=bg-kar-terraform-state" \
//                                    -backend-config="key=multi-lambda/terraform.tfstate" \
//                                    -backend-config="region=us-west-1"
//                     '''
//                 }
//             }
//         }

//         stage('Terraform Plan') {
//             steps {
//                 dir('terraform') {
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
//                     sh 'terraform apply -auto-approve'
//                 }
//             }
//         }

//         stage('Terraform Destroy') {
//             when {
//                 expression { params.APPLY_OR_DESTROY == 'destroy' }
//             }
//             steps {
//                 catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
//                     dir('terraform') {
//                         sh 'terraform destroy -auto-approve'
//                     }
//                 }
//             }
//         }
//     }

//     post {
//         always {
//             echo "Cleaning up Jenkins workspace..."
//             deleteDir()
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
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: 'https://github.com/karthikmp1111/lambda-automation.git']],
                    extensions: [[$class: 'CleanBeforeCheckout']]
                ])
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

        stage('Detect Changes') {
            steps {
                script {
                    env.TERRAFORM_CHANGED = sh(script: "git diff --quiet HEAD~1 terraform/ || echo 'changed'", returnStdout: true).trim()
                    env.LAMBDA1_CHANGED = sh(script: "git diff --quiet HEAD~1 lambda-functions/lambda1 || echo 'changed'", returnStdout: true).trim()
                    env.LAMBDA2_CHANGED = sh(script: "git diff --quiet HEAD~1 lambda-functions/lambda2 || echo 'changed'", returnStdout: true).trim()
                    env.LAMBDA3_CHANGED = sh(script: "git diff --quiet HEAD~1 lambda-functions/lambda3 || echo 'changed'", returnStdout: true).trim()
                }
            }
        }

        stage('Build & Deploy Lambda Functions') {
            when {
                expression { params.APPLY_OR_DESTROY == 'apply' }
            }
            steps {
                script {
                    def lambdaFunctions = [
                        'lambda1': env.LAMBDA1_CHANGED,
                        'lambda2': env.LAMBDA2_CHANGED,
                        'lambda3': env.LAMBDA3_CHANGED
                    ]

                    lambdaFunctions.each { lambdaName, changed ->
                        if (changed == 'changed') {
                            echo "Building and deploying ${lambdaName}..."
                            sh "bash lambda-functions/${lambdaName}/build.sh"
                            sh """
                            aws lambda update-function-code \
                                --function-name ${lambdaName} \
                                --zip-file fileb://lambda-functions/${lambdaName}/package.zip
                            """
                            sh """
                            aws lambda publish-version --function-name ${lambdaName}
                            """
                        } else {
                            echo "✅ No changes detected in ${lambdaName}, skipping deployment."
                        }
                    }
                }
            }
        }

        // stage('Verify Lambda Packages') {
        //     when {
        //         expression { params.APPLY_OR_DESTROY == 'apply' }
        //     }
        //     steps {
        //         script {
        //             def lambdas = ["lambda1", "lambda2", "lambda3"]
        //             lambdas.each { lambdaName ->
        //                 def packageZip = "lambda-functions/${lambdaName}/package.zip"
        //                 if (!fileExists(packageZip)) {
        //                     error "❌ ERROR: ${packageZip} is missing. Ensure the build step executed correctly."
        //                 } else {
        //                     echo "✅ Found package: ${packageZip}"
        //                 }
        //             }
        //         }
        //     }
        // }

        stage('Verify Lambda Packages') {
            steps {
                script {
                    def lambdas = ["lambda1", "lambda2", "lambda3"]
                    def s3_bucket = "bg-kar-lambda-bucket" // Replace with your actual bucket name
                    def s3_prefix = "lambda-packages/"  // The S3 folder where ZIPs are stored

                    lambdas.each { lambdaName ->
                        def packageZip = "lambda-functions/${lambdaName}/package.zip"

                        if (!fileExists(packageZip)) {
                            echo "⚠️ ${packageZip} is missing locally. Attempting to download from S3..."
                            
                            // Try downloading from S3
                            def s3_key = "${s3_prefix}${lambdaName}.zip"
                            sh "aws s3 cp s3://${s3_bucket}/${s3_key} ${packageZip} || true"

                            if (!fileExists(packageZip)) {
                                error "❌ ERROR: ${packageZip} is missing and could not be retrieved from S3."
                            } else {
                                echo "✅ Retrieved ${packageZip} from S3."
                            }
                        } else {
                            echo "✅ Found package: ${packageZip}"
                        }
                    }
                }
            }
        }

        stage('Terraform Init') {
            when {
                expression { env.TERRAFORM_CHANGED == 'changed' }
            }
            steps {
                dir('terraform') {
                    sh '''
                    terraform init -backend-config="bucket=bg-kar-terraform-state" \
                                   -backend-config="key=multi-lambda/terraform.tfstate" \
                                   -backend-config="region=us-west-1"
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            when {
                expression { env.TERRAFORM_CHANGED == 'changed' }
            }
            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.APPLY_OR_DESTROY == 'apply' && env.TERRAFORM_CHANGED == 'changed' }
            }
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.APPLY_OR_DESTROY == 'destroy' && env.TERRAFORM_CHANGED == 'changed' }
            }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    dir('terraform') {
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up Jenkins workspace..."
            deleteDir()
        }
    }
}
