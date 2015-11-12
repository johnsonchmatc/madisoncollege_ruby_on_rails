footer:@johnsonch :: Chris Johnson :: Ruby on Rails Development :: Week 10
autoscale: true

#Ruby on Rails Development
##Week 10 

* https://codecaster.io room: johnsonch

---

#Demo
* cd into ```wolfie_books```
* ```$ git add . ```
* ```$ git commit -am 'commiting files from in class'```
* ```$ git checkout master```
* ```$ git fetch```
* ```$ git pull ```
* ```$ git checkout week10_start```
* ```$ rm -f db/*.sqlite3```
* ```$ bundle```
* ```$ rake db:migrate```
* ```$ rake test``` We have a  couple failing tests from last week

---
#Authorization
* In Wolfie Books we'll want to lock down the application to only allow logged
in users to be able to modify things.  In practice we probably wouldn't want an
open sign up for our app. Or we would we may want to limit the accessing of things
on a per user basis.

* Let's add the following to our ```app/controllers/application_controller.rb```

```ruby
def logged_in_user
  unless logged_in?
    flash[:danger] = "Please log in."
    redirect_to login_url
  end 
end
```

* Now whenever we want to limit a controller action to require the user be logged
in we can add the following:

```ruby
before_action :logged_in_user
```

* Next let's change our task entry screen to have a dropdown list of users, but
first we'll style up the existing form.


```erb

<% if @task.errors.any? %>
  <div id="error_explanation">
    <h2><%= pluralize(@task.errors.count, "error") %> prohibited this task from being saved:</h2>

    <ul>
    <% @task.errors.full_messages.each do |message| %>
      <li><%= message %></li>
    <% end %>
    </ul>
  </div>
<% end %>

<%= form_for([@project, @task], html: {class: 'form-horizontal'}) do |f| %>
  <fieldset>
    <div class="form-group">
      <%= f.label :employee_name, class: "col-lg-2 control-label" %><br>
      <div class="col-lg-10">
        <%= collection_select(:task, :employee_name, User.all, :name, :name, prompt: true) %>
      </div>
    </div>

    <div class="form-group">
      <%= f.label :time, class: "col-lg-2 control-label" %><br>
      <div class="col-lg-10">
        <%= f.number_field :time, class: "form-control" %>
      </div>
    </div>

    <div class="form-group">
      <%= f.label :date, class: "col-lg-2 control-label" %><br>
      <div class="col-lg-10">
        <%= f.date_select :date, class: "form-control" %>
      </div>
    </div>

    <div class="form-group">
      <%= f.label :description, class: "col-lg-2 control-label" %><br>
      <div class="col-lg-10">
        <%= f.text_area :description, class: "form-control" %>
      </div>
    </div>

    <div class="actions">
      <%= f.submit %>
    </div>


  </fieldset>

<% end %>

```

* With that our app is feature complete, now we'll start working on adding some fun features.

* First let's create a rake task to populate our database with realistic fake data using a gem called Faker.
  * [https://github.com/stympy/faker](https://github.com/stympy/faker)

```ruby
group :development, :test do
  ...
  gem 'faker'
end

```

* Then we'll add file called populate.rake in lib/tasks and first define our
namespace

```ruby
namespace :fake do  
end
```

* Next we'll add a task for generating users

```ruby
  desc "generating fake users"
  task :users => [:environment] do
    50.times do
      User.create(name: Faker::Name.name,
                  email: Faker::Internet.email,
                  password: 'test123456',
                  password_confirmation: 'test123456')
    end
  end
```

* Then a task for generating clients

```ruby
  desc "generating fake clients"
  task :clients => [:environment] do
    50.times do
      Client.create(name: Faker::Company.name,
                    contact_name: Faker::Name.name,
                    phone: Faker::PhoneNumber.phone_number,
                    contact_email: Faker::Internet.email,
                    street: Faker::Address.street_address,
                    city: Faker::Address.city,
                    state: Faker::Address.state,
                    postal_code: Faker::Address.postcode)
    end
  end
```

* Then projects

```ruby
  desc "generating fake projects"
  task :projects => [:environment, :clients] do
    100.times do
      client_ids = Client.all.collect { |c| c.id }
      Project.create(title: Faker::App.name,
                     description: Faker::Lorem.paragraph,
                     start_date: rand(1..20).days.ago,
                     end_date: rand(1..20).days.from_now,
                     client_id: client_ids.shuffle.first)
    end
  end
```

* Then tasks

```ruby
  desc "generating fake tasks"
  task :tasks => [:environment, :users, :projects] do
    project_ids = Project.all.collect { |p| p.id }

    100.times.each_with_index do |index|
      project = Project.find(project_ids[index])
      rand(1..20).times do
        user_names = User.all.collect { |u| u.name }
        Task.create(employee_name: user_names.shuffle.first,
                    time: rand(1..24),
                    date: Faker::Time.between(project.start_date, project.end_date, :all),
                    project: project,
                    description: Faker::Lorem.sentences )

      end
    end
  end
```

* Finally why not have one task that does everything?

```ruby
  desc "generating fake data"
  task :all_data => [:environment, :users, :clients, :projects, :tasks] do
  end
```
