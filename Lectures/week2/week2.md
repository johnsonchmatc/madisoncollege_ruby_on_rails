#Ruby on Rails Development
##Week 2

----
#Standup

---
#Chapter 1

----
#Up and running

---
##What is RVM?
> RVM is a command-line tool which allows you to easily install, manage, and work with multiple ruby environments from interpreters to sets of gems.

https://rvm.io

---
##Installing RVM
* ``` $ curl -sSL https://get.rvm.io | bash -s stable ```
* Curl is a command line tool for downloading things
* The | lets you take the output of the program on the left and use it as an input for the program on the right.

---
##Installing RVM
* In the future you can run ```$ rvm get stable``` to update your rvm installation

---
##Working with RVM
* ```$ man rvm```
* ```$ rvm install <ruby>```
* ```$ rvm list```
* ```$ rvm use <ruby>```
* ```$ rvm implode```

---
#Ruby Gems

---
##Gem
* ```$ man gem```
* ```$ gem install <gem name> -v=<gem version>```
* ```$ gem list````
* ```$ gem uninstall <gem name>```

---
#Configuration Files
##AKA 'Dot' files

---
##Dot Files
* Start with a ```.``` so they are 'hidden'
* Can be used to configure many applications

---
##.gemrc
```
install: --no-rdoc --no-ri
update:  --no-rdoc --no-ri
```
* This says don't install ri or rdoc when installing a gem
* If you *need* docs locally remove these

---
#```$ rails new```

---
```
$ rails new first_app
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
##Let's explore what files are generated
---
###Instructor opinion
Add the ```--skip-bundle``` flag at the end of your generation command.  It allows your app to be generated and you to make changes before installing gems.

---
#Bundler

---
##Bundler
Makes use of two files:
* Gemfile
* Gemfile.lock

---
##Gemfile
* A list of all your application's required Gems
* Bundler uses this to manage which Gems to load
* [http://bundler.io/v1.2/man/gemfile.5.html](http://bundler.io/v1.2/man/gemfile.5.html)
* Allows you to group gems for what they are used for ie. Test, Development, Production

---
###Gemfile.lock
* A snapshot from when you run bundle install.  
* Not the best idea to modify by hand!

---
##Bundler
* ```$ bundle help```
* ```$ bundle install``` installs gems
* ```$ bundle check``` checks to see if Gemfile is satisfied
* [http://bundler.io/v1.7/commands.html](http://bundler.io/v1.7/commands.html)

---
##Rails server
* ```$ bundle exec rails server```

---
#MVC

---
![fit](https://dl.dropboxusercontent.com/s/gkvmxepquu061xc/2014-09-06%20at%2012.48%20PM.png?dl=0)

<!--Image Credit: Agile Web Development with Rails 4th edition, Pragmatic Bookshelf-->

---
##Model
* Responsible for maintaining the state of the application
* Enforcing business rules

---
##View
* User interface

---
##Controller
* Orchestrate the application (Traffic Cop)

---
#Git

--
##Configuring Git
```
$ git config --global user.name "Your Name"
$ git config --global user.email your.email@example.com
```
* ```~/.giconfig```

---
#Git Demo
```
$ mkdir class_git_demo
$ cd class_git_demo
$ touch file-a.txt
$ git status
$ git add file-a.txt
$ git status
$ git commit -a -m 'our first file'
$ git status
$ git log
$ git checkout -b branch-a
$ touch file-branch-a.txt
$ git status
$ git add .
$ git commit -am 'branch-a file added'
$ git log
$ git checkout master
$ git merge branch-a
$ git branch --contains branch-a
$ git branch -d branch-a
$ git checkout -b branch-b
$ touch file-branch-b.txt
$ git add .
$ git commit -am 'added file-branch-b'
$ vim file-branch-b.txt
$ git status
$ git diff
$ git add .
$ git commit -am 'added Hello World to file-branch-b'
$ git log
$ git checkout master
$ git log
$ git checkout -b branch-c
$ touch file file-branch-c.txt
$ git add .
$ git commit -am 'added file-branch-c.txt'
$ vim file-branch-c.txt
$ git add .
$ git commit -am 'added code to branch-c file'
$ vim file-branch-c.txt
$ vim file-branch-a.txt
$ git status
$ git diff
$ git add .
$ git commit -am 'edits to both a and c'
$ git tree
$ gco master
$ git merge branch-b
$ git merge branch-c
$ git status
$ git tree
$ git tag
$ git status
$ git tag -a project-1 -m 'my code for project 1'
$ git tag
* $ git push --tags
```

---
#Github
* Creating a repository
* Inviting contributors

---
#Deploying

---
#Heroku vs VPS

---
##Heroku
* Managed
* ```git push``` to deploy
* $$

---
##VPS
* Owned by you
* Many deployment options
* $

---
