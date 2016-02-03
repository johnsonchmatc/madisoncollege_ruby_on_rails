#Ruby on Rails Development
##Week 5

---
#Preparing for the demo today

* Note: make sure you have removed 'wolfies_list' if you generated one last week.
* ```$ git clone git@github.com:johnsonch/wolfies_list.git ```
* ```$ cd wolfies_list```
* ```$ bundle install --path=vendor/bundle```

---
#What are we building?

---
#Demo

^ Clean up Heroku messes
- delete from heroko
- remove from git config
- ```$ heroku create```

^ Scaffold ads
```
$ bundle exec rails g scaffold Ads title:string description:text price:float address:string
```
Scaffold categories
```
$ bundle exec rails g scaffold Categories name:string
```
Add relationship
- generate migration ```bundle exec rails g migration add_category_id_to_ads```
- add relationships to models

---
#Active Record Relationships

---
##Active Record Relationships
* belongs_to
* has_many
* has_many_through

---
##Validations
* Rules to prevent invalid data from being saved
* Can be conditional
* Provides error messages back to the controller
* [http://guides.rubyonrails.org/active_record_validations.html#validation-helpers](http://guides.rubyonrails.org/active_record_validations.html#validation-helpers)

---


---
#Demo
* cd into ```wolfie_books```
* ```$ git add . ```
* ```$ git commit -am 'commiting files from in class'```
* ```$ git checkout master```
* ```$ git fetch```
* ```$ git pull ```
* ```$ git checkout  week05_start```

---

###Create users controller and model
```bash
$ bundle exec rails generate controller Users new
$ bundle exec rails generate model User name:string email:string
```

###Add user model tests
```ruby
def setup
  @user = User.new(name: "Example User", email: "user@example.com")
end

test "should be valid" do
  assert @user.valid?
end

test "name should be present" do
  @user.name = "          "
  assert_not @user.valid?
end

test "email should be present" do
  @user.email = "          "
  assert_not @user.valid?
end

test "name should not be too long" do
  @user.name = "a" * 51
  assert_not @user.valid?
end

test "email should not be too long" do
  @user.email = "a" * 256
  assert_not @user.valid?
end


test "email validation should accept valid addresses" do
  valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
  valid_addresses.each do |valid_address|
    @user.email = valid_address
    assert @user.valid?, "#{valid_address.inspect} should be valid"
  end
end

 test "email validation should reject invalid addresses" do
   invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
   invalid_addresses.each do |invalid_address|
     @user.email = invalid_address
     assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
   end
 end

 test "email addresses should be unique" do
   duplicate_user = @user.dup
   duplicate_user.email = @user.email.upcase
   @user.save
   assert_not duplicate_user.valid?
 end
```

###Add code to user model
```ruby
VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

before_save { self.email = email.downcase }

validates :name, presence: true, length: { maximum: 50 }
validates :email,
          presence: true,
          length: { maximum: 225 },
          format: { with: VALID_EMAIL_REGEX },
          uniqueness: { case_sensitive: false }
```
###Add some users to our database with Rails console

```ruby
User.create(name: 'Bart Simpson', email: 'bart@simpsons.com')
User.create(name: 'Homer Simpson', email: 'homer@simpsons.com')
User.create(name: 'Lisa Simpson', email: 'lisa@simpsons.com')
```

###Now find users
```ruby
bart = User.find_by(name: 'Bart Simpson')
bart = User.where('name LIKE ?', '%art%')
```

##Cleaning up views
###app/views/layouts/\_nav.html.erb
```erb
<nav class="navbar navbar-default">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#">Wolfie Books</a>
    </div>

    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav">
        <li>
          <%= link_to 'Projects', projects_path %>
        </li>
        <li>
          <%= link_to 'Clients', clients_path %>
        </li>
          </ul>
        </li>
      </ul>
      <form class="navbar-form navbar-left" role="search">
        <div class="form-group">
          <input type="text" class="form-control" placeholder="Search">
        </div>
        <button type="submit" class="btn btn-default">Submit</button>
      </form>
      <ul class="nav navbar-nav navbar-right">
        <li><a href="#">Link</a></li>
      </ul>
    </div>
  </div>
</nav>
```

##Projects views
###index.html.erb
####Table needs classes
```html
class="table table-striped table-hover"
```

####Cleaned up table
```erb
  <tbody>
    <% @projects.each do |project| %>
      <tr>
        <td><%= link_to project.title, project %></td>
        <td><%= link_to "#{project.start_date}/#{project.end_date}", project %></td>
        <td><%= link_to project.client.name, project %></td>
      </tr>
    <% end %>
  </tbody>
```

###\_form.html.erb
```erb
  <% if @project.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(@project.errors.count, "error") %> prohibited this project from being saved:</h2>

      <ul>
      <% @project.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
      </ul>
    </div>
  <% end %>

<%= form_for(@project, html: {class: 'form-horizontal'}) do |f| %>
  <fieldset>
    <div class="form-group">
      <%= f.label :title, class: "col-lg-2 control-label" %><br>
      <div class="col-lg-10">
        <%= f.text_field :title, class: "form-control" %>
      </div>
    </div>
    <div class="form-group">
      <%= f.label :description, class: "col-lg-2 control-label" %><br>
      <div class="col-lg-10">
      <%= f.text_area :description, class: "form-control" %>
      </div>
    </div>
    <div class="form-group">
      <%= f.label :start_date, class: "col-lg-2 control-label" %><br>
      <div class="col-lg-10">
      <%= f.date_select :start_date, class: "form-control" %>
      </div>
    </div>
    <div class="form-group">
      <%= f.label :end_date, class: "col-lg-2 control-label" %><br>
      <div class="col-lg-10">
      <%= f.date_select :end_date, class: "form-control" %>
      </div>
    </div>
    <div class="form-group">
      <%= f.label :client_id, class: "col-lg-2 control-label" %><br>
      <div class="col-lg-10">
      <%= f.number_field :client_id, class: "form-control" %>
      </div>
    </div>
    <div class="actions">
      <%= f.submit %>
    </div>
  </fieldset>
<% end %>
```

##Clients
###index.html.erb
```erb
<p id="notice"><%= notice %></p>

<h1>Clients</h1>
<h3><%= link_to '+ New Client', new_client_path %></h3>
<% @clients.each do |client| %>
  <div class="panel panel-primary">
    <div class="panel-heading">
      <h3 class="panel-title"><%= client.name %></h3>
    </div>
    <div class="panel-body">
      <%= client.contact_name %><br />
      <a href="mailto:<%= client.contact_email %>"><%= client.contact_email %></a><br />
      <%= client.phone %><br />
      <%= client.street %><br />
      <%= client.city %>,<%= client.state %> <%= client.postal_code %>
    </div>
    <div class="panel-footer">
      <%= link_to 'Edit', edit_client_path(client) %> ::
      <%= link_to 'Delete', client, method: :delete, data: { confirm: 'Are you sure?' } %>
    </div>
  </div>
<% end %>
```

###Redirect to clients index on create and update using:
```ruby
clients_url
```

###Update notice to be much more pretty
```erb
<% if notice %>
<div class="alert alert-dismissible alert-success">
    <button type="button" class="close" data-dismiss="alert">×</button>
    <%= notice %>
</div>
<% end %>
```

###Then Dry Up notice by moving it to layout


