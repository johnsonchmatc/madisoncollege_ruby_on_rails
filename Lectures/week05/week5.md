footer:@johnsonch :: Chris Johnson :: Ruby on Rails Development - Week 5
autoscale: true

#Ruby on Rails Development
##Week 5

* Forking class repo to contribute
* Asset pipeline
* Starting WolifeReader
---

# Forking class repo to contribute

---
#Preparing for the demo today

* ```$ git clone git@bitbucket.org:johnsonch/wolfiereader.git```
* ```$ cd wolfiereader```
* ```$ bundle install --without production```

---
#What are we building?
##WolifeReader

---
![fit](https://dl.dropboxusercontent.com/s/3agqlb5ivkemjft/2016-02-17%20at%209.26%20PM.png)

---

![fit](https://dl.dropboxusercontent.com/s/p575kyrsllhn4xf/2016-02-17%20at%209.27%20PM.png)

---
#Themes

[Bootswatch.com](https://bootswatch.com/)

---
#Asset Pipeline
---
![fit](http://media.railscasts.com/assets/episodes/videos/279-understanding-the-asset-pipeline.mp4)



---
#Demo
* cd into ```wolfiereader```
* ```$ git add . ```
* ```$ git commit -am 'commiting files from in class'```
* ```$ git checkout master```
* ```$ git fetch```
* ```$ git pull ```
* ```$ git checkout  week05_in_class```
* ```$ bundle install --without production```

---
```
$ bundle exec rails g controller static_pages home about opensource
```
Add bootstrap gem

```ruby
gem 'bootstrap-sass',       '3.2.0.0'
```
Then bundle

```$ bundle```

Running just bundle here will take advantage of the setting stored from the first time we used bundler in the .bundle folder

Next create a custom.css.scss file in app/assets/stylesheets

```scss
@import "bootstrap-sprockets";
@import "bootstrap";
```

Next create a bootswatch.css file in app/assets/stylesheets also and copy the code
from bootswatch for this theme.

Next we need to define our layout. There is a great site [http://www.layoutit.com/](http://www.layoutit.com/) which can help you add bootstrap components.

We're going to start by dumping the whole layout in our app/views/layouts/application.html.erb file. Replace the contents of that file with the code below. I'll do it piece by peice but this let's you get the whole file right.

```erb
<!DOCTYPE html>
<html>
<head>
  <title>WolfieReader</title>
  <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true %>
  <%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
  <%= csrf_meta_tags %>
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
        <a href="#">Opensource at WolfieReader</a>
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

Next we can move that navigation section out into a partial, create a file called _navigation.html.erb in the layouts directory.

Copy all of the navigation element out of application.html.erb and move it to _navigation.html.erb.  Then add the following code to application.html.erb

```erb
<%= render 'layouts/navigation' %>
```

Next we'll add a jumbotron element to our home page, open up static_pages/home.html.erb and add replace it's content with the following code:

```html
<div class="jumbotron">
  <h1>Welcome to WolfieReader</h1>
  <p>Since they shut down Google Reader we're going to bring it back like the party never left and with more features. Well, maybe.</p>
  <p><a class="btn btn-primary btn-lg">Learn more</a></p>
</div>
```

Now we need to make our application default to this page when someone access our app, let's add a root route in config/routes.rb

```
root 'static_pages#home'
```

Next, let's add the gems we are using to our opensource page. We'll start off by adding the markup provided by bootswatch and modifying it

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

Now above that we'll add an array of all our gems (this is going to be gross but it's to learn)

```erb
<%
    gems = [{name: 'rails', version: '4.2.2'},
            {name: 'bootstrap-sass', version: '3.2.0.0'},
            {name: 'sass-rails', version: '5.0.2'},
            {name: 'uglifier', version: '2.5.3'},
            {name: 'coffee-rails', version: '4.1.0'},
            {name: 'jquery-rails', version: '4.0.3'},
            {name: 'turbolinks', version: '2.3.0'},
            {name: 'jbuilder', version: '2.2.3'},
            {name: 'sdoc', version: '0.4.0' },
            {name: 'sqlite3', version: '1.3.9'},
            {name: 'byebug', version: '3.4.0'},
            {name: 'web-console', version: '2.0.0.beta3'},
            {name: 'spring', version: '1.1.3'},
            {name: 'minitest-reporters', version: '1.0.5'},
            {name: 'mini_backtrace', version: '0.1.3'},
            {name: 'guard-minitest', version: '2.3.1'},
            {name: 'pg', version: '0.17.1'},
            {name: 'rails_12factor', version: '0.0.2'}]
%>
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
    <% gems.each do |gem| %>
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
        <%= link_to 'Opensource at WolfieReader', opensource_path %>
      </li>
    </ul>
```
