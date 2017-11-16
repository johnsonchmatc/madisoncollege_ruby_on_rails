Generate activations controller
```
$ bundle exec rails generate controller AccountActivations

```

We need to story activation information on the user
```
$ bundle exec rails generate migration add_activation_to_users activation_digest:string activated:boolean activated_at:datetime
```

Update routes to only allow edit for activations,the generation of the controller alone does not update the routes file
```
resources :account_activations, only: [:edit]
```

User model needs to have `activation_token` accessor
```
class User < ApplicationRecord
  attr_accessor :activation_token, :activation_digest

  before_create :create_activation_digest

  validates :email, presence: true, length: { minimum: 5 }

  has_secure_password

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  private

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
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
    @user = user # We need the instance variable for the view
    mail to: user.email, subject: "Account activation"
  end
```

* Update the 'views' for account activation

### ```app/views/user_mailer/account_activation.text.erb```


```erb
Hi <%= @user.first_name %>,

Welcome to Mad Libs! Click on the link below to activate your account:

<%= edit_account_activation_url(@user.activation_token, email: @user.email) %>
```

### ```app/views/user_mailer/account_activation.html.erb ```

```
<h1>Mad Libs</h1>

<p>Hi <%= @user.first_name %>,</p>

<p>
Welcome to Mad Libs! Click on the link below to activate your account:
</p>

<%= link_to "Activate", edit_account_activation_url(@user.activation_token, email: @user.email) %>
```

* Next to test our emailing we'll need to configure our development.rb file

```
  config.action_mailer.default_url_options = { :host => 'http://localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
```

* To get our SMTP settings in place, we're going to use a gem called [figaro](https://github.com/laserlemon/figaro), we'll add it to our gemfile:

```ruby
gem "figaro"
```

* Then we'll use the follwing command to get a generated application.yml file:

```bash
$ bundle exec figaro install
```
To help us test emails we're going to signup for an account at https://mailtrap.io. You can use an email address or link it to your Github account.

![](https://dl.dropboxusercontent.com/s/t7efpq1x75kyeqa/2017-04-04%20at%2010.10%20PM.png)



* We'll add the following snippet to your application.yml, you will copy the configuration from mailtrap.io

```yaml
development:
  smtp_server:
  smtp_user:
  smtp_password:
  smtp_domain:
  smtp_port:
  smtp_authentication:
```

* Next we'll add an initializer to setup our email settings

###`config/initializers/smtp.rb`

```ruby
ActionMailer::Base.smtp_settings = {
      :address              => ENV['smtp_server'],
      :port                 => ENV['smtp_port'],
      :user_name            => ENV['smtp_user'],
      :password             => ENV['smtp_password'],
      :domain               => ENV['smtp_domain'],
      :authentication       => ENV['smtp_authentication']
}
```

* **NOTE** For this to work on Heroku we would need to set environment variables for each, this is something to note for your own environment.

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

* Don't let users in who haven't activated login

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

