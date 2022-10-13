pipeline {
  environment {
    ID_DOCKER = "${ID_DOCKER_PARAMS}"
    IMAGE_NAME = "ic-webapp"
    ODOO_URL = "https://www.gmail.com"
    PGADMIN_URL = "https://www.whitehouse.gov"
    PORT_EXPOSED = "8000" //à paraméter dans le job
    STAGING = "${ID_DOCKER}-staging"
    PRODUCTION = "${ID_DOCKER}-production"
  }    
  
  agent none
  stages {

    stage('Build image') {
      agent any
      steps {
        script {
          sh '''
            cd sources/ic-web-app 
            IMAGE_VERSION_TAG=$(awk '/version/ {sub(/^.* *version/,""); print $2}' releases.txt)
            docker build -t ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_VERSION_TAG .
            '''
        }
      }
    }

      stage('Run container based on builded image') {
        agent any
        steps {
            script {
              sh '''
                cd sources/ic-web-app
                IMAGE_VERSION_TAG=$(awk '/version/ {sub(/^.* *version/,""); print $2}' releases.txt)
                echo "Clean Environment"
                docker rm -f $IMAGE_NAME || echo "container does not exist"
                docker run --name $IMAGE_NAME -d -p ${PORT_EXPOSED}:8080 ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_VERSION_TAG
                sleep 15
              '''
              }
          }
      }

    stage('Test image') {
        agent any
        steps {
          script {
            //Test that machine finds the corresponding url for each app
            sh "curl http://172.17.0.1:${PORT_EXPOSED} | grep 'a href'"
          }
        }
    }

      stage('Clean Container') {
          agent any
          steps {
             script {
               sh '''
	       	        echo "Clean du container"
	       	        docker stop ${IMAGE_NAME} && docker rm ${IMAGE_NAME}
          	     '''
              }
          }
      }

     stage ('Login and Push Image on docker hub') {
          agent any
          environment{
            DOCKERHUB_PASSWORD=credentials('DOCKERHUB_PASS')
          }
          steps {
             script {
               sh '''
                cd sources/ic-web-app
                IMAGE_VERSION_TAG=$(awk '/version/ {sub(/^.* *version/,""); print $2}' releases.txt)
			          echo $DOCKERHUB_PASSWORD | docker login -u $ID_DOCKER --password-stdin
			          docker push ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_VERSION_TAG
               '''
             }
          }
        }
        stage ("PRODUCTION - Deploy Application") {
          agent any
          when {
		        branch 'main'
          }
          environment{
            VAULT_PASS_FILE = credentials('ANSIBLE_VAULT_PASS')
          }
          steps {
            script {
              sh '''
              cd sources/ansible-sources/
              export ANSIBLE_CONFIG=$./ansible.cfg
              ansible-playbook master.yml --vault-password-file $VAULT_PASS_FILE -i hosts.yml
              '''
           }
          }
        }
  }
}
 
