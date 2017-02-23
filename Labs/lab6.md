#Lab 6
* Points 10

##Assignment

The goal of this lab is to learn how to add validations to a model.  I have made
it easier for your to work on this by creating a series of failing tests. You won't
need to do anything in the browser so long as you can make the tests pass (without modifying the tests).

* Find a directory to work, and clone the Lab06 repository with the following command:

```
$ git clone https://github.com/johnsonchmatc/lab06_start.git
```

* Change in to the ```lab06_start``` directory and run ```$ bundle install --without production```
* Then run ```$ bundle exec rails db:migrate``` followed by ```$ bundle exec rails test```
* Now make the tests pass by adding validations! You will need the following validations:
    * ```first_name``` must exist and have a length longer than 1
    * ```last_name``` must exist and have a length longer than 1
    * ```height_feet``` must be an integer and must be a non negative number not to exceed 11
    * ```height_inches``` must be an integer and must be a non negative number not to exceed 11 and not to be less than 1, except if it is nil
    * ```email``` must be unique on create
* You may work in pairs on this

##Turn in instructions
* Show your instructor the completed assignment
* After you have shown your instructor you may delete this from Heroku/Github if you want
