footer:@johnsonch :: Chris Johnson :: Ruby on Rails Development :: Week 11
autoscale: true

#Ruby on Rails Development
##Week 11

* https://codecaster.io room: johnsonch

---
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
* ```$ git checkout week10_start```
* ```$ rm -f db/*.sqlite3```
* ```$ bundle```
* ```$ rake db:migrate```

---
#Authorization
* In WolfieReader we'll want to lock down the application to only allow logged
in users to be able to use our app.

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


#Account activation
##Activation

* Generate AccountActivations controller

```bash
$ bundle exec rails generate controller AccountActivations
```

* Add a route for our controller

```ruby
resources :account_activations, only: [:edit]
```

* Add our model additions for activation

```bash
$ bundle exec rails generate migration add_activation_to_users activation_digest:string activated:boolean activated_at:datetime
```

* Create a new activation token for each user creation

```ruby
  before_create :create_activation_token

  private

    def create_activation_token
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      self.activation_token  = SecureRandom.urlsafe_base64
      self.activation_digest = BCrypt::Password.create(self.activation_token, cost: cost)
    end
```

* We'll need to be able to access our activation_token

```ruby
attr_accessor :activation_token
```

* Let's keep working through the process and send out an email

```bash
$ bundle exec rails generate mailer UserMailer account_activation password_reset
```

* Next make the activation mailer take a user object

```ruby
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end
```

* Update the 'views' for account activation

###```app/views/user_mailer/account_activation.text.erb```


```erb
Hi <%= @user.name %>,

Welcome to the Wolfie Books! Click on the link below to activate your account:

<%= edit_account_activation_url(@user.activation_token, email: @user.email) %>
```

###```app/views/user_mailer/account_activation.htm.erb ```

```
<h1>Wolfie's List</h1>

<p>Hi <%= @user.name %>,</p>

<p>
Welcome to the Wolfie Books! Click on the link below to activate your account:
</p>

<%= link_to "Activate", edit_account_activation_url(@user.activation_token, email: @user.email) %>
```

* Next to test our emailing we'll need to configure our development.rb file

```
  config.action_mailer.default_url_options = { :host => 'https://matc-rails-fall-2015-johnsonch.c9.io' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
```

* We need to get our SMTP settings in place, we're going to use a gem called [figaro](https://github.com/laserlemon/figaro), we'll add it to our gemfile:

```ruby
gem "figaro"
```

* Then we'll use the follwing command to get a generated application.yml file:

```bash
$ bundle exec figaro install
```

* We'll add the following snippet to your application.yml, your instructor will use codecaster to send you the senstivie information. Also to note this application.yml file should never be commited, you don't want this sensitive informatin published out to sources other people can look at.

```yaml
development:
  smtp_server:
  smtp_user:
  smtp_password:
```

* Next we'll add an initializer to setup our email settings

###```config/initializers/smtp.rb````

```ruby
ActionMailer::Base.smtp_settings = {
      :address              => ENV['smtp_server'],
      :port                 => 587,
      :user_name            => ENV['smtp_user'],
      :password             => ENV['smtp_password'],
      :authentication       => 'login',
      :enable_starttls_auto => true,
      :openssl_verify_mode => 'none'
}
```

* For this to work on Heroku we'll need to set environment variables, this is something to note for your own environment.

```bash
$ heroku config:set SMTP_SERVER=my.mail.server
```


* Then we'll add a method to authenticate our users

```ruby
def authenticated?(attribute, token)
  digest = send("#{attribute}_digest")
  return false if digest.nil?
  BCrypt::Password.new(digest).is_password?(token)
end
```

* Now we can add the edit action to our activation controller

```ruby
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute(:activated, true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
```
* Let's send out an email to the user when they are created

```ruby
  if @user.save && UserMailer.account_activation(@user).deliver_now
    flash[:info] = "Please check your email to activate your account."
    redirect_to root_url
  ....
```

* Don't let users who haven't activated login

```ruby
if user.activated?
  log_in(user)
  redirect_to(user)
else
  message  = "Account not activated. Check your email for the activation link."
  flash[:warning] = message
  redirect_to root_url
end
```

---
## Next we'll add WillPaginate

```ruby
gem 'will_paginate', '~> 3.0.6'
```

* Then we'll need to install the gem

```bash
$ bundle install
```

* Simply adjust the index action you want to paginate

```ruby
  def index
    @projects = Project.paginate(:page => params[:page], :per_page => 10)
  end
```

* Then add the page picker helper to your index page

```erb
<div class="row">
  <div class="col-md-12">
    <%= will_paginate @projects %>
  </div>
</div>
```
