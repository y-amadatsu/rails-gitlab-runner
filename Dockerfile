FROM ruby:2.6.1
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN \
    apt-get update && \
    apt-get install -y \
        unzip \
        nodejs \
        mysql-client \
        postgresql-client \
        sqlite3 \
        --no-install-recommends && rm -rf /var/lib/apt/lists/*
ENV RAILS_VERSION 5.2.2
RUN gem install rails --version "$RAILS_VERSION"
ENV CHROMEDRIVER_VERSION 2.46
RUN \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    wget http://chromedriver.storage.googleapis.com/"$CHROMEDRIVER_VERSION"/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    chmod +x chromedriver && \
    mv -f chromedriver /usr/local/share/chromedriver && \
    ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver && \
    ln -s /usr/local/share/chromedriver /usr/bin/chromedriver
RUN \
    apt-get update && \
    apt-get install -y \
        google-chrome-stable \
        xvfb \
        --no-install-recommends && rm -rf /var/lib/apt/lists/*