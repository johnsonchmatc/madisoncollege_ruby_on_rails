#Ruby on Rails Development
##Week 7

---
#Demo
* cd into ```wolfie_books```
* ```$ git add . ```
* ```$ git commit -am 'commiting files from in class'```
* ```$ git checkout master```
* ```$ git fetch```
* ```$ git pull ```
* ```$ git checkout week07_start```
* ```$ rm -f db/*.sqlite3```
* ```$ bundle```
* ```$ rake db:migrate```
* ```$ rake test``` We have a  couple failing tests from last week

---
* Generate a new controller for our sessions

```bash
$ bundle exec rails generate controller Sessions new
```

---
* Add new routes, make sure users resource exists

```ruby
  get    'login'   => 'sessions#new'
  get    'signup'  => 'users#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
```

---
* Add the methods needed to the sessions controller

```ruby
class SessionsController < ApplicationController
  def new
  end

  def create
    render 'new'
  end

  def destroy
  end
end
```

---
* Let's add some of the functionality needed to log a user in

```ruby
def create
  user = User.find_by(email: params[:session][:email].downcase)
  if user && user.authenticate(params[:session][:password])
    # Log the user in and redirect to the user's show page.
  else
    flash.now[:danger] = 'Invalid email/password combination'
    render 'new'
  end
end
```

^ flash.now make sure that it only sticks around for this rendering of a page not one more request


---
* Now we'll use the power of Ruby to allow our controllers to have access to methods we define in our Sessions helper.  We'll open up the ApplicationController and add the following:

```ruby
include SessionsHelper
```

---
* Then add the following method to the SessionsHelper

```ruby
def log_in(user)
  session[:user_id] = user.id
end
```

^ session is a hash we can create keys and assign values to, it persists for the session

---
* Now we can use this method in our create action in the sessions controller

```ruby
log_in(user)
redirect_to(user)
```

---
* Next we add a helpers to let us have access to the currently logged in user and if there is a logged in user

```ruby
def current_user
  @current_user ||= User.find_by(id: session[:user_id])
end

def logged_in?
  !current_user.nil?
end
```

---
* Let's add login and log out links to our navigation

```erb
<% if logged_in? %>
  <li>
    <%= link_to "Log out", logout_path, method: "delete" %>
  </li>
<% else %>
  <li>
    <%= link_to "Log in", login_path %>
  </li>
<% end %>
```


---
* Now we can add a method to help logout a user in our helper

```ruby
def log_out
  session.delete(:user_id)
  @current_user = nil
end
```

* Then use it in our controller

```ruby
def destroy
  log_out
  redirect_to root_url
end
```

---
#Break

---
##Nested Resources

---
* Let's make it easy to add tasks to a project

```ruby
resources :projects do
  resources :tasks
end
```

---
* Let's get our controller ready to handle this

```ruby
  before_action :set_project, only: [:new, :show, :edit, :update, :destroy, :create]

...

  def create
    @task = Task.new(task_params)
    @task.project = @project

...
private

    def set_project
      @project = Project.find(params[:project_id])
    end
```

* And we'll also want to update all the ```redirect_to```'s to go to ```@project``` and change notice to success.

---
* Now we can update the project show page 

```erb
<div class="row">
  <h1><%= @project.title %></h1>
  <h3><%= @project.client.name %></h3>
</div>

<div class="row">
  <div class="panel panel-primary">
    <div class="panel-heading">
      <h3 class="panel-title">Description</h3>
    </div>
    <div class="panel-body">
        <%= @project.description %>
    </div>
  </div>
  <p>
    <strong>Start date:</strong> <%= @project.start_date %>
  </br>
    <strong>End date:</strong> <%= @project.end_date %>
  </p>
</div>

<div class="row">
  <%= link_to 'Edit Project', edit_project_path(@project) %> | <%= link_to 'Back', projects_path %> | <%= link_to 'New Task', new_project_task_path(@project.id) %>
</div>

<div class="row">
  <h3>Task log</h3> 
  <table class="table table-striped table-hover ">
    <thead>
      <tr>
        <th>Employee</th>
        <th>Hours</th>
        <th>Date</th>
        <th>Description</th>
      </tr>
    </thead>
    <tbody>
      <% @project.tasks.each do |task| %>
      <tr>
        <td><%= task.employee_name %></td>
        <td><%= task.time %></td>
        <td><%= task.date %></td>
        <td><%= task.description %></td>
      </tr>
      <% end %>
    </tbody>
  </table>
</div>
```

---
* Our new task form will need some updates

```erb
<%= form_for([@project, @task]) do |f| %>
```

* Our new task page should have a link updated too

```erb
<%= link_to 'Back', project_path(@project) %>
```

