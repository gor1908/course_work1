# This is the first image:
# Development image with build tools
FROM ubuntu:18.04 AS compile-image
RUN apt-get update
RUN apt-get install -y --no-install-recommends gcc build-essential

WORKDIR /root
COPY cpp-cgi.cpp .
RUN g++ -o cpp.cgi cpp-cgi.cpp

# This is the second and final image; it copies the compiled
# CGI-script over but starts from the base ubuntu:18.04 image.
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
   Order allow, deny            \n \
   Allow from all               \n \
</Directory>                    \n \
<Directory \"/var/www/cgi-bin\">\n \
   Options All                  \n \
</Directory>                    \n \
" >> /etc/apache2/apache2.conf

RUN mkdir /var/www/cgi-bin

COPY --from=compile-image /root/cpp.cgi /var/www/cgi-bin

RUN chmod -R u+rwx,g+x,o+x /var/www/cgi-bin

CMD /usr/sbin/apache2ctl -D FOREGROUND

