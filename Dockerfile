# Use an official Ubuntu image as a parent image
FROM ubuntu:22.04

# Set the working directory
WORKDIR /app

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies including ca-certificates
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libssl-dev \
    zlib1g-dev \
    postgresql \
    libpq-dev \
    nodejs \
    yarn \
    imagemagick \
    libicu-dev \
    locales \
    ca-certificates \
    sudo \
    gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the locale
RUN sed -i 's/# \(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

# Install rbenv and ruby-build
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /etc/profile.d/rbenv.sh && \
    echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh && \
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    ~/.rbenv/plugins/ruby-build/install.sh

# Ensure rbenv is on PATH and initialized
ENV PATH="/root/.rbenv/bin:/root/.rbenv/shims:${PATH}"

# Install Ruby using rbenv
RUN rbenv install 3.1.1 && rbenv global 3.1.1

# Install rbenv-vars
RUN git clone https://github.com/rbenv/rbenv-vars.git "$(rbenv root)"/plugins/rbenv-vars

# Configure PostgreSQL user
RUN service postgresql start && \
    su postgres -c "psql -c \"CREATE USER decidim_app WITH SUPERUSER CREATEDB NOCREATEROLE PASSWORD 'thepassword'\""

# Remove any existing Node.js installations and install Node.js and Yarn from official sources
RUN apt-get update && apt-get install -y --no-install-recommends gnupg && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get remove -y nodejs libnode* && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs yarn

# Install the decidim gem
RUN gem install decidim

COPY . /app

RUN bundle install

# Start the server
CMD ["bin/dev"]
