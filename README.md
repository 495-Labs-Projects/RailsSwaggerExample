# Rails 5 Sample Swagger App

This repo is a sample of how to build up an Rail 5 API application and have Swagger Docs/UI document the API.

### Requirements

 * Ruby version: 2.4.*
 * Rails version: 5.1.*

 If you don't have these versions then run the following commands:

 ```
# when using rbenv
$ rbenv install 2.3.1
# set 2.3.1 as the global version
$ rbenv global 2.3.1
# install the right version of rails
$ gem install rails -v 5.1.4 --no-rdoc --no-ri
 ```

```
# when using rvm
$ rvm install 2.3.1
# set 2.3.1 as the global version
$ rvm use 2.3.1
# install the right version of rails
$ gem install rails -v 5.1.4 --no-rdoc --no-ri
```

### Build Rails 5 API application

This instruction is given based on the idea that users already have some experiences building Rails apps before. 

First create a new Rails 5 API app by running the following command:

```
$ rails new RailsSwaggerExample --api
```

This will create a template api application assuming that each endpoint will return some sort of JSON object.


