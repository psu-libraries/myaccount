# Setup Your Environment 

## Mac

* Get `homebrew` installed and configured using [these instructions from DSRD until step 12](https://github.com/psu-stewardship/scholarsphere/wiki/How-to-Install-on-a-fresh-Mac)
* `ruby` via `rbenv` ([Upgrading Ruby Version Using rbenv](https://github.com/psu-libraries/psulib_blacklight/wiki/Upgrading-Ruby-Version-Using-rbenv))

# Dependencies 

| Software |  Version |
|----------|------|
| `ruby`    |  2.6.5 <br> (_ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-darwin18]_) |
| `rails`   |  6.0.1 |

# Development Setup
1.  [Make sure you have ssh keys established on your machine](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#generating-a-new-ssh-key)
1.  Clone the application and install:
    ``` 
    git clone git@github.com:psu-libraries/myaccount.git
    cd myaccount
    bundle install --without production test
    ```
    
1.  The application authenticates via webaccess which provides the `user_id` and `password` required for symphony web services access. Then uses `Warden` to login the user and retrieve a patron key and a session token from 
    symphony.
    
    For running the application in development mode, we use a development environment specific settings file provided by the `config` gem. Make sure that your [`config/settings.local.yml`](https://psu.app.box.com/file/558113824635) file sets `webaccess_url`, symphony web services `url` and `headers`:  
    
    ```
    symws:
      webaccess_url: 
      url: 
      headers: {}
    ```

1.  Start the application
    ```
    bundle exec foreman start -f Procfile.dev
    ```  
    