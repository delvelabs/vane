FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -qy --no-install-recommends \
        ruby-bundler \
        ruby-ffi \
        ruby-nokogiri \
        ruby-typhoeus \
        ruby-addressable \
        ruby-json \
        ruby-terminal-table \
        ruby-progressbar \
        ruby-webmock \
        ruby-simplecov \
        ruby-rspec \
        ruby-rspec-its \
        libcurl4-openssl-dev \
    && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/*

COPY . /vane/
RUN rm /vane/Gemfile
WORKDIR "/vane/"
ENTRYPOINT ["ruby", "vane.rb"]
CMD ["--help"]
