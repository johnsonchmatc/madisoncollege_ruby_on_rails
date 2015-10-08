#Ruby on Rails Development
##Chapter 7 
###Week 6

---
#Demo
* cd into ```wolfie_books```
* ```$ git add . ```
* ```$ git commit -am 'commiting files from in class'```
* ```$ git checkout master```
* ```$ git fetch```
* ```$ git pull ```
* ```$ git checkout week06_start```
* ```$ rm -f db/*.sqlite3```
* ```$ bundle```
* ```$ rake db:migrate```
* ```$ rake test``` We have a  couple failing tests from last week


* Gemfile

```ruby
gem 'bcrypt'
```

* migration

```bash
$ be rails g migration add_password_digest_to_users
```

```ruby
class AddPasswordDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
  end
end
```

* user.rb

```ruby
has_secure_password
```

* user_test.rb

```ruby
@user = User.new(name: "Example User", 
                 email: "user@example.com",
                 password: "foobar",
                 password_confirmation: "foobar")
```

* Make password have a minimum lenght

```
test "password should have a minimum length" do
 @user.password = @user.password_confirmation = "a" * 5
 assert_not @user.valid?
end
```

```
validates :password, length: { minimum: 6 }
```

* The Debug method

```ruby
debug(params) if Rails.env.development?
```

* Create user show page: ```app/views/users/show.html.erb```

```ruby
<%= @user.name %>, <%= @user.email %>
```

* Add show action to user controller

```ruby
def show
  @user = User.find(params[:id])
end
```

* Byebug debugger
  * add ```debugger``` where you want to start the debugger

* Let's add a gravatar
* Users helper

```ruby
def gravatar_for(user)
  gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
  gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
  image_tag(gravatar_url, alt: user.name, class: "gravatar")
end
```

* Show view

```ruby
<%= gravatar_for @user %>
```

###Signing up users
* Update new action in users controller

```ruby
@user = User.new
```

* Update users/new.html.erb file

```ruby
<h1>Sign up</h1>
<%= form_for(@user, html: {class: 'form-horizontal'}) do |f| %>
  <fieldset>
    <legend>Enter your information</legend>
    <div class="form-group">
      <%= f.label :name, class: "col-lg-2 control-label" %><br>
      <div class="col-lg-10">
        <%= f.text_field :name, class: "form-control" %>
      </div>
    </div>

    <div class="form-group">
      <%= f.label :email, class: "col-lg-2 control-label" %><br>
      <div class="col-lg-10">
        <%= f.text_field :email, class: "form-control" %>
      </div>
    </div>

    <div class="form-group">
      <%= f.label :password, class: "col-lg-2 control-label" %><br>
      <div class="col-lg-10">
        <%= f.password_field :password, class: "form-control" %>
      </div>
    </div>

    <div class="form-group">
      <%= f.label :password_confirmation, class: "col-lg-2 control-label" %><br>
      <div class="col-lg-10">
        <%= f.password_field :password_confirmation, class: "form-control" %>
      </div>
    </div>


    <div class="actions">
      <%= f.submit %>
    </div>
  </fieldset>
<% end %>
```

* Now we need to make the controller handle this post

```ruby
def create
  @user = User.new(params[:user])
  if @user.save
  else
    render 'new'
  end
end
```

* Let's choose what we allow into our object creation

```ruby
private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
```

* Now we can redirect on a success

```ruby
flash[:success] = "Welcome to Wolfie Books"
redirect_to @user
```

* Let's change our notice to be more general purpose and use the flash functionality in the application layout

```ruby
<% flash.each do |message_type, message| %>
  <div class="alert alert-dismissible alert-<%= message_type %>">
    <button type="button" class="close" data-dismiss="alert">×</button>
    <%= message %>
  </div>
<% end %>
```

* Then we'll need to make flash be smarter in the application controller
```ruby
add_flash_types :success, :warning, :danger, :info
```

* Now was can do some more styling
* Let's remove the scaffold.css
* Add errors.scss with the following code

```scss
.field_with_errors .help-block,
.field_with_errors .control-label,
.field_with_errors .radio,
.field_with_errors .checkbox,
.field_with_errors .radio-inline,
.field_with_errors .checkbox-inline,
.field_with_errors.radio label,
.field_with_errors.checkbox label,
.field_with_errors.radio-inline label,
.field_with_errors.checkbox-inline label {
  color: #f04124;
}
.field_with_errors .form-control {
  border-color: #f04124;
  -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
  box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
}
.field_with_errors .form-control:focus {
  border-color: #d32a0e;
  -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 6px #f79483;
  box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 6px #f79483;
}
.field_with_errors .input-group-addon {
  color: #f04124;
  border-color: #f04124;
  background-color: #f2dede;
}
.field_with_errors .form-control-feedback {
  color: #f04124;
}
```
