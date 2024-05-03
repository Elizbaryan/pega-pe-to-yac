sudo dnf -y install java-11-openjdk-headless

wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.88/bin/apache-tomcat-9.0.88.tar.gz

sudo mkdir /opt/tomcat
sudo mkdir /opt/pegatemp
sudo tar xvf apache-tomcat-*tar.gz -C /opt/tomcat --strip-components=1
sudo cp -f context.xml /opt/tomcat/conf/context.xml
sudo cp -f postgresql-42.0.0.jar /opt/tomcat/lib/postgresql-42.0.0.jar
sudo cp prhelp.war /opt/tomcat/webapps
sudo cp prweb.war /opt/tomcat/webapps

echo TODO copy WAR-s here!!!!

sudo groupadd tomcat
sudo useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat

sudo chgrp -R tomcat /opt/tomcat
sudo chown -R tomcat /opt/tomcat
sudo chgrp -R tomcat /opt/pegatemp
sudo chown -R tomcat /opt/pegatemp

sudo cp tomcat.service /etc/systemd/system/tomcat.service

sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat

exit
