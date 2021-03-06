# rails-gitlab-runner

Docker image for headless Chrome testing with Selenium WebDriver.

A Docker image with:

- Ruby 2.6.1
- Rails 5.2.2
- Chromedriver 75.0.3770.8

## Example .gitlab-ci.yml

```

stages:
  - test

.base_job_template: &base_job_definition
  image: amd2/rails-gitlab-runner
  tags:
    - docker
  cache:
    untracked: true
    key: "$CI_BUILD_NAME"
    paths:
      - vendor

.test_job_template: &test_job_template
  <<: *base_job_definition
  services:
    - postgres:10.1-alpine
  variables:
    DATABASE_HOST: postgres
    DATABASE_USERNAME: postgres
    DATABASE_PASSWORD: ""
    RAILS_MAX_THREADS: "5"
    RAILS_ENV: test
  before_script:
    - ruby -v
    - bundle install --jobs $(nproc) --path vendor/bundle

rubocop:
  <<: *test_job_template
  stage: test
  script: bundle exec rubocop
  allow_failure: true

rspec:
  <<: *test_job_template
  stage: test
  script:
    - rails db:setup
    - SIMPLECOV=1 bundle exec rspec

```