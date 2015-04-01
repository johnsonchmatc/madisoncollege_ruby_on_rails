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
