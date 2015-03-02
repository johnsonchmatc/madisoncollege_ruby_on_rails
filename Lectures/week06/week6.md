#Ruby on Rails Development
##Week 6
---
#Chapter 6 
##Modeling Users

---
#Models
##Active Record

---
##Active Record

* Coined by Martin Fowler as:

> An object that wraps a row in a database table or view, encapsulates the database access, and adds domain logic on that data.

* Is an ORM

---
##Perks of Active Record

* Represent models and their data.
* Represent associations between these models.
* Represent inheritance hierarchies through related models.
* Validate models before they get persisted to the database.
* Perform database operations in an object-oriented fashion.

---
##Selecting
* ```users = User.all```
* ```user = User.first```
* ```david = User.find_by(:all, name: 'David')```
* ```users = User.where(name: 'David', occupation: 'Code Artist').order('created_at DESC')```
* ```users = User.where("age >= ? and birth_month = ?", 21, 'March')```

---
#Callbacks
##Don't use them
###Unless you really have to

---
##Callbacks
* save
* valid
* before_validation
* validate
* after_validation

---
##Callbacks
* before_save
* before_create
* create
* after_create
* after_save
* after_commit

---
#Demo
* cd into ```wolfies_list```
* ```$ git add . ```
* ```$ git commit -am 'commiting files from in class'```
* ```$ git fetch```
* ```$ git pull ```
* ```$ git checkout -b week06_start```

^ ```
$ rails generate model User name:string email:string

### Test setup
 def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end

$ rake test:models

test "name should be present" do
    @user.name = nil 
    assert_not @user.valid?
end

validates :name, presence: true

#Repeat for email
#Length of username => 50
#Length of email => 255

Rubular

VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
validates :email, presence: true, length: { maximum: 255 },
                  format: { with: VALID_EMAIL_REGEX }

#Simple email tests then refactor to 
test "email validation should reject invalid addresses" do
  invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                         foo@bar_baz.com foo@bar+baz.com]
  invalid_addresses.each do |invalid_address|
    @user.email = invalid_address
    assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
  end
end

#Add password
has_secure_password
$ rails generate migration add_password_digest_to_users password_digest:string

gem 'rails',                '4.2.0'
gem 'bcrypt',               '3.1.7'

be rake db:migrate

bundle exec rake test ##Should fail because of secure password

Add password and password_confirmation to test setup
```
