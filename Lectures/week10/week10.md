#Ruby on Rails Development
##Week 10 
---
#Standup

---
#Chapter 8

---

* Generate a sessions controller

```bash
$ bundle exec rails generate controller Sessions new
```

* Add routes, because we want to have only named routes
```ruby
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
```

* Create our login form
```ruby
<h1>Log in</h1>
  <div class="form_group">
    <fieldset>
      <legend></legend>
    <%= form_for(:session, url: login_path, :html => {class: 'form-horizontal'}) do |f| %>
      <fieldset>
        <legend></legend>
        <div class='form_group'>
          <%= f.label :email, class: 'col-lg-2 control-label' %>
          <div class='col-lg-5'>
            <%= f.email_field :email, class: 'form-control' %>
          </div>
        </div>
        <div class='form_group'>
          <%= f.label :password, class: 'col-lg-2 control-label' %>
          <div class='col-lg-5'>
            <%= f.password_field :password, class: 'form-control' %>
          </div>
        </div>
        <div class='form_group'>
          <p>
            <%= f.submit "Log in", class: "btn btn-primary" %>
          </p>
        </div>
      </fieldset>
    <% end %>
<p>New user? <%= link_to "Sign up now!", signup_path %></p>
```

* Next create our 'create' action in the session controller

```ruby
def create
  render 'new'
end
```

* Try posting the form there, let's see what we get for information

* Then update the create method to find the user and then authenticate them,
with the method ```authenticate``` provided by ```has_secure_password```

```ruby
def create
  user = User.find_by(email: params[:session][:email].downcase)
  if user && user.authenticate(params[:session][:password])
    # Log the user in and redirect to the user's show page.
  else
    flash[:danger] = 'Invalid email/password combination'
    render 'new'
  end
end
```

* Let's write a test for this flash message

```
$ bundle exec rails generate integration_test users_login
```

```
test "login with invalid information" do
  get login_path
  assert_template 'sessions/new'
  post login_path, session: { email: "", password: "" }
  assert_template 'sessions/new'
  assert_not flash.empty?
  get root_path
  assert flash.empty?
end
```

* To make the test pass we can change our flash to use ```flash.now```

* We'll need some help for authentication so we'll include SessionsHelper in our
application controller which gives us a place to put our authentication code

```
include SessionsHelper
```

* Inside of sessions_helper.rb we'll create a login method, this will take
advantage of Rails' ```session()``` method for us to assign our user id to that
will persist throughout the session

```
def log_in(user)
  session[:user_id] = user.id
end
```

* Back in our sessions_controller we can use this login method and set the user

```
log_in user
redirect_to user
```

* Let's create a method for accessing a current user and one to see if a user
is logged in.
* We'll use a hack in active record that will allow us to search with a nil value
for the session user\_id

```
 def current_user
   @current_user ||= User.find_by(:id => session[:user_id])
 end

 def logged_in?
   !current_user.nil?
 end
```

