# Yeoman with some generators and prerequisites
FROM debian:jessie

MAINTAINER Josh Cox <josh@webhosting.coop>

ENV DEBIAN_FRONTEND noninteractive

# Install node.js, then npm install yo and the generators
RUN apt-get -yq update && \
    apt-get -yq install git curl net-tools sudo bzip2 libpng-dev locales-all
RUN apt-get install -yq libavahi-compat-libdnssd-dev

RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash - && \
    apt-get -yq install nodejs

RUN npm install -g npm@2.13.0 && \
    npm install -g yo@1.4.7 bower@1.4.1 grunt-cli@0.1.13 gulp@3.9.0 && \
    npm install -g generator-webapp@1.0.1 generator-angular@0.12.1 generator-gulp-angular@0.12.1 \
    npm install -g generator-jekyllrb generator-jekyllized

# Add a yeoman user because grunt doesn't like being root
RUN adduser --disabled-password --gecos "" yeoman && \
  echo "yeoman ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Expose the port
EXPOSE 9000

# set HOME so 'npm install' and 'bower install' don't write to /
ENV HOME /home/yeoman

ENV LANG en_US.UTF-8

RUN mkdir /src && chown yeoman:yeoman /src
WORKDIR /src

ADD set_env.sh /usr/local/sbin/
RUN chmod +x /usr/local/sbin/set_env.sh
ENTRYPOINT ["set_env.sh"]

# Always run as the yeoman user
USER yeoman

# RVM install ruby
RUN ["/bin/bash", "-c",  "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3"]
RUN ["/bin/bash", "-c",  "curl -L get.rvm.io | bash -s stable"]
RUN ["/bin/bash", "-c",  "echo 'source /home/yeoman/.rvm/scripts/rvm '>>~/.bashrc"]
RUN ["/bin/bash", "-c",  "source /home/yeoman/.rvm/scripts/rvm ; rvm requirements; rvm install ruby-2.1.4; rvm use --default 2.1.4; source /home/yeoman/.rvm/scripts/rvm"]
RUN ["/bin/bash", "-c",  "source /home/yeoman/.rvm/scripts/rvm ; rvm use --default 2.1.4; gem install bundler"]
RUN sudo chown -R yeoman. /srv/www 

CMD /bin/bash

