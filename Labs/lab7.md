# Lab 7
* Points 10

## Assignment
Create a simple blog. The goal of this is not really tied to signing a user in
and out but is forcing you to learn more about scaffolding to get ready for mentor
night and your application.

The application should have the following:
* A posts model which contains a title, article and belongs to an author. (use rails scaffoldng for this)
    * A post should require that it has a title, article and author set.
* An authors model which contains the author's name and email address (use rails scaffoldng for this)
* The root path should show all posts from newest to oldest
* When creating a post the author should be able to be selected from a dropdown
* You may work in pairs on this

### Notes:
* Use validations to validate posts
* Use associations to tie the post and author together.
* Use [collection_select](http://apidock.com/rails/ActionView/Helpers/FormOptionsHelper/collection_select) in your posts form to create a dropdown of authors rather than needing to know their id.
  * We used just the select form helper in lecture on week 2.  That is an alternative that is acceptable.
  * I would really like you to use collection_select and learn how to implement from the documentation.
  * I know the documentation can be hard to understand, being forced to use it in class is a way to learn it in a safe environment
* Labs 2 will help you look at scaffolding again


## Turn in instructions
* Show your instructor the completed assignment
* After you have shown your instructor you may delete this from Heroku/Github/Bitbucket if you deployed it and want to remove it
