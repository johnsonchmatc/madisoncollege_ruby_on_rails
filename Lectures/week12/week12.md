#Ruby on Rails Development
##Week 12

---
#Finding an implementing Gems

---
#Demo
* cd into ```wolfies_list```

```
$ git add . 
$ git commit -am 'commiting files from in class'
$ git checkout master 
$ git fetch
$ git pull origin master
$ git checkout week12_start
$ bundle install --path=vendor/bundle
 * may need to update rails version ```$ bundle update rails```
$ bundle exec rake db:migrate
## if you get a database error
$ bundle exec rake db:drop
$ bundle exec rake db:create
$ bundle exec rake db:migrate

```

---
#Adding fake data
* [Faker Gem](https://github.com/stympy/faker)
* [Generate Rake Task](https://gist.github.com/johnsonch/37fdf41b28496586e522)

---
#Adding google maps
* [Geocoder Gem](https://github.com/alexreisner/geocoder)
* [Google Maps Docs](https://developers.google.com/maps/tutorials/fundamentals/adding-a-google-map)
* [Show page changes](https://gist.github.com/johnsonch/243f4732505fdb25341a)
