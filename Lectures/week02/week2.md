# Ruby on Rails Development
## Week 2

----
# Agenda
* Terminology
* Generating a new Rails application
  * Gems
  * Bundler
* Git
* Heroku

---
# What is Ruby?

> A dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant syntax that is natural to read and easy to write.

---
# What is Rails
> Ruby on Rails is an open-source web framework that's optimized for programmer happiness and sustainable productivity.

---
# Ruby version Managers
* Tools to allow you to install several versions of Ruby side by side
* Popular ones are: RVM, rbenv and chruby.

---
# What are Gems (RubyGems)?
>RubyGems is a package manager for the Ruby programming language that provides a standard format for distributing Ruby programs and libraries (in a self-contained format called a "gem"), a tool designed to easily manage the installation of gems, and a server for distributing them.

---
# The Gem command
* ```$ man gem```
* ```$ gem install <gem name> -v=<gem version>```
* ```$ gem list```
* ```$ gem uninstall <gem name>```

---
# Configuration Files
## AKA 'Dot' files

---
# Dot Files
* Start with a ```.``` so they are 'hidden'
* Can be used to configure many applications

---
# .gemrc

```
install: --no-rdoc --no-ri
update:  --no-rdoc --no-ri
```
* This says don't install ri or rdoc when installing a gem
* If you *need* docs locally remove these

---
# ```$ rails new```

---

```
$ rails new expense-tracker
      create
      create  README.rdoc
      create  Rakefile
      create  config.ru
      create  .gitignore
      create  Gemfile
      create  app
      create  app/assets/javascripts/application.js
      create  app/assets/stylesheets/application.css
      create  app/controllers/application_controller.rb
      .
      .
      .
      create  vendor/assets/stylesheets/.keep
         run  bundle install
```

---
# Let's explore what files are generated
---
# Instructor opinion
Add the ```--skip-bundle``` flag at the end of your generation command.  It allows your app to be generated and you to make changes before installing gems.

---
# Bundler
>Bundler is an exit from dependency hell, and ensures that the gems you need are present in development, staging, and production. Starting work on a project is as simple as ```bundle install```.

---
# Bundler
Makes use of two files:
* Gemfile
* Gemfile.lock

---
# Bundler
## Gemfile
* A list of all your application's required Gems
* Bundler uses this to manage which Gems to load
* [http://bundler.io/v1.2/man/gemfile.5.html](http://bundler.io/v1.2/man/gemfile.5.html)
* Allows you to group gems for what they are used for ie. Test, Development, Production

---
# Bundler
## Gemfile.lock
* A snapshot from when you run bundle install.
* Not the best idea to modify by hand!

---
# Bundler
* ```$ bundle help```
* ```$ bundle install``` installs gems
* ```$ bundle check``` checks to see if Gemfile is satisfied
* [http://bundler.io/v1.15/commands.html](http://bundler.io/v1.15/commands.html)

---
# Rails server
* ```$ bundle exec rails server ```

---

```shell
$ cd expense-tracker
$ rails g scaffold Category name:string
$ rails g scaffold Expense category_id:integer title:string description:text purchase_date:date amount:float
$ rails db:migrate
$ bundle exec rails server
```

Now we can explore what all is there for us. Let's look at some of the pages that we can access and use.

Next we can add "relationships" to our models and see how they link things together for us.

>app/models/category.rb
```ruby
class Category < ApplicationRecord
  has_many :expenses
end
```

>app/models/expense.rb
```ruby
class Expense < ApplicationRecord
  belongs_to :category
end
```

Notice the plural and singular versions of the model, it is significant.

After we have our relationships in place we can move on to using them in our views. Let's work on our expenses pages. We'll start with the index file.

> app/views/expenses/index.html.erb
```erb
<td><%= expense.category.name %></td>
```

Now we can make the dropdown dynamic so it shows the list of categories, rather than us needing to select a number.

> app/views/expenses/_form.html.erb
```erb
<div class="field">
  <%= f.label :category_id %>
  <%= select(:expense, :category_id, Category.all.map{ |u| [ u.name, u.id ] }, { include_blank: true })%>
</div>
```

Next we can modify logic to be removed from the view and moved to the controller.

> app/controllers/expenses_controller.rb
```ruby
before_action :load_categories, only: [:new, :edit, :create, :update]
...
private
  def load_categories
    @categories = Category.all.map{ |u| [ u.name, u.id ] }
  end
```

With an instance variable available to our view we can simplify our dropdown logic

> app/views/expenses/_form.html.erb
```erb
<%= select(:expense, :category_id, @categories, { include_blank: true })%>
```



---
#Lab time

* [Lab 2](../Labs/lab2.md)

---
#Exit Ticket
* [http://exitticket.johnsonch.com](http://exitticket.johnsonch.com)
