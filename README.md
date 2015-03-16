# turi
Yet another trip planner.

[![Build Status](https://travis-ci.org/turi-inc/turi.svg?branch=develop)](https://travis-ci.org/turi-inc/turi)
[![Code Climate](https://codeclimate.com/github/turi-inc/turi/badges/gpa.svg)](https://codeclimate.com/github/turi-inc/turi)
[![Test Coverage](https://codeclimate.com/github/turi-inc/turi/badges/coverage.svg)](https://codeclimate.com/github/turi-inc/turi)
[![Security Status](https://hakiri.io/github/turi-inc/turi/develop.svg)](https://hakiri.io/github/turi-inc/turi/develop/shield)
[![Dependency Status](https://gemnasium.com/turi-inc/turi.svg)](https://gemnasium.com/turi-inc/turi)

## Installation guide

Run the following commands:

```
bundle install
rake db:migrate
rake db:test:prepare
rake db:seed
```

For the sake of completeness you can add a `RAILS_ENV=production` behind the rake commands if you want to run the app locally with max performance (note that you need a local postgres installation for this).

If you want to use the production mode locally you also have to compile the assets:

```
rake assets:precompile
```

## Testing

Turi is built automatically with travis (https://travis-ci.org/turi-inc/turi). To ensure that all tests are passing run:

```
rake spec
```

## Preview

You can have a look at the preview of the current master branch at the following url: http://turi.herokuapp.com/

## Documentup

Design is important. Therefore visit http://documentup.com/turi-inc/turi for a much more elegant README layout.