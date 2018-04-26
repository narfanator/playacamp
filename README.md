Swingcity
================

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Wanna help? Horray!

If you know any of these, you can help!

- Docker
- Ruby
- Ruby on Rails
- HTML (well, technically [[slim](http://slim-lang.com/)])
- Javascript (well, sometimes coffeescript)
- CSS (well, technically SCSS)
- Postgres
- Heroku

If don't know any of these but want to help anyway, ask! (Seriously, ask - we can teach you, and you'll need more guidance than can happen here to get started)

Getting Started
---------------

You will need to be setup with Git & Github, and have Docker installed.

Mac:
- Git: Already installed! You may want a GUI like https://www.sourcetreeapp.com/ but you'll need to use the command line ("terminal" application) anyway
- Docker: https://docs.docker.com/docker-for-mac/install/#download-docker-for-mac

Windows:
- Git: You probably want https://git-scm.com/download/win but there's more than one way to skin this cat
- Docker: https://docs.docker.com/docker-for-windows/install/#download-docker-for-windows

Both:
- Get a Github account: https://github.com/join

Once that's all done, run these commands from terminal:
- `git clone git@github.com:rangerscience/playacamp.git` or `git clone https://github.com/rangerscience/playacamp.git`
- `docker-compose run utils ./bin/db_setup`
- `docker-compose run web rake db:migrate`
- `docker-compose up web`

THAT'S IT!* Go to http://localhost:3000 and you should see the app running :D

To get a clone of the live database, you'll need to do a few more steps:

- Get yourself a Heroku account
- Get added to the Swing City project
- `docker-compose run utils ./bin/db_clone`
- `docker-compose run web rake db:migrate`

THAT'S IT!*

To run rails commands:

- `docker-compose run web rails c`
- `docker-compose run web rake routes`

etc

For more, see the "Development" section below

This application was generated with the [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gem
provided by the [RailsApps Project](http://railsapps.github.io/).

Rails Composer is open source and supported by subscribers. Please join RailsApps to support development of Rails Composer.

Problems? Issues?
-----------

Need help? Ask on Stack Overflow with the tag 'railsapps.'

Your application contains diagnostics in the README file. Please provide a copy of the README file when reporting any issues.

If the application doesn't work as expected, please [report an issue](https://github.com/RailsApps/rails_apps_composer/issues)
and include the diagnostics.

Ruby on Rails
-------------

This application requires:

- Ruby 2.3.3
- Rails 4.2.0

Learn more about [Installing Rails](http://railsapps.github.io/installing-rails.html).

Development
-----------

If you're using the Docker setup (what's described above), there's some magic in place (but not all places).

This git repo is mirrored into the `web` docker container; so: you can edit code using whatever you like (I recommend Atom, lots of people like Sublime, but you can make do with TextEdit or go hardcore with Vim) and the Rails container should automagically pick up those changes. If it doesn't, stop and restart the container (cntrl-c, and then `docker-compose up web` again) - and make a note of the thing that's not live-reloading so we can try to make it do that :)

If you want to do something on the command line with the Rails server, `docker-compose run web /bin/bash` will drop you into a bash shell alongside the Rails server.

If you're not using the Docker setup, the project should work just fine as a normal Rails app - but that's a bit more involved to get started.

Documentation and Support
-------------------------

Issues
-------------

Similar Projects
----------------

Contributing
------------

Make pull requests, yo! Don't commit to master!

Credits
-------

License
-------
