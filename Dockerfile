FROM harbor.k8s.libraries.psu.edu/library/ruby-3.4.1-node-22:20250131 AS base
ARG UID=2000
WORKDIR /app
RUN useradd -u $UID app -d /app
RUN mkdir /app/tmp
COPY Gemfile Gemfile.lock /app/
RUN chown -R app /app
USER app
RUN gem install bundler:2.1.4
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

FROM base as production
RUN RAILS_ENV=production \
  bundle exec rails assets:precompile
CMD ["/app/bin/start"]


FROM base as ci

USER root
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

RUN apt-get update && apt-get install -y google-chrome-stable

RUN CHROME_VERSION=$(google-chrome --version | grep -oP '\d+\.\d+\.\d+') && \
    MAJOR_VERSION=$(echo $CHROME_VERSION | cut -d. -f1) && \
    LATEST_DRIVER=$(curl -sS https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_${MAJOR_VERSION}) && \
    if [ -z "$LATEST_DRIVER" ]; then \
      LATEST_DRIVER=$(curl -sS https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE); \
    fi && \
    wget -q "https://storage.googleapis.com/chrome-for-testing-public/${LATEST_DRIVER}/linux64/chromedriver-linux64.zip" && \
    unzip chromedriver-linux64.zip && \
    mv chromedriver-linux64/chromedriver /usr/local/bin/chromedriver && \
    chmod +x /usr/local/bin/chromedriver && \
    rm -rf chromedriver-linux64.zip chromedriver-linux64
ENV RAILS_ENV=test

RUN apt-get update && apt-get install -y x11vnc \
    xvfb \
    fluxbox \
    wget \
    libnss3 \
    wmctrl

USER app

FROM ci as test

RUN bundle

CMD ["sleep", "99999999"]



