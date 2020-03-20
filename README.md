[![Maintainability](https://api.codeclimate.com/v1/badges/39523975626d856a4997/maintainability)](https://codeclimate.com/github/psu-libraries/myaccount/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/39523975626d856a4997/test_coverage)](https://codeclimate.com/github/psu-libraries/myaccount/test_coverage)

# Setup Your Environment 

## Mac

* Get `homebrew` installed and configured using [these instructions from DSRD until step 12](https://github.com/psu-stewardship/scholarsphere/wiki/How-to-Install-on-a-fresh-Mac)
* `ruby` via `rbenv` ([Upgrading Ruby Version Using rbenv](https://github.com/psu-libraries/psulib_blacklight/wiki/Upgrading-Ruby-Version-Using-rbenv))

# Dependencies 

| Software |  Version |
|----------|------|
| `ruby`    |  2.6.5 <br> (_ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-darwin18]_) |
| `rails`   |  6.0.1 |
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


## Putting it all together

Locally you'll need to run:

```
bundle exec rails s --dev-caching
docker run --name redis-the-new-black -d redis
bin/webpack-dev-server
```

Drop `--dev-caching` if it is getting in the way of dev work.

# Terminology

There is a lot of domain terminology that can be confusing. Here are some of the bigger things to keep in mind:

* _Bib_ - a bibliographic container that holds calls and items, contains global information about the bibliographic record described like author and title which is the same throughout the entire record (p.s., bibs can be *large*).
* _Call_ - a call number based container that contains items and is contained within a bib. There can be multiple calls in a bib. There can be multiple items in a call. 
* _Item_ - info that describes the thing that is actually held or checked out. Has a barcode and checkout status.

This is an attempt at a quick and rough "[ubiquitous language](https://martinfowler.com/bliki/UbiquitousLanguage.html)"
