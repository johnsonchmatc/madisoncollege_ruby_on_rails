#Demo

Before we get started let's look at our routes

```
$ bundle exec rails routes
```

First we'll get all the user routes by updating our routes.rb file
```ruby
resources :users
```

After making these changes we should probably run our tests

```
$ bundle exec rails test
```

Oops we broke a test! We changed our routes, lets fix the test to use the new route

```ruby
 test "should get new" do
   get new_user_path
   assert_response :success
 end
```

Now in the users controller we can add a show method (action)

```ruby
def show
  @user = User.find(params[:id])
end
```

Then we can make our show view actually display some information

```erb
<h1>My Account</h1>

<a href="#">My Turns</a>

```

Now we can get users signing up, starting with adding to the users controller a new method.

```ruby
def new
  @user = User.new
end
```

Let's make the sign up form look really nice.

```erb
<h1>Sign up</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3 well">
    <%= form_for(@user, html: {class: "form-horizontal"}) do |f| %>
      <fieldset>
        <div class="form-group">
          <%= f.label :first_name, class: 'col-lg-2 control-label' %>
          <div class="col-lg-10">
            <%= f.text_field :first_name, class: 'form-control' %>
          </div>
        </div>

        <div class="form-group">
          <%= f.label :last_name, class: 'col-lg-2 control-label' %>
          <div class="col-lg-10">
            <%= f.text_field :last_name, class: 'form-control' %>
          </div>
        </div>

        <div class="form-group">
          <%= f.label :email, class: 'col-lg-2 control-label' %>
          <div class="col-lg-10">
            <%= f.email_field :email, class: 'form-control' %>
          </div>
        </div>

        <div class="form-group">
          <%= f.label :password, class: 'col-lg-2 control-label' %>
          <div class="col-lg-10">
            <%= f.password_field :password, class: 'form-control' %>
          </div>
        </div>

        <div class="form-group">
          <%= f.label :password_confirmation, "Confirmation", class: 'col-lg-2 control-label' %>
          <div class="col-lg-10">
            <%= f.password_field :password_confirmation, class: 'form-control' %>
          </div>
        </div>

        <div class="form-group">
          <div class="col-lg-12">
            <%= f.submit "Create my account", class: "btn btn-primary" %>
          </div>
        </div>
    <% end %>
  </div>
</div>
```

Then we need a create method to process the form

```ruby
def create
  @user = User.new(user_params)
  if @user.save
    flash[:success] = "Welcome"
    redirect_to @user
  else
    render 'new'
  end
end



  private
    # Notice the formatting of the parameters going into the permit method
    def user_params
      params.require(:user).permit(:first_name,
                                   :last_name,
                                   :email,
                                   :password,
                                   :password_confirmation)
    end
```


Our recipes are going to take advantage of nested resources, before we change our
routes file run a ```$ bundle exec rake routes``` and see what is outputted.

```ruby
  resources :users do
    resources :recipes
  end
```
Then run ```$ rake routes``` again and see the differences.

Now we need to change our scaffolded files for recipes to work in the context of a
user.  We'll start with the recipes controller

Finding a user for every time the user every time the recipes controller is accessed.

```ruby
before_action :set_user

....

private
...
    def set_user
      @user = User.find(params[:user_id])
    end
```

Then modifying the create, update and destroy methods.

```ruby
  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = @user.recipes.new(recipe_params)

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to user_recipe_path(id: @recipe), notice: 'Recipe was successfully created.' }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to user_recipe_path(id: @recipe), notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to user_recipes_url, notice: 'Recipe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
```

Our form needs to know that it requires sending the user.

```erb
<%= form_for([user, recipe]) do |f| %>
.
.
.
.
<% end %>
```

In order for the form to work we, need to make a change to the new.html.erb page
so that it knows how to pass the user to the form and we'll also fix the link
while were here for going "back"

```
<h1>New Recipe</h1>

<%= render 'form', {recipe: @recipe, user: @user} %>

<%= link_to 'Back', recipes_path %>
```

The edit page needs the same updating as the new page

```erb
<h1>Editing Recipe</h1>

<%= render 'form', {recipe: @recipe, user: @user} %>

<%= link_to 'Show', @recipe %> |
<%= link_to 'Back', recipes_path %>
```

The table on the index page needs to be update. Here is the whole page

```erb
<p id="notice"><%= notice %></p>

<h1>recipes</h1>

<table>
  <thead>
    <tr>
      <th>Year</th>
      <th>Month</th>
      <th>Notes</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody>
    <% @recipes.each do |recipe| %>
      <tr>
        <td><%= recipe.year %></td>
        <td><%= recipe.month %></td>
        <td><%= recipe.notes %></td>
        <td><%= link_to 'Show', user_recipe_path(id: recipe) %></td>
        <td><%= link_to 'Edit', edit_user_recipe_path(id: recipe) %></td>
        <td><%= link_to 'Destroy', user_recipe_path(id: recipe), method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>

<br>

<%= link_to 'New recipe', new_user_recipe_path %>
```


Finally the show page

```erb
<%= link_to 'Edit', edit_user_recipe_path(id: @recipe) %> |
<%= link_to 'Back', user_recipes_path %>
```

Then for a little polish we'll make the recipes page only show that user's recipes

```ruby
  def index
    @recipes = @user.recipes
  end
```
