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

## Build Rails 5 API application

This instruction is given based on the idea that users already have some experiences building Rails apps before. This will not go into details of how to build a Rails 5 API. Here is a really good tutorial though: https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one

First create a new Rails 5 API app by running the following command:

```
$ rails new RailsSwaggerExample --api
$ bundle install
```

This will create a template api application assuming that each endpoint will return some sort of JSON object.

Let just say we want to build a simple AuthorManager application with just Authors. Generate models and controllers as you have with a normal rails app.

Click here to see the author [model](https://github.com/495-Labs-Projects/RailsSwaggerExample/blob/master/app/models/author.rb) and [controller](https://github.com/495-Labs-Projects/RailsSwaggerExample/blob/master/app/controllers/authors_controller.rb).

The controller may look a little different than the usual rails application since everything should just return a JSON response. This is why the [reponse.rb](https://github.com/495-Labs-Projects/RailsSwaggerExample/blob/master/app/controllers/concerns/response.rb) and Response module was created to make this easier.

Once you created your API check that each endpoint works the way you want it, either using the browser or curl.


## Swagger Docs/UI

Swagger is broken up into 2 parts in Rails. Swagger Docs is just the autogenerated json files that represents/documents your api. Then there is the Swagger UI which intakes the json files and outputs some nice html/css/javascript static pages for your web application. 

### Integrate Swagger Docs for Documentation

#### Add the right gem

First of all you will need this gem by including this in your Gemfile and then run bundle install:

```
gem 'swagger-docs'
```

This gem will automatically generate the right JSON files to help document your API if provided the right things. The documentation for the application is here: https://github.com/richhollis/swagger-docs

#### Create the initializer

Next you will need to create an initializer for the gem and call it swagger_docs.rb. This will tell the gem some basic information about your application and how to generate the JSON for your API.

This means that all of json files will be created under you public/apidocs folder in your rails application. 

```ruby
# config/initializers/swagger_docs.rb

class Swagger::Docs::Config
  def self.transform_path(path, api_version)
    # Make a distinction between the APIs and API documentation paths.
    "apidocs/#{path}"
  end
end

Swagger::Docs::Config.base_api_controller = ActionController::API 

Swagger::Docs::Config.register_apis({
  "1.0" => {
    # the extension used for the API
    :api_extension_type => :json,
    # the output location where your .json files are written to
    :api_file_path => "public/apidocs",
    # the URL base path to your API
    :base_path => "",
    # if you want to delete all .json files at each generation
    :clean_directory => false,
    # add custom attributes to api-docs
    :attributes => {
      :info => {
        "title" => "Sample Swagger AuthorManager",
        "description" => "Uses swagger ui and docs to document AuthorManager API"
      }
    }
  }
})
```

#### Document your API controllers

Look at the swagger-docs gem documentaiton for the full details of how to set up documentation. Each controller needs to include some information as to what the API endpoints that exists for the controller itself, since only controllers can define the endpoint action. In this case we are going to quickly go over what it would be like to document the authors controller with the general CRUD operations.

This is just a quick example of how to set up documentation for the authors_controller.rb, the actual file itself has the full documentation.

```ruby
class AuthorsController < ApplicationController
  # This is to tell the gem that this controller is an API
  swagger_controller :authors, "Authors Management"

  # Each API endpoint index, show, create, etc. has to have one of these descriptions

  # This one is for the index action. The notes param is optional but helps describe what the index endpoint does
  swagger_api :index do
    summary "Fetches all Authors"
    notes "This lists all the authors"
  end

  # Show needs a param which is which author id to show.
  # The param defines that it is in the path, and that it is the Author's ID
  # The response params here define what type of error responses can be returned back to the user from your API. In this case the error responses are 404 not_found and not_acceptable.
  swagger_api :show do
    summary "Shows one Author"
    param :path, :id, :integer, :required, "Author ID"
    notes "This lists details of one author"
    response :not_found
    response :not_acceptable
  end

  # Create doesn't take in the author id, but rather the required fields for a author (namely first_name and last_name)
  # Instead of a path param, this uses form params and defines them as required
  swagger_api :create do
    summary "Creates a new Author"
    param :form, :first_name, :string, :required, "First name"
    param :form, :last_name, :string, :required, "Last name"
    response :not_acceptable
  end

  # Update requires the author id but you can also change the first_name and/or last_name of the author.
  # Again since it takes in an author id, it can be not found.
  # Also this will have both path and form params
  swagger_api :update do
    summary "Updates an existing Author"
    param :path, :id, :integer, :required, "Author Id"
    param :form, :first_name, :string, :optional, "First name"
    param :form, :last_name, :string, :optional, "Last name"
    response :not_found
    response :not_acceptable
  end

  # Lastly destroy is just like the rest and just takes in the param path for author id. 
  swagger_api :destroy do
    summary "Deletes an existing Author"
    param :path, :id, :integer, :required, "Author Id"
    response :not_found
    response :not_acceptable
  end

  # ...
  # The actual controller code for authors
  # ...
end
```

This is the bulk of how you can document your API and tell users how to use your API. After you do all of this, you will need to run a rake command in order to automatically generate the swagger json files from the documentation that you just wrote. Run the following command:

```
$ rake swagger:docs
```
Now check in your ```public/apidocs``` folder, there should be a main json file called ```api-docs.json``` and then a json file for each controller, in this case there would just be ```authors.json```. You can take a look a these files just to get familiar with what is going on. 


### Get Swagger UI

Now your next step is to get swagger ui to display the JSON in a user friendly manner!


