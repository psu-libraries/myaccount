FROM harbor.libraries.psu.edu/library/ruby-3.4.11-node-22-yarn-4.18.1 AS base
ARG UID=2000
WORKDIR /app
RUN useradd -u $UID app -d /app
RUN mkdir /app/tmp
COPY Gemfile Gemfile.lock /app/
RUN apt-get update && apt-get install -y libyaml-dev
RUN chown -R app /app
USER app
RUN gem install bundler:4.0.8
RUN bundle config set path 'vendor/bundle'
RUN bundle install && \
  rm -rf /app/.bundle/cache && \
  rm -rf /app/vendor/bundle/ruby/*/cache
COPY package.json yarn.lock /app/
RUN yarn --frozen-lockfile && \
  rm -rf /app/.cache && \
  rm -rf /app/tmp
COPY --chown=app . /app

CMD ["/app/bin/start"]

FROM base AS production
RUN RAILS_ENV=production \
  bundle exec rails assets:precompile && \
  rm -rf /app/node_modules /app/.cache /app/tmp/cache
CMD ["/app/bin/start"]


FROM base AS ci

USER root
# Pinned: Chrome 158 rejects Capybara 3.40's reset (Storage.clearDataForOrigin origin '*')
ARG CHROME_VERSION=157.0.8103.78
RUN apt-get purge -y google-chrome-stable || true; \
    rm -f /etc/apt/sources.list.d/google-chrome.sources /etc/apt/sources.list.d/google-chrome.list /etc/apt/sources.list.d/google.list && \
    cd /tmp && \
    wget -q "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chrome-linux64.zip" && \
    wget -q "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chromedriver-linux64.zip" && \
    unzip -q chrome-linux64.zip -d /opt && \
    unzip -q chromedriver-linux64.zip -d /opt && \
    ln -sf /opt/chrome-linux64/chrome /usr/bin/google-chrome && \
    ln -sf /opt/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver && \
    rm -f chrome-linux64.zip chromedriver-linux64.zip && \
    google-chrome --version && chromedriver --version
ENV RAILS_ENV=test

RUN apt-get update && apt-get install -y x11vnc \
    xvfb \
    fluxbox \
    wget \
    libnss3 \
    wmctrl

USER app

FROM ci AS test

RUN bundle

CMD ["sleep", "99999999"]



