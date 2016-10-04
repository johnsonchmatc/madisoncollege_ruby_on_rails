#Ruby on Rails Development
##Chapter 6
###Week 6

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

###If you need to re-clone
* ```$ git clone git@bitbucket.org:johnsonch/wolfie_budget.git```
* ```$ cd wolfie_budget```
* ```$ bundle install --without production```

###If you have it already cloned
* ```$ git add . ```
* ```$ git commit -am 'commiting files from in class'```
* ```$ git checkout master```
* ```$ git fetch```
* ```$ git pull ```
* ```$ git checkout  week06_in_class```
* ```$ bundle install --without production```

```
$ bundle exec rails generate controller Users new
$ bundle exec rails generate model User first_name:string last_name:string email:string
$ bundle exec rails db:migrate
```

```ruby
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(first_name: "Bart",
                     last_name: "Simpson",
                     email: "bart@simpsons.com")
  end

  test "should be valid" do
    assert @user.valid?
  end
end
```

```
$ bundle exec rake test
```

```ruby
class User < ApplicationRecord
  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
end
```

```ruby
has_secure_password
```

```
$ bundle exec rails generate migration add_password_digest_to_users password_digest:string
$ bundle exec rails db:migrate
```

```ruby
gem 'bcrypt',         '3.1.11'
```

```
$ bundle
```

* Add password and password_confirmation to user test

* Create a user in the console

```
$ bundle exec rails c

>> User.create(first_name: "Bart", last_name: "Simpson", email: "bart@simpsons.com", password: "foobar", password_confirmation: "foobar"
>> bart_user = User.find_by(email: "bart@simpsons.com")
>> users = User.all
>> users.collect { |u| u.email }
```

* Get some of the app scaffolded

```
$ bundle exec rails generate scaffold Budgets user_id:integer year:integer month:string notes:text
$ bundle exec rails generate scaffold Categories user_id:integer name:string amount:float
$ bundle exec rails generate scaffold BudgetCategories budget_id:integer category_name:string category_amount:float
$ bundle exec rails generate scaffold BudgetEntries budget_category_id:integer amount:float notes:text
```

* Adding relationships is fun!

```ruby
class Budget < ApplicationRecord
  belongs_to :user
  has_many :budget_categories
end

class BudgetCategory < ApplicationRecord
  belongs_to :budget
  has_many :budget_entries
end


class BudgetEntry < ApplicationRecord
  belongs_to :budget_category
end


class Category < ApplicationRecord
  belongs_to :user
end
   
   
class User < ApplicationRecord
  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_secure_password

  has_many :cateories
  has_many :budgets
end
```

* Now run our tests

```
$ bundle exec rails test
```

* Oh no things are broke!  Let's fix them.  We added relationships, now we need to make sure our test setup is right.  Look at each test and figure out why it is failing then try to make it right.

```
@loaded_fixter.relationship = relationship_fixture(:fixture)
```