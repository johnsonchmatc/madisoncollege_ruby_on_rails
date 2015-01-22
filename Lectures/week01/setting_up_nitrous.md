#Ruby on Rails Development
###Setting up Nitrous.io

---
##Signup
###[https://www.nitrous.io/join/xAc6XsTB2BA](https://www.nitrous.io/join/xAc6XsTB2BA)

---
#Create a box

---
![inline fit](https://dl.dropboxusercontent.com/s/54sfk71ufl87mml/2015-01-21%20at%208.38%20PM%202x.png?dl=0)

---
#Let's generate a Rails app

---
##'Installing' Rails
```bash
$ gem install rails -v=4.2.0
```
![inline](https://dl.dropboxusercontent.com/s/6rbuvbn2cibnyl0/2015-01-21%20at%208.44%20PM%202x.png?dl=0)

---
##That new app smell

```bash
$ rails new demo
```
  create  README.rdoc
  create  Rakefile
  create  config.ru
  create  .gitignore
  create  Gemfile
  create  app
  .....
  >= 1.9.2 : nothing to do! Yay!
  run  bundle exec spring binstub --all 
  * bin/rake: spring inserted
  * bin/rails: spring inserted
```
```
$ cd demo
$ bundle exec rails s -b 0.0.0.0
```

---
##View your app in a browser

![inline fit](https://dl.dropboxusercontent.com/s/3csfpr53sw156fd/2015-01-21%20at%209.28%20PM%202x.png?dl=0)


