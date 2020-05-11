FROM ruby:2.4.1

RUN  mkdir -p /opt/collector
COPY . /opt/collector

RUN gem install bundler --without development --no-ri --no-rdoc
RUN gem update --system --quiet

WORKDIR /opt/collector
RUN bundle config set without 'development'
RUN bundle install

EXPOSE 4567

HEALTHCHECK --interval=1m --timeout=3s \
  CMD curl -sk -I -f http://localhost:4567/results?healthcheck=1 || exit 1

CMD ["bundle", "exec", "ruby", "collector.rb"]
