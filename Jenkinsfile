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
        // If we plan to host it locally in docker
	// sh "docker run --rm -d -p80:80 gor1908/course_work1:latest"
	
	//for deploying with Ansible in cluster
	sh "ansible-playbook -i hosts ubuntu-playbook.yml --ask-become-pass"
      }
    }
  }
}
