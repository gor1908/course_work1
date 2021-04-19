Course work on DevOps ITEA 
==========================

Task:
 Create of CI/CD system to deploy applicaion from GitHub Repository
to bare metal or cloud servers.

1.We have simple C++ CGI application (cpp-cgi.cpp), which outputs HTML page with
random number.

2.We use Jenkins to pull code from GitHub and make docker-image, which subsequently
pushed to DockerHub.

3.Dockerfile for building image has two images. One is for build C++ application
from source code, another is runtime-image, which is pulled to DockerHub.

We use two images because build tools for C++ take up a lot of disk space and don't
needed for run.

Compile-Image
-------------
	FROM ubuntu:18.04 AS compile-image
	RUN apt-get update
	RUN apt-get install -y --no-install-recommends gcc build-essential

	WORKDIR /root
	COPY cpp-cgi.cpp .
	RUN g++ -o cpp.cgi cpp-cgi.cpp

Second image builds with apache2, configured for  compiled in compile-image 
 CGI application

Runtime-Image
-------------
	FROM ubuntu:18.04 AS runtime-image
	EXPOSE 80
	RUN apt-get update
	RUN apt-get -y install apache2
	
	#load apache cgi module
	RUN a2enmod cgi
	
	RUN service apache2 restart

	#enable cgi in the website root
	#second block to allow .htaccess
	RUN echo "                      \n \
	<Directory \"/var/www/cgi-bin\">    \n \
	   AllowOverride None           \n \
	   Options ExecCGI              \n \
	   Order allow,deny            \n \
	   Allow from all               \n \
	</Directory>                    \n \
	<Directory \"/var/www/cgi-bin\">\n \
	   Options All                  \n \
	</Directory>                    \n \
	" >> /etc/apache2/apache2.conf

	RUN mkdir /var/www/cgi-bin
	COPY --from=compile-image /root/cpp.cgi /usr/lib/cgi-bin
	RUN chmod -R u+rwx,g+x,o+x /usr/lib/cgi-bin
	CMD /usr/sbin/apache2ctl -D FOREGROUND



4. Use Ansible to pull docker image from DockerHub and start it:

ansible-playbook -i hosts ubuntu_playbook.yml --ask-become-pass


