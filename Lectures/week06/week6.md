#Ruby on Rails Development
##Chapter 6
###Week 6

---
#Ruby and Rails API Docs

* [http://api.rubyonrails.org/](http://api.rubyonrails.org/)
* [https://ruby-doc.org/](https://ruby-doc.org/)

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

```ruby
class Call < ActiveRecord::Base
  validates :location_id, presence: true, unless: :location_other
  validates :location_other, presence: true, unless: :location_id
end
```

* Provides error messages back to the controller
* [http://guides.rubyonrails.org/active_record_validations.html#validation-helpers](http://guides.rubyonrails.org/active_record_validations.html#validation-helpers)

---

---
#Demo

###If you need to re-clone (need to start from scratch)
* ```$ git clone git@bitbucket.org:johnsonch/wolfie_eats.git```
* ```$ cd wolfie_eats```
* ```$ git checkout week06_in_class```
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

Let's itterate on a test, starting simple and refactoring it to be useful for
more tests.

```ruby
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @valid_user = User.new(first_name: "Bart",
                           last_name: "Simpson",
                           email: "bart@simpsons.com")
  end

  test "should be valid" do
    assert @valid_user.valid?
  end
end
```

```
$ bundle exec rails test
```

```ruby
class User < ApplicationRecord
  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
end
```

Adding tests for these validations

```
test "first name needs to be present" do
  @valid_user.first_name = nil
  assert_equal @valid_user.valid?, false
end

test "last name needs to be present" do
  @valid_user.last_name = nil
  assert_equal @valid_user.valid?, false
end

test "email to be present" do
  @valid_user.email = nil
  assert_equal @valid_user.valid?, false
end  
```

```ruby
has_secure_password
```

```
$ bundle exec rails generate migration add_password_digest_to_users password_digest:string
$ bundle exec rails db:migrate
```

The bcrypt Gem should be there and be this version

```ruby
gem 'bcrypt',         '3.1.11'
```

If you had to add it then you'll need to bundle

```
$ bundle
```

* Add password and password_confirmation to user test

* Create a user in the console

```
$ bundle exec rails c

>> User.create(first_name: "Bart", last_name: "Simpson", email: "bart@simpsons.com", password: "foobar", password_confirmation: "foobar")
>> bart_user = User.find_by(email: "bart@simpsons.com")
>> users = User.all
>> users.collect { |u| u.email }
```

Lets check our tests again.

```
$ bundle exec rails test
```

Oops, lets fix them

```ruby
def setup
  @valid_user = User.new(first_name: "Bart",
                         last_name: "Simpson",
                         password: 'foobar',
                         password_confirmation: 'foobar',
                         email: "bart@simpsons.com")
end
```

```
$ bundle exec rails test
```

* Get some of the app scaffolded

```
$ bundle exec rails generate scaffold Recipes user_id:integer name:string directions:text
$ bundle exec rails generate scaffold RecipesIngredients recipe_id:integer ingredient_id:integer quantity:string unit:string
$ bundle exec rails generate scaffold Ingredients name:string description:text
$ bundle exec rails db:migrate
```

* Adding relationships is fun!

```ruby
class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipes_ingredients
end

class RecipesIngredient < ApplicationRecord
  belongs_to :recipe
  belogns_to :ingredient
end

class Ingredient < ApplicationRecord
  has_many :recipes_ingredient
end


class User < ApplicationRecord
  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  
  has_secure_password
  
  has_many :recipes
end
```

* Now run our tests

```
$ bundle exec rails test
```

* Oh no things are broke!  Let's fix them.  We added relationships, now we need to make sure our test setup is right.  Look at each test and figure out why it is failing then try to make it right.

```
##Example
@loaded_fixter.relationship = relationship_fixture(:fixture)
```
