#Ruby on Rails Development
##Chapter 7
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
* ```$ git checkout week06_start```
* ```$ rm -f db/*.sqlite3```
* ```$ bundle```
* ```$ rake db:migrate```

```
$ bundle exec rails generate controller Users new
$ bundle exec rails generate model User first_name:string last_name:string email:string
$ bundle exec rake db:migrate
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
class User < ActiveRecord::Base
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
$ bundle exec rake db:migrate
```

```ruby
gem 'rails',                '4.2.2'
gem 'bcrypt',               '3.1.7'
```

```
$ bundle
```

* Add password and password_confirmation to user test

```
$ bundle exec rails generate scaffold Feed url:string name:string
$ bundle exec rails generate model FeedsUsers user_id:integer feed_id:integer --force-plural
```

```
has_and_belongs_to_many :feeds
```

```
has_and_belongs_to_many :users
```


