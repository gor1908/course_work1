pipeline {
  environment {
    imagename = "gor1908/course_work1"
    registryCredential = 'dockerhub_id'
    dockerImage = ''
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git([url: 'https://github.com/gor1908/course_work1.git', 
    branch:'main'])

      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build imagename
        }
      }
    }
    stage('Push Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push("$BUILD_NUMBER")
             dockerImage.push('latest')

          }
        }
      }
    }
    stage('Deploy') {
      steps{
        sh "ansible-playbook ansible.yml --user=root --extra-vars \"ansible_sudo_pass=q3q3q3\" --extra-vars \"ansible_python_interpreter=/usr/bin/python3\""

      }
    }
  }
}
