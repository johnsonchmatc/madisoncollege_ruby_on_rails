#Lab 8
* Points 10

##Assignment

The goal of this lab is to **try** and implement devise in a simple Rails
application. You will use a technique called a "Timeboxed Spike". This is a tool
from agile software development.  You will attempt to complete the lab in 60
minutes.  It doesn't matter how far you got, the thing that does matter is your
reflection on the task.

Generate a Todo List with the following commands from a directory of your choosing:

```bash
$ rails _4.2.2_ new todo
$ cd todo
```
Edit the gemfile to use the following gems
[https://gist.github.com/johnsonch/00fc42717713aa0797ccdec71582476d](https://gist.github.com/johnsonch/00fc42717713aa0797ccdec71582476d)

Then ```$ bundle install --without production``` again.

Now scaffold the tasks resource.

```bash
$ bundle exec rails g scaffold Task title:string description:text completed:boolean
$ bundle exec rake db:migrate
```

Initialize this as a git repository.

```bash
$ git init .
$ git add .
$ git commit -am 'Initial commit with scaffolded Task resource'
```

Now investigate for 60 minutes implementing
[Devise](https://github.com/plataformatec/devise) in this application.  Using
authentication to make a user signup and be logged into edit tasks.  No need
at this point to worry about protecting tasks from different users.

After the time is up or if you finish implementing it reflect on the following
questions. Type up your response and turn it in on blackboard under
"Assignments > Lab 8"

* You may work in pairs on this but both need to turn in your own reflection.

###Questions for reflection

1) How did you start working on this spike after the initial application generation?
Did you just read the docs and start? Did you just start hacking away? Did you
look for other tutorials?

2) How far did you get?

3) If you were given the task of implementing Devise in another application,
given what you know now, how much time would you estimate it would take you
implement it?

4) What did you learn from this spike?  Think about how you feel about devise
compared to the hand rolled version from the book?

5) What advantages do you have using something like Devise over hand rolled authentication?

6) What disadvantages do you have using something like Devise over hand rolled authentication?

7) Did you like this approach to learning?  Did it spark curiosity while relieving
the pressure of having to turn in a working application?


##Turn in instructions
* Turn in a text document with answers to the above questions
* Make sure to include you and your partner's names (if you worked with one)
