pipeline {
    agent any
    
    tools {
        "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform1.1.2"
    }

    environment {
        TF_HOME = tool('terraform1.1.2')
        TF_IN_AUTOMATION = "true"
        PATH = "$TFHOME:$PATH"
    }

    stages {
        stage("Init Infrastructure") {
            steps{
                dir('infrastructure/'){
                    sh "terraform init -input=false"
                    sh "echo \$PWD"
                    sh "whoami"
                }
            }
        }
        
        stage("Terraform validate"){
            steps{
                dir('infrastructure/'){
                    sh "terraform validate"
                }
            }
        }

        stage("Terraform plan"){
            steps{ 
                dir('infrastructure/'){
                    withAWS(credentials: 'terraform', region: 'ap-southeast-1'){
                        script {
                            // try {
                            //     sh "terraform workspace new $WORKSPACE"
                            // } catch(error){
                            //     sh "terraform workspace select $WORKSPACE"
                            // }
                            sh "terraform plan -out terraform.tfplan; echo \$? > status"
                            stash name: "terraform-plan", includes: "terraform.tfplan"
                        }
                    }
                }
            }
        }

        stage('Terraform apply'){
            steps {
                script{
                    def apply = false
                    try {
                        input message: 'Can you please confirm the apply', ok: 'Ready to Apply the Configuration'
                        apply = true 
                    } catch (err) {
                        apply = false 
                        currentBuild.resule = 'UNSTABLE'
                    }
                    if(apply){
                        dir('infrastructure/'){
                            withAWS(credentials: 'terraform', region: 'ap-southeast-1'){
                                unstash "terraform-plan"
                                sh 'terraform apply terraform.tfplan'
                            }

                        }
                    }
                }
            }
        }
    }
    post {
        always{
            deleteDir()
        }
    }
}