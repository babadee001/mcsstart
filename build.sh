javaSetup(){
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get install python-software-properties
    sudo apt-get update
    sudo apt-get install oracle-java8-installer
}

dockerSetup(){
    sudo apt-get update
    sudo apt-get install docker-engine
    sudo apt-get install apt-transport-https ca-certificates
    sudo apt install docker.io
}

awscliSetup(){
    #install Python version 2.7 if it was not already installed during the JDK #prerequisite installation
    sudo apt-get install python2.7
    #install Pip package management for python
    sudo apt-get install python-pip
    #install AWS CLI
    sudo pip install awscli
}

configureJenkins(){
    wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
    #create a sources list for jenkins
    sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

    #update your local package list
    sudo apt-get update

    #install jenkins
    sudo apt-get install jenkins
    #add Jenkins user to docker user group
    sudo usermod -aG docker jenkins
    echo "change Jenkins password"
    sudo passwd jenkins
    su – jenkins
}

awscliSetup(){
    #configure AWS
    aws configure   
}