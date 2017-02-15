footer:@johnsonch :: Chris Johnson :: Ruby on Rails Development - Week 5
autoscale: true

#Ruby on Rails Development
##Week 5

* Forking class repo to contribute
* Asset pipeline
* Starting Wolfie Eats

---
# Forking class repo to contribute

---
#Preparing for the demo today

* ```$ git clone git@bitbucket.org:johnsonch/wolfie_eats.git```
* ```$ cd wolfie_eats```
* ```$ bundle install --without production```

^ NOTE: If you are having trouble cloning the repository you will need to make sure your SSH keys are on bitbucket

---
#What are we building?
##Wolfie Eats

> An online Eats tracker for all your financial transactions

###Here is our rough database/model design

![](https://dl.dropboxusercontent.com/s/9alljepitwzip0p/2017-02-13%20at%2011.28%20PM.png)


---
#Themes

[Bootswatch.com](https://bootswatch.com/)

---
#Asset Pipeline
---

![fit](http://media.railscasts.com/assets/episodes/videos/279-understanding-the-asset-pipeline.mp4)

^ http://media.railscasts.com/assets/episodes/videos/279-understanding-the-asset-pipeline.mp4


---
#Demo

Start with our reset steps

* cd into ```wolfie_eats```
* ```$ git add . ```
* ```$ git commit -am 'commiting files from in class'```
* ```$ git checkout master```
* ```$ git fetch```
* ```$ git pull ```
* ```$ git checkout  week05_in_class```
* ```$ bundle install --without production```

---
```
$ bundle exec rails g controller StaticPages home about opensource
```

A bit more about bundler

```$ bundle```

Running just bundle here will take advantage of the setting stored from the first time we used bundler in the .bundle folder

# Adding a layout
Next create a bootswatch.css file in app/assets/stylesheets also and copy the code
from bootswatch for this theme. Let's use [https://bootswatch.com/yeti/](https://bootswatch.com/yeti/)

Next we need to define our layout. There is a great site [http://www.layoutit.com/](http://www.layoutit.com/) which can help you add bootstrap components.

We're going to start by dumping the whole layout in our app/views/layouts/application.html.erb file. Replace the contents of that file with the code below. I'll do it piece by peice but this let's you get the whole file right.

```erb
<!DOCTYPE html>
<html>
  <head>
    <title>WolfieEats</title>
    <%= csrf_meta_tags %>

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>
    <nav class="navbar navbar-default navbar-static-top" role="navigation">
      <div class="navbar-header">

        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
          <span class="sr-only">Toggle navigation</span><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span>
        </button> <a class="navbar-brand" href="#">Brand</a>
      </div>

      <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
        <ul class="nav navbar-nav">
          <li class="active">
            <a href="#">Home</a>
          </li>
          <li>
            <a href="#">About</a>
          </li>
          <li>
            <a href="#">Opensource at Wolfie Eats</a>
          </li>
        </ul>
        <form class="navbar-form navbar-left" role="search">
          <div class="form-group">
            <input type="text" class="form-control" />
          </div>
          <button type="submit" class="btn btn-default">
            Submit
          </button>
        </form>
        <ul class="nav navbar-nav navbar-right">
          <li>
            <a href="#">Link</a>
          </li>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown<strong class="caret"></strong></a>
            <ul class="dropdown-menu">
              <li>
                <a href="#">Action</a>
              </li>
              <li>
                <a href="#">Another action</a>
              </li>
              <li>
                <a href="#">Something else here</a>
              </li>
              <li class="divider">
              </li>
              <li>
                <a href="#">Separated link</a>
              </li>
            </ul>
          </li>
        </ul>
      </div>

    </nav>
    <div class="container-fluid">
      <div class="row">
        <div class="col-md-12">
          <%= yield %>
        </div>
      </div>
    </div>
  </body>
</html>
```

# Default route
Now we need to make our application default to this page when someone access our app.  We can start by making a failing test for a ```root_path```. First we should run our tests and make sure they are green so we're not troubleshooting anything but our test.

Run your tests with ```$ rails test``` and you should get some output similar to below, if you don't alert your instructor.

```
workspace/wolfie_eats ‹week05_prep*› » rails test
Running via Spring preloader in process 43013
/Users/cjohnson/School/Rails/rails_vagrant/workspace/wolfie_eats/db/schema.rb doesn't exist yet. Run `rails db:migrate` to create it, then try again. If you do not intend to use a database, you should instead alter /Users/cjohnson/School/Rails/rails_vagrant/workspace/wolfie_eats/config/application.rb to limit the frameworks that will be loaded.
Run options: --seed 36118

# Running:

...

Finished in 0.527531s, 5.6869 runs/s, 5.6869 assertions/s.

3 runs, 3 assertions, 0 failures, 0 errors, 0 skips

```

Now we can open ```test/controllers/static_pages_controller_test.rb``` and make our failing test

```ruby
  test "should have a root url" do
    get root_path
    assert_response :success
  end
```

Now run your tests with ```$ rails test``` again and you should see a failure like

```
Error:
StaticPagesControllerTest#test_should_have_a_root_url:
NameError: undefined local variable or method `root_path' for #<StaticPagesControllerTest:0x007fa813cf4960>
    test/controllers/static_pages_controller_test.rb:5:in `block in <class:StaticPagesControllerTest>'
```

Let's add a root route in ```config/routes.rb``` to make this error go away


```
root 'static_pages#home'
```

Now run your tests with ```$ rails test``` again and you should see a much success!

```
Finished in 0.570397s, 7.0127 runs/s, 7.0127 assertions/s.

4 runs, 4 assertions, 0 failures, 0 errors, 0 skips
```

#Organizing the layout

Next we can move that navigation section out into a partial, create a file called ```_navigation.html.erb``` in the layouts directory.

Copy all of the navigation element out of ```application.html.erb``` and move it to ```_navigation.html.erb```.  Your ```_navigation.html.erb``` should look like:

```erb
<nav class="navbar navbar-default navbar-static-top" role="navigation">
  <div class="navbar-header">

    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
      <span class="sr-only">Toggle navigation</span><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span>
    </button> <a class="navbar-brand" href="#">Brand</a>
  </div>

  <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
    <ul class="nav navbar-nav">
      <li class="active">
        <a href="#">Home</a>
      </li>
      <li>
        <a href="#">About</a>
      </li>
      <li>
        <a href="#">Opensource at Wolfie Eats</a>
      </li>
    </ul>
    <form class="navbar-form navbar-left" role="search">
      <div class="form-group">
        <input type="text" class="form-control" />
      </div>
      <button type="submit" class="btn btn-default">
        Submit
      </button>
    </form>
    <ul class="nav navbar-nav navbar-right">
      <li>
        <a href="#">Link</a>
      </li>
      <li class="dropdown">
        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown<strong class="caret"></strong></a>
        <ul class="dropdown-menu">
          <li>
            <a href="#">Action</a>
          </li>
          <li>
            <a href="#">Another action</a>
          </li>
          <li>
            <a href="#">Something else here</a>
          </li>
          <li class="divider">
          </li>
          <li>
            <a href="#">Separated link</a>
          </li>
        </ul>
      </li>
    </ul>
  </div>

</nav>
```




Then add the following code to ```application.html.erb```

```erb
<%= render 'layouts/navigation' %>
```

so that your ```application.html.erb``` looks like:


```erb
<!DOCTYPE html>
<html>
  <head>
    <title>WolfieEats</title>
    <%= csrf_meta_tags %>

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>

    <%= render 'layouts/navigation' %>

    <div class="container-fluid">
      <div class="row">
        <div class="col-md-12">
          <%= yield %>
        </div>
      </div>
    </div>
  </body>
</html>


```

#Working on the home page

Next we'll add a jumbotron element to our home page, open up ```static_pages/home.html.erb``` and add replace it's content with the following code which we got from the bootswatch styleguide:

```html
<div class="jumbotron">
  <h1>Welcome to Wolfie Eats</h1>
  <p>Let's Eat.</p>
  <p><a class="btn btn-primary btn-lg">Learn more</a></p>
</div>
```



Next, let's add the gems we are using to our ```opensource page```. We'll start off by adding the markup provided by bootswatch and modifying it

```html
<table class="table table-striped table-hover ">
  <thead>
    <tr>
      <th>#</th>
      <th>Column heading</th>
      <th>Column heading</th>
      <th>Column heading</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>1</td>
      <td>Column content</td>
      <td>Column content</td>
      <td>Column content</td>
    </tr>
  </tbody>
</table>
```

Now in our controllerf we'll add an array of all our gems (this is going to be gross but it's to learn)

```ruby
@gems = [{name: 'rails', version: '5.0.0.1'},
        {name: 'puma', version: '3.4.0'},
        {name: 'sass-rails', version: '5.0.6'},
        {name: 'uglifier', version: '3.0.0'},
        {name: 'coffee-rails', version: '4.2.1'},
        {name: 'jquery-rails', version: '4.1.1'},
        {name: 'turbolinks', version: '5.0.1'},
        {name: 'jbuilder', version: '2.4.1'},
        {name: 'bootstrap-sass', version: '3.3.6'},
        {name: 'sqlite3', version: '1.3.11'},
        {name: 'byebug', version: '9.0.0'},
        {name: 'web-console', version: '3.1.1'},
        {name: 'listen', version: '3.0.8'},
        {name: 'spring', version: '1.7.2'},
        {name: 'spring-watcher-listen', version: '2.0.0'},
        {name: 'rails-controller-testing', version: '0.1.1'},
        {name: 'minitest-reporters', version: '1.1.9'},
        {name: 'guard', version: '2.13.0'},
        {name: 'guard-minitest', version: '2.4.4'},
        {name: 'pg', version: '0.18.4'}]


```

Next we can modify the table to display our data

```erb
<table class="table table-striped table-hover ">
  <thead>
    <tr>
      <th>Gem Name</th>
      <th>Version</th>
    </tr>
  </thead>
  <tbody>
    <% @gems.each do |gem| %>
    <tr>
      <td><%= gem[:name] %></td>
      <td><%= gem[:version] %></td>
    </tr>
    <% end %>
  </tbody>
</table>
```

Let's go make the links in our navigation bar work. First we'll want to make our routes a bit more friendly

```ruby
Rails.application.routes.draw do
  get 'about' => 'static_pages#about'
  get 'opensource' => 'static_pages#opensource'
  root 'static_pages#home'
end
```

Then we can use the ```link_to``` helper to generate links for us.

```erb
    <ul class="nav navbar-nav">
      <li class="active">
        <%= link_to 'Home', root_path %>
      </li>
      <li>
        <%= link_to 'About', about_path %>
      </li>
      <li>
        <%= link_to 'Opensource at Wolfie Eats', opensource_path %>
      </li>
    </ul>
```

Let's run our tests again before we finish up.

```
johnsonch:~/workspace/wolfie_eats (week05_prep) $ bundle exec rails test
Running via Spring preloader in process 2205
/home/ubuntu/workspace/wolfie_eats/db/schema.rb doesn't exist yet. Run `rails db:migrate` to create it, then try again. If you do not intend to use a database, you should instead alter /home/ubuntu/workspace/wolfie_eats/config/application.rb to limit the frameworks that will be loaded.
Run options: --seed 1779

# Running:

.E

Error:
StaticPagesControllerTest#test_should_get_home:
NameError: undefined local variable or method `static_pages_home_url' for #<StaticPagesControllerTest:0x00000004b7e4c8>
    test/controllers/static_pages_controller_test.rb:5:in `block in <class:StaticPagesControllerTest>'


bin/rails test test/controllers/static_pages_controller_test.rb:4

E

Error:
StaticPagesControllerTest#test_should_get_opensource:
NameError: undefined local variable or method `static_pages_opensource_url' for #<StaticPagesControllerTest:0x00000004b6da60>
    test/controllers/static_pages_controller_test.rb:15:in `block in <class:StaticPagesControllerTest>'


bin/rails test test/controllers/static_pages_controller_test.rb:14

E

Error:
StaticPagesControllerTest#test_should_get_about:
NameError: undefined local variable or method `static_pages_about_url' for #<StaticPagesControllerTest:0x0000000689c730>
    test/controllers/static_pages_controller_test.rb:10:in `block in <class:StaticPagesControllerTest>'


bin/rails test test/controllers/static_pages_controller_test.rb:9



Finished in 2.141450s, 1.8679 runs/s, 0.4670 assertions/s.

4 runs, 1 assertions, 0 failures, 3 errors, 0 skips
```

We broke something!  Let's fix it!

```shell
$ bundle exec rails routes
```

```ruby
class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get about_url
    assert_response :success
  end

  test "should get opensource" do
    get opensource_url
    assert_response :success
  end

  test "should have a root url" do
    get root_path
    assert_response :success
  end
end
```

# Circle CI

Looking at seting up continious testing with Circle CI [https://circleci.com](https://circleci.com)