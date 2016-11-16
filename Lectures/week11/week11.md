footer:@johnsonch :: Chris Johnson :: Ruby on Rails Development :: Week 11
autoscale: true

#Ruby on Rails Development
##Week 11

---

#Demo

###If you need to re-clone
* ```$ git clone git@bitbucket.org:johnsonch/wolfie_budget.git```
* ```$ cd wolfie_budget```
* ```$ bundle install --without production```

###If you have it already cloned
* cd into ```wolfie_budget```
* ```$ git add . ```
* ```$ git commit -am 'commiting files from in class'```
* ```$ git checkout master```
* ```$ git fetch```
* ```$ git pull ```
* ```$ git checkout week_11_start```
* ```$ rm -f db/*.sqlite3```
* ```$ bundle```
* ```$ rake db:migrate```

---
#Authorization
* In Wolfie Budget we'll want to lock down the application to only allow logged
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

* If we want to limit what actions we are calling the before action filter on we can scope it like the followign for the sessions controller:

```Ruby
before_action :logged_in_user, only: [:destroy]
```

* Or for things like the the user controller

```
before_action :logged_in_user, only: [:show]
```

* Let's create a rake task to populate our database with realistic fake data using a gem called Faker.
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

* Next we'll add a task for generating users to lib/tasks/populate.rake

```ruby
  desc "generating fake users"
  task :users => [:environment] do
    50.times do
      User.create(first_name: Faker::Name.first_name,
                  last_name: Faker::Name.last_name,
                  email: Faker::Internet.email,
                  password: 'P@ssw0rd!',
                  password_confirmation: 'P@ssw0rd!')
    end
  end
```

* Then a task for generating budgets

```ruby
  desc "generating fake budgets"
  task :budgets => [:environment] do
    user_ids = User.all.collect { |u| u.id }
    50.times do
       user = User.find(user_ids.shuffle.first)
       user.budgets.create(year: Faker::Date.between(100.years.ago, Date.today).year,
                           month: Faker::Date.between(12.months.ago, Date.today).month,
                           notes: Faker::Lorem.paragraph)
    end
  end
```

* Finally why not have one task that does everything?

```ruby
  desc "generating fake data"
  task :all_data => [:environment, :users, :budgets] do
  end
```


#Account activation
##Activation

* Generate AccountActivations controller

```bash
$ bundle exec rails generate controller AccountActivations edit
```

* Add a route for our controller

```ruby
resources :account_activations, only: [:edit]
```

* Add our model additions for activation

```bash
$ bundle exec rails generate migration add_activation_to_users activation_digest:string activated:boolean activated_at:datetime
```

* Create a new activation token for each user creation in the user model

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

* We can test this in the rails console by creating a new user and saving it

```ruby
@user = User.new(first_name: "Bart",
                 last_name: "Simpson",
                 email: "bart@simpsons.com",
                 password: "P@ssw0rd!",
                 password_confirmation: "P@ssw0rd!")
@user.save
```

* Then we can refactor this code to some smaller methods

```ruby
    def create_activation_token
      self.activation_token  = SecureRandom.urlsafe_base64
      self.activation_digest = create_digest(self.activation_token)
    end

    def create_digest(token)
      BCrypt::Password.create(self.activation_token, cost: cost)
    end

    def cost
      if ActiveModel::SecurePassword.min_cost
        return BCrypt::Engine::MIN_COST
      else
        return BCrypt::Engine.cost
      end
    end
```


* Let's keep working through the process and send out an email

```bash
$ bundle exec rails generate mailer UserMailer account_activation password_reset
```

* Next make the user activation mailer take a user object

```ruby
  def account_activation(user)
    @user = user
    mail to: @user.email, subject: "Account activation"
  end
```

* Update the 'views' for account activation

###```app/views/user_mailer/account_activation.text.erb```


```erb
Hi <%= @user.firs_name %>,

Welcome to the Wolfie Budget! Click on the link below to activate your account:

<%= edit_account_activation_url(@user.activation_token, email: @user.email) %>
```

###```app/views/user_mailer/account_activation.html.erb ```

```
<h1>Wolfie's List</h1>

<p>Hi <%= @user.first_name %>,</p>

<p>
Welcome to the Wolfie Budget! Click on the link below to activate your account:
</p>

<%= link_to "Activate", edit_account_activation_url(@user.activation_token, email: @user.email) %>
```

* Next to test our emailing we'll need to configure our development.rb file

```
  config.action_mailer.default_url_options = { :host => 'http://localhost:3000' }
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

###`config/initializers/smtp.rb`

```ruby
ActionMailer::Base.smtp_settings = {
      :address              => ENV['smtp_server'],
      :port                 => 587,
      :user_name            => ENV['smtp_user'],
      :password             => ENV['smtp_password'],
      :authentication       => 'login',
      :enable_starttls_auto => true,
      :openssl_verify_mode  => 'none'
}
```

* **NOTE** For this to work on Heroku we would need to set environment variables, this is something to note for your own environment.

```bash
$ heroku config:set SMTP_SERVER=my.mail.server
```


* Then we'll add a method to authenticate our users model

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
* Let's send out an email to the user when they are created in the user controller

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
