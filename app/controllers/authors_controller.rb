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

  # The start of the actual controller

  before_action :set_author, only: [:show, :update, :destroy]

  # GET /authors
  def index
    @authors = Author.all
    json_response(@authors)
  end

  # POST /authors
  def create
    @author = Author.create!(author_params)
    json_response(@author, :created)
  end

  # GET /authors/:id
  def show
    json_response(@author)
  end

  # PUT /authors/:id
  def update
    @author.update(author_params)
    head :no_content
  end

  # DELETE /authors/:id
  def destroy
    @author.destroy
    head :no_content
  end

  private

  def author_params
    # whitelist params
    params.permit(:first_name, :last_name)
  end

  def set_author
    @author = Author.find(params[:id])
  end
end
