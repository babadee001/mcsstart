echo 'Enter your instance IP'
read ip
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

nginxSetup(){
    echo '############################## nginx ########################################'
    sudo apt-get install nginx
    sudo /etc/init.d/nginx start
    if [ -d /etc/nginx/sites-enabled/default ]; then
        sudo rm -rf /etc/nginx/sites-enabled/default
    fi
    if [ -d /etc/nginx/sites-enabled/mcs ]; then
        echo ' ######################## Removing existing config for app ##############################'
        sudo rm -rf /etc/nginx/sites-available/mcs
        sudo rm -rf /etc/nginx/sites-enabled/mcs
    fi

    sudo bash -c 'cat > /etc/nginx/sites-available/mcs <<EOF
    server {
            listen 80;
            server_name jenkins;
            location / {
                    proxy_pass 'http://$ip:8080';
            }
    }'
    sudo ln -s /etc/nginx/sites-available/mcs /etc/nginx/sites-enabled/mcs
    sudo service nginx restart
}

awscliSetup(){
    #install Python version 2.7 if it was not already installed during the JDK #prerequisite installation
    sudo apt-get install python2.7
    #install Pip package management for python
    sudo apt-get install python-pip
    #install AWS CLI
    sudo pip install awscli
    sudo apt install awscli
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

awscliconfig(){
    #configure AWS
    aws configure   
}

main(){
    javaSetup
    dockerSetup
    awscliSetup
    nginxSetup
    configureJenkins
    awscliconfig
}
main