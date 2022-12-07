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
    }
    post {
        always{
            deleteDir()
        }
    }
}