#Lab 1
* Points 10
* Date due: 09/10/2015 at 11:55pm CST

##Assignment
* Read and follow Chapter 1 examples from the Rails Tutorial book.
* Complete the exercises for Chapter 1 as well.


* If you get an error about rails versions do a ```$ gem install rails -v=4.2.0```

Initialize it as a new git repository ```$ git init .```

Add and commit all the files 
```
$ git add .
$ git commit -am 'intial commit'
```

Next add 2 methods to the application controller, one called ```hello``` and another called ```good_bye``. Then add routes to both of the actions. Follow section 1.3.4 in the RailsTutorial book.

An example additional route would look similar to this:

```
get '/good_bye', to: 'application#good_bye'
```

You should now see 2 changed files after adding the methods and routes. Use the following command to stage both files and add a commit message.

```
$ git commit -a -m 'commiting new routes for lab 1"
```

Create a Github.com public repository for this under your account called matc-rails-lab01, and follow their instructions on how to push it up.

Create a Heroku Application (follow book example)

When you are satisfied with your application and it works add a tag 

```
$ git tag -a to-grade-lab01 -m '<insert a commit message>'
```

View that your tag exists: ``` $ git tag``` 

Then push your repository to Github ```$ git push```

Then push your tag upto Github ```$ git push --tags ```

After your code is pushed to github follow section 1.5 from the RailsTutorial book to deploy this application do Heroku. You should be able to see the URLs /hello and /good_bye.


##Turn in instructions
* on Blackboard under Labs find Lab1 submit a word/text document with the following information:
  * Name
  * Date
  * Github Url of the project (can be a public repository)
  * Tag to grade
  * Heroku URL of deployed project
  
###Notes:
* If you make your github repository for labs private, you'll need to add "johnsonch" as a contributor to the repository so I can access it.
* After you have received a grade you may delete this from Heroku/Github if you want
