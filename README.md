[![Stories in Ready](https://badge.waffle.io/codeforgso/LOE_dashboard.png?label=ready&title=Ready)](http://waffle.io/codeforgso/LOE_dashboard)

[![Build Status](https://travis-ci.org/codeforgso/LOE_dashboard.svg)](https://travis-ci.org/codeforgso/LOE_dashboard)

### Greensboro LOE dashboard project
The goal if this project is to create a more user friendly method for browsing local ordinance enforcement (LOE) cases in Greensboro, NC. The extended goal is to provide a method for rescuing houses from being demolished, and to provide developers with the tools to reach out to the city about such properties.

#### Staging Environment
This project is currently staged at a free account on Heroku: [loedashboard.herokuapp.com] (https://loedashboard.herokuapp.com/)

#### Project Details
- This is a Ruby on Rails project
- This project uses an open data set available on the Greensboro City Open Data Portal

#### Installation Setup
##### Pre-requisites:
 - Ruby v2.2 or higher (not tested in earlier versions)
 - PostgreSQL database
 - Socrata API key (See [this site](https://dev.socrata.com/register) to register.)

##### Install Process
 1. Clone repository: `git clone git@github.com:codeforgso/LOE_dashboard.git`
 2. Change directories: `cd LOE_dashboard`
 3. Install gems: `bundle install`
    * If you are on a Mac and have trouble running this command, try this: `ARCHFLAGS="-arch x86_64" bundle install`
 4. Setup config values:
    1. Copy sample config file: `cp .env-sample .env`
    2. Edit `.env` file.
       (to get the value for `SECRET_KEY_BASE`, run this command: `bundle exec rake secret`)
 5. Setup database: `bundle exec rake db:migrate RAILS_ENV=development`
 6. Seed the database (Note: this process takes many hours, as it makes API request in batches of 1,000):
    `bundle exec rake db:seed RAILS_ENV=development`

#### Running the site
  1. Run this command: `bundle exec rake s`
  2. Visit this site [http://localhost:3000](http://localhost:3000)

#### Running tests
  1. Setup the database: `bundle exec rake db:migrate RAILS_ENV=test`
  2. Run the test: `bundle exec rake spec`
