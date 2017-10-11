# Ruby on Rails Development
## Chapter 6
### Week 6

---
# Agenda

* Clean up remainder of UI from last week
* Add User model (following book example)
 * Note about devise
* Link User to Turn
* Convert Story to Active Model

---
#Ruby and Rails API Docs

* [http://api.rubyonrails.org/](http://api.rubyonrails.org/)
* [https://ruby-doc.org/](https://ruby-doc.org/)

---
#Active Record Relationships

---
##Active Record Relationships
* belongs_to
* has_many
* has_many_through

---
##Validations
* Rules to prevent invalid data from being saved
* Can be conditional

```ruby
class Call < ActiveRecord::Base
  validates :location_id, presence: true, unless: :location_other
  validates :location_other, presence: true, unless: :location_id
end
```

* Provides error messages back to the controller
* [http://guides.rubyonrails.org/active_record_validations.html#validation-helpers](http://guides.rubyonrails.org/active_record_validations.html#validation-helpers)


---
