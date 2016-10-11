#Ruby on Rails Development
##Chapter 7
###Week 7

---
#Demo

###If you need to re-clone
* ```$ git clone git@bitbucket.org:johnsonch/wolfie_budget.git```
* ```$ cd wolfie_budget```
* ```$ bundle install --without production```

###If you have it already cloned
* ```$ git add . ```
* ```$ git commit -am 'commiting files from in class'```
* ```$ git checkout master```
* ```$ git fetch```
* ```$ git pull ```
* ```$ git checkout  week06_in_class```
* ```$ bundle install --without production```
* ```$ rails db:migrate:reset```

---

First we'll get all the user routes by updating our routes.rb file
```ruby
resources :users
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

```

Our budgets are going to take advantage of nested resources, before we change our
routes file run a ```$ bundle exec rake routes``` and see what is outputted.

```ruby
  resources :users do
    resources :budgets
  end
```
Then run ```$ rake routes``` again and see the differences.

Now we need to change our scaffolded files for budgets to work in the context of a
user.  We'll start with the budgets controller

Finding a user for every time the user every time the budgets controller is accessed.

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
def create
  @budget = @user.budgets.new(budget_params)

  respond_to do |format|
    if @budget.save
      format.html { redirect_to user_budget_path(id: @budget), notice: 'budget was successfully created.' }
      format.json { render :show, status: :created, location: @budget }
    else
      format.html { render :new }
      format.json { render json: @budget.errors, status: :unprocessable_entity }
    end
  end
end

def update
  respond_to do |format|
    if @budget.update(budget_params)
      format.html { redirect_to user_budget_path(id: @budget), notice: 'budget was successfully updated.' }
      format.json { render :show, status: :ok, location: @budget }
    else
      format.html { render :edit }
      format.json { render json: @budget.errors, status: :unprocessable_entity }
    end
  end
end

def destroy
  @budget.destroy
  respond_to do |format|
    format.html { redirect_to user_budgets_url, notice: 'budget was successfully destroyed.' }
    format.json { head :no_content }
  end
end
```

Our form needs to know that it requires sending the user.

```erb
<%= form_for([@user,@budget]) do |f| %>
```

The links at the bottom of the edit page need some love too

```erb
<%= link_to 'Show', user_budget_path %> |
<%= link_to 'Back', user_budgets_path %>
```

The table on the index page needs to be update.

```erb
  <tbody>
    <% @budgets.each do |budget| %>
      <tr>
        <td><%= budget.url %></td>
        <td><%= budget.name %></td>
        <td><%= link_to 'Show', user_budget_path(id: budget) %></td>
        <td><%= link_to 'Edit', edit_user_budget_path(id: budget) %></td>
        <td><%= link_to 'Destroy', user_budget_path(id: budget), method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
```

And on our new page

```erb
<%= link_to 'Back', user_budgets_path %>
```

Finally the show page

```erb
<%= link_to 'Edit', edit_user_budget_path(id: @budget) %> |
<%= link_to 'Back', user_budgets_path %>
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
    flash[:success] = "Welcome to Wolfiereader"
    redirect_to @user
  else
    render 'new'
  end
end



  private

    def user_params
      params.require(:user).permit(:first_name,
                                   :last_name,
                                   :email,
                                   :password,
                                   :password_confirmation)
    end
```

Then for a little polish we'll make the budgets page only show that user's budgets

```ruby
  def index
    @budgets = @user.budgets
  end
```
