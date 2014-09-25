#Ruby on Rails Development
##Week 4
---
#Standup

---
#Chapters 4 and 5

---
#Objects

---
##Objects
* Has attributes, or data, and associated methods (procedures) 
* Everything in ruby is an object and can be sent messages

---
##Objects
```
bank = BankAccount.new(:balance => 40)
bank.balance #=> 40
bank.withdraw(10)
bank.deposit(20)
bank.balance #=> 50
```

---
#Methods

---
##Methods
* In Ruby methods are actually messages
* We define the messages that our objects can respond to, those are our methods
```
"Badgers".send :length
```
* This sends the length message to the object
```
"Badgers".length
```
* The dot notation provides an interface similar to other OOP languages

---
#Classes

---
##Classes
* 'blueprint' for creating objects

```
class BankAccount

end
```
* Starts uppercase and then SnakeCasess the rest of the class name

---
##Classes
* We can use a class to create an instance of an object
```
account = BankAccount.new
```
* Each instance is unique
* Each has it's own spot in memory
* Inherits behavior from basic object
```
account.to_s #=> #<BankAccount:0x007fb66b04c1c0>
```

---
##Classes
* We can add methods to classes, even override existing ones
```
class BankAccount
  def to_s
    "$0.00"
  end
end
```
* Now we can pass the ```to_s``` message to our account object which we have defined a method to respond to
```
account.to_s #=> "$0.00
```

---
##Classes
* Attributes can be created on a class
* Just a variable 'inside' the object that holds data
```
class BankAccount
  attr_accesor :balance
  .
  .
  .
end
```

---
#Pragmatic Video

---
#Data Structures 

---
##Data Structures
* integer
* string
* array
* hash

---
##Integer

---
##String

---
##Array

---
##Hash

```
> a = {key: 'value', 'other_key' => 'other_value'} #=> {:key=>"value", "other_key"=>"other_value"}
> a #=> {:key=>"value", "other_key"=>"other_value"}
> a[:key] #=> "value"
> a['other_key'] #=> "other_value"
> a.keys #=> [:key, "other_key"]
> a.keys.each { |x| puts a[x] }
value
other_value
 => [:key, "other_key"]
```


---
#Asset Pipeline

---
[http://railscasts.com/episodes/279-understanding-the-asset-pipeline](http://railscasts.com/episodes/279-understanding-the-asset-pipeline)

---
