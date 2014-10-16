#Ruby on Rails Development
##Week 5
---
#Standup

---
#Chapter 6 
##Modeling Users

---
#Models
##Active Record

---
##Active Record

* Coined by Martin Fowler as:

> An object that wraps a row in a database table or view, encapsulates the database access, and adds domain logic on that data.

* Is an ORM

---
##Perks of Active Record

* Represent models and their data.
* Represent associations between these models.
* Represent inheritance hierarchies through related models.
* Validate models before they get persisted to the database.
* Perform database operations in an object-oriented fashion.

---
##Conventions
* Naming
  * *Database Table* - Plural with underscores separating words (e.g., book\_clubs).
  * *Model Class* - Singular with the first letter of each word capitalized (e.g., BookClub).

---
##Conventions
* Schema
  * *Foreign keys* - These fields should be named following the pattern singularized\_table\_name\_id (e.g., item\_id, order\_id). These are the fields that Active Record will look for when you create associations between your models.

---
##Conventions
* Schema
  * *Primary keys* - By default, Active Record will use an integer column named id as the table's primary key. When using Active Record Migrations to create your tables, this column will be automatically created.

---
##Conventions
* Schema - optional
  * *created\_at* - Automatically gets set to the current date and time when the record is first created.
  * *updated\_at* - Automatically gets set to the current date and time whenever the record is updated.

---
##Conventions
* Schema - optional
  * *lock\_version* - Adds optimistic locking to a model.
  * *type* - Specifies that the model uses Single Table Inheritance.

---
##Conventions
* Schema - optional
  * *(association\_name)\_type* - Stores the type for polymorphic associations.
  * *(table\_name)\_count* - Used to cache the number of belonging objects on associations. For example, a comments\_count column in a Post class that has many instances of Comment will cache the number of existent comments for each post.

---
#Validations
##More discussion?

---
##Selecting
* ```users = User.all```
* ```user = User.first```
* ```david = User.find_by(:all, name: 'David')```
* ```users = User.where(name: 'David', occupation: 'Code Artist').order('created_at DESC')```
* ```users = User.where("age >= ? and birth_month = ?", 21, 'March')```

---
#Callbacks
##Don't use them
###Unless you really have to

---
##Callbacks
* save
* valid
* before_validation
* validate
* after_validation

---
##Callbacks
* before_save
* before_create
* create
* after_create
* after_save
* after_commit

---
##Migrations
```
class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.string :title
      t.text :description
      t.references :publication_type
      t.integer :publisher_id
      t.string :publisher_type
      t.boolean :single_issue
 
      t.timestamps
    end
    add_index :publications, :publication_type_id
  end
end
```

---
