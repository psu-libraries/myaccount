[![Maintainability](https://api.codeclimate.com/v1/badges/39523975626d856a4997/maintainability)](https://codeclimate.com/github/psu-libraries/myaccount/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/39523975626d856a4997/test_coverage)](https://codeclimate.com/github/psu-libraries/myaccount/test_coverage)
[![<psu-libraries>](https://circleci.com/gh/psu-libraries/myaccount.svg?style=svg)](<https://circleci.com/gh/psu-libraries/myaccount>)
# Setup Your Environment 

## Mac

* Get `homebrew` installed and configured using [these instructions from DSRD until step 12](https://github.com/psu-stewardship/scholarsphere/wiki/How-to-Install-on-a-fresh-Mac)
* `ruby` via `rbenv` ([Upgrading Ruby Version Using rbenv](https://github.com/psu-libraries/psulib_blacklight/wiki/Upgrading-Ruby-Version-Using-rbenv))

# Dependencies 

| Software |  Version |
|----------|------|
| `ruby`    |  2.6.5 <br> (_ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-darwin18]_) |
| `rails`   |  6.0.3 |
| `redis`   | 5.0.7 |

# Development Setup

1.  [Make sure you have ssh keys established on your machine](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#generating-a-new-ssh-key)
1.  Clone the application and install:
    ``` 
    git clone git@github.com:psu-libraries/myaccount.git
    cd myaccount
    bundle install --without production test
    ```
1.  The application authenticates via [WebAccess](https://webaccess.psu.edu/services/) which provides the `user_id` and `password` required for symphony web services access. Then uses `Warden` to login the user and retrieve a patron key and a session token from 
    symphony.
    
    For running the application in development mode, we use a development environment specific settings file provided by the `config` gem. Make sure that your [`config/settings.local.yml`](https://psu.app.box.com/file/558113824635) file sets `webaccess_url`, symphony web services `url` and `headers`:  
    
    ```
    symws:
      webaccess_url: 
      url: 
      headers: {}
    ```
    
## Redis locally

Use the [redis docker image](https://hub.docker.com/_/redis/).

Should be able to just run it with a command listed in the docker hub page:

`docker run -d -p 6379:6379 --name redis-the-new-black redis:5.0.7`

Then boot up the rails server with caching turned on and you'll be all set.
 
 `bundle exec rails s --dev-caching`
 
Monitor the behavior by tailing the logs:

 `docker exec -it redis-the-new-black redis-cli monitor`
 
 ### Sidekiq
 
 Sidekiq is also a part of this application, so start it:
 
 ```
 bundle exec sidekiq
 ```

## Putting it all together

Locally you'll need to run:

```
bundle exec rails s
docker start redis-the-new-black
bin/webpack-dev-server
bundle exec sidekiq
```

Drop `--dev-caching` if it is getting in the way of dev work.

# Terminology

There is a lot of domain terminology that can be confusing. Here are some of the bigger things to keep in mind:

* _Bib_ - a bibliographic container that holds calls and items, contains global information about the bibliographic record described like author and title which is the same throughout the entire record (p.s., bibs can be *large*).
* _Call_ - a call number based container that contains items and is contained within a bib. There can be multiple calls in a bib. There can be multiple items in a call. 
* _Item_ - info that describes the thing that is actually held or checked out. Has a barcode and checkout status.

This is an attempt at a quick and rough "[ubiquitous language](https://martinfowler.com/bliki/UbiquitousLanguage.html)"

# CI 
We use Circle CI to test myaccount. In the event of a test failure you can visit <https://circleci.com/gh/psu-libraries/myaccount> to see the jobs output. You can gain shell access to the build by choosing "Rerun with SSH" once logged in, your code will be checked out at the `/project` path.

# Config gem and environment variables

You can use either the yml file inheritance structure inherent to the config gem, or you can set environment variables. See ["Working with Environment Variable"](https://github.com/rubyconfig/config#working-with-environment-variables).

## Overriding pickup location labels

Pickup locations for holds placed are manually dictated by Lending and Reserves Services. Meaning, that although the Symphony system does have the ability to automate this and could be deriven from web service calls we do not do this (for reasons). The workflow is: they tell us what they want for the labels and we add them in `settings.yml`. This means we can override them as needed too by following the inheritance flow of the `config` gem. For production we use `production.local.yml` to override these values. Note that `Settings.pickup_locations` does _not_ affect the labels used in displaying the "Pickup at" column in the holds tables. That is currently not overridable. 

*Knockout prefix* - because we sometimes need to remove only certain keys in a Hash stored in settings we need to make use of the [`knockout_prefix`](https://github.com/rubyconfig/config#merge-customization) feature in the Config gem. The override of the Hash goes like this: 

1. Defined initially in settings.yml and tracked in repo
1. Overridden to be knocked out in settings.local.yml (i.e., `pickup_locations: --`)
1. Overridden again to be redefined in `settings/production.local.yml` without the keys that are meant to be removed

When changing these values you must restart the web server (passenger) _and_ sidekiq. Run `/bin/systemctl restart sidekiq` and  `passenger-config restart-app` on the server where the change is being applied. Locally just stop and start these again.
