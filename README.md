# turi
Yet another trip planner.

## Installation guide

Run the following commands:

```
bundle install
rake db:migrate RAILS_ENV=development && rake db:test:prepare RAILS_ENV=development
```

## Testing

Turi is built automatically with travis (https://travis-ci.org/turi-inc/turi). To ensure that all tests are passing run:

```
rake spec
```