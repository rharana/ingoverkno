# Use an official Ubuntu image as a parent image
FROM ubuntu:22.04

# Set the working directory
WORKDIR /app

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    gnupg \
    libssl-dev \
    zlib1g-dev \
    imagemagick \
    libicu-dev \
    locales \
    ca-certificates \
    sudo \
    libpq-dev \
    supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create and set permissions for /var/run (to ensure the socket file can be created)
RUN mkdir -p /var/run/supervisor && \
    chown -R root:root /var/run/supervisor

# Set the locale
RUN sed -i 's/# \(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

# Setup Node.js repository
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" > /etc/apt/sources.list.d/nodesource.list

# Install Node.js
RUN apt-get update && apt-get install -y nodejs

# Setup Yarn repository
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" > /etc/apt/sources.list.d/yarn.list

# Install Yarn
RUN apt-get update && apt-get install -y yarn

RUN yarn --version

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

# Copy the Gemfile and Gemfile.lock into the image
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler && bundle install

# Copy the main application.
# Copy the main application and entrypoint script
COPY . /app
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

COPY supervisord.conf /etc/supervisor/supervisord.conf

# Expose port 3000 to be accessible from the host.
EXPOSE 3000

# Set the entrypoint script to initialize the container
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

# Command to run the Rails server
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
