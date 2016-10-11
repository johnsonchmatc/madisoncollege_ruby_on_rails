#Lab 7
* Points 10

##Assignment
Create a simple blog.

The application should have the following:
* A posts model which contains a title, article and belongs to an author. (use rails scaffoldng for this)
    * A post should require that it has a title, article and author set.
* An authors model which contains the author's name and email address (use rails scaffoldng for this)
* The root path should show all posts from newest to oldest
* When creating a post the author should be able to be selected from a dropdown
* You may work in pairs on this

###Notes:
* Use validations to validate posts
* Use associations to tie the post and author together.
* Use [collection_select](http://apidock.com/rails/ActionView/Helpers/FormOptionsHelper/collection_select) in your posts form to create a dropdown of authors rather than needing to know their id.


##Turn in instructions
* Show your instructor the completed assignment
* After you have shown your instructor you may delete this from Heroku/Github if you want
