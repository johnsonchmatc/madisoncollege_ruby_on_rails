#Ruby on Rails Development
##Chapter 7
###Week 7

---
#Demo

###If you need to re-clone
* ```$ git clone git@bitbucket.org:johnsonch/wolfiereader.git```
* ```$ cd wolfiereader```
* ```$ bundle install --without production```

###If you have it already cloned
* cd into ```wolfiereader```
* ```$ git add . ```
* ```$ git commit -am 'commiting files from in class'```
* ```$ git checkout master```
* ```$ git fetch```
* ```$ git pull ```
* ```$ git checkout week07_start```
* ```$ rm -f db/*.sqlite3```
* ```$ bundle```
* ```$ rake db:migrate```

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
<h1>Account</h1>
<ul>
  <li><a href="#">My Feeds</a></li>
  <li><a href="#">Change Password</a></li>
</ul>
```

Our feeds are going to take advantage of nested resources, before we change our
routes file run a ```$ bundle exec rake routes``` and see what is outputted.

```ruby
  resources :users do
    resources :feeds
  end
```
Then run ```$ rake routes``` again and see the differences.

Now we need to change our scaffolded files for feeds to work in the context of a
user.  We'll start with the feeds controller

Finding a user for every time the user every time the feeds controller is accessed.

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
  @feed = @user.feeds.new(feed_params)

  respond_to do |format|
    if @feed.save
      format.html { redirect_to user_feed_path(id: @feed), notice: 'Feed was successfully created.' }
      format.json { render :show, status: :created, location: @feed }
    else
      format.html { render :new }
      format.json { render json: @feed.errors, status: :unprocessable_entity }
    end
  end
end

def update
  respond_to do |format|
    if @feed.update(feed_params)
      format.html { redirect_to user_feed_path(id: @feed), notice: 'Feed was successfully updated.' }
      format.json { render :show, status: :ok, location: @feed }
    else
      format.html { render :edit }
      format.json { render json: @feed.errors, status: :unprocessable_entity }
    end
  end
end

def destroy
  @feed.destroy
  respond_to do |format|
    format.html { redirect_to user_feeds_url, notice: 'Feed was successfully destroyed.' }
    format.json { head :no_content }
  end
end
```

Our form needs to know that it requires sending the user.

```erb
<%= form_for([@user,@feed]) do |f| %>
```

The links at the bottom of the edit page need some love too

```erb
<%= link_to 'Show', user_feed_path %> |
<%= link_to 'Back', user_feeds_path %>
```

The table on the index page needs to be update.

```erb
  <tbody>
    <% @feeds.each do |feed| %>
      <tr>
        <td><%= feed.url %></td>
        <td><%= feed.name %></td>
        <td><%= link_to 'Show', user_feed_path(id: feed) %></td>
        <td><%= link_to 'Edit', edit_user_feed_path(id: feed) %></td>
        <td><%= link_to 'Destroy', user_feed_path(id: feed), method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
```

And on our new page

```erb
<%= link_to 'Back', user_feeds_path %>
```

Finally the show page

```erb
<%= link_to 'Edit', edit_user_feed_path(id: @feed) %> |
<%= link_to 'Back', user_feeds_path %>
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

Then for a little polish we'll make the feeds page only show that user's feeds

```ruby
  def index
    @feeds = @user.feeds
  end
```
