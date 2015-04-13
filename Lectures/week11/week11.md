#Ruby on Rails Development
##Week 11

---
#Logging users in and out

---
#Demo
* cd into ```wolfies_list```

```
$ git add . 
$ git commit -am 'commiting files from in class'
$ git checkout master 
$ git fetch
$ git pull origin master
$ git checkout week11_start
$ bundle install --path=vendor/bundle
 * may need to update rails version ```$ bundle update rails```
$ bundle exec rake db:migrate
```

---
#Account activation
##Activation

* Generate AccountActivations controller
```
$ be rails generate controller AccountActivations
```

* Add a route for our controller
```
resources :account_activations, only: [:edit]
```

* Add our model additions for activiations
```
$ be rails generate migration add_activation_to_users activation_digest:string activated:boolean activated_at:datetime
```

* Create a new activation token for each user creation
```
  before_create :create_activation_token

  private

    def create_activation_token
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      self.activation_token  = SecureRandom.urlsafe_base64
      self.activation_digest = BCrypt::Password.create(self.activation_token, cost: cost)
    end
```

* We'll need to be able to access our activation_token
```
attr_accessor :activation_token
```

* Let's keep working through the process and send out an email
```
$ be rails generate mailer UserMailer account_activation password_reset
```

* Next make the activation mailer take a user object
```
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end
```

* Update the 'views' for account activation
```
#app/views/user_mailer/account_activation.text.erb
Hi <%= @user.name %>,

Welcome to the Wolfie's List! Click on the link below to activate your account:

<%= edit_account_activation_url(@user.activation_token, email: @user.email) %>
```
```
#app/views/user_mailer/account_activation.htm.erb
<h1>Wolfie's List</h1>

<p>Hi <%= @user.name %>,</p>

<p>
Welcome to the Wolfie's List! Click on the link below to activate your account:
</p>

<%= link_to "Activate", edit_account_activation_url(@user.activation_token, email: @user.email) %>
```

* Next to test our emailing we'll need to configure our development.rb file
```
config.action_mailer.raise_delivery_errors = true
config.action_mailer.delivery_method = :test
host = 'pink-bolt-13-187611.use1-2.nitrousbox.com'
config.action_mailer.default_url_options = { host: host }
```

* Then we'll add a method to authenticate our users
```
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
```

* Now we can add the edit action to our activation controller
```
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      login user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
```
* Let's send out an email to the user when they are created
```
  if @user.save && UserMailer.account_activation(@user).deliver_now
    flash[:info] = "Please check your email to activate your account."
    redirect_to root_url
  ....
```

* Don't let users who haven't activated login
```
if user.activated?
  login(user)
  redirect_to(user)
else
  message  = "Account not activated. "
  message += "Check your email for the activation link."
  flash[:warning] = message
  redirect_to root_url
end
```


---
#Locking down ads
* Include sessions helper in ads controller

```
include SessionsHelper
```

* Add method to check to see if the user is logged in

```
def user_logged_in
  unless logged_in?
    flash[:danger] = "Please log in."
    redirect_to login_url
  end
end
```

* Add before filter to require login on everything but show and index

```
before_action :user_logged_in, except: [:index, :show]
```

* Refactor up the method and including of SessionHelper to application controller

* Now let's track what user created the ad
* First generate a migration
```
$ bundle exec rails g migration add_user_id_to_ads
```

* Then update the migration to modify the ads table

```
class AddUserIdToAds < ActiveRecord::Migration
  def change
    add_column :ads, :user_id, :integer
  end
end
```

* Setup relationships
```
#user.rb
has_many :ads
#ads.rb
belongs_to :user
```

* Upadte routes
```
  resources :users do
    resources :ads
  end
  resources :ads, only: [:index, :show]
```

---
