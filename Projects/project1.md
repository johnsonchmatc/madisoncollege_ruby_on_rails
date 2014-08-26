#Project 1
This project is our first step in applying what we are learning from the RailsTutorial and inclass lectures. We'll create a new application, a github repository for it and scaffold a couple resources.  

## Done whens
* Done when you have created a new application 
* Done when you have created a github repository for the project 
* Done when you have scaffolded Category with a ```name``` attribute that is a string
* Done when you have scaffolded Task that has a ```description``` attribute that is a text and a ```category_id``` that is an integer 
* Done when you have tests that validate the relationships between categories and tasks.
 
##Grading Criteria
* Working application (2.5pts)
* Code pushed to github (2.5pts)
* Passing tests (5pts)
* Meets done whens (10pts) 

##Submission directions
* Push code to github
* Turn in a document in BlackBoard under Assignments with the following:
  * Name
  * Date
  * Assignment github url
  * Tag for submisison 
  * Heroku url

##Directions

1. Login to your Nitrous.io account and start up your box.
1. Open the IDE
1. In the console section create a new rails project with ```$ rails new taskinator --skip-test-unit --skip-bundle```
1. Modify the gemfile to add rspec and the specific version of rails we have been using
```
gem 'rails', '4.0.8'
gem 'rspec-rails', '2.13.1'
```

1. Change directories into your application, and install related gems ```$ bundle install --without production --path vendor/bundle```
1. Go to github and create a repository for your application.
1. Follow their directions on how to add that remote respository to your codebase.
1. Next scaffold the Category resource ```$ bundle exec rails generate scaffold Category name:string```
1. Then scaffold the Task resource ```$ bundle exec rails generate scaffold Task description:string cateogry_id:integer```
1. After we have both resources scaffolded we have to add the activer record relationship to our models. A category can have many tasks and a task belongs to a category.  Here is what our two models should end up looking like.
```
class Category < ActiveRecord::Base
  has_many :tasks
end
```
```
class Task < ActiveRecord::Base
  belongs_to :category
end
```
1. To get our models looking like that we'll need to use tests to guide our development.
1. Test your application using the build in server, when you are satisfied it works, commit your code and push it to get hub. Then deploy it to Heroku.