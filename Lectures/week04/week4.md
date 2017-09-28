footer:@johnsonch :: Chris Johnson :: Ruby on Rails Development - Week 4
autoscale: true

#Ruby on Rails Development
##Week 4

---
# Chapter 4

---
# What does a Ruby script look like?

---
```ruby
class Bus
  def wheels
    puts "round and round"
  end

  def people
    puts "up and down"
  end
end
```

```ruby
bus = Bus.new
bus.wheels #=> "round and round"
bus.people #=> "up and down"
```

---
# Comments

* They start with `#` and should have a space between the `#` and the first word.
* Comments should never describe *what* and only should describe *why*
  * If you need to write a what comment your code is too complicated and doing too much
  * Writing a why comment is needed to spread triable knowledge

---
# Objects

---
## Objects
* Has attributes, or data, and associated methods (procedures)
* Everything in ruby is an object and can be sent messages

---
## Objects

```ruby
bank = BankAccount.new(:balance => 40) ## Old pre 2.0
bank = BankAccount.new(balance: 40)  ## New > 2.0

bank.withdraw(10)
bank.deposit(20)
bank.balance #=> 50
```

---
# Methods

---
## Methods
* In Ruby methods are actually messages
* We define the messages that our objects can respond to, those are our methods

```ruby
"Badgers".send :length
```
* This sends the length message to the object

```ruby
"Badgers".length
```

* The dot notation provides an interface similar to other OOP languages

---
# Classes

---
## Classes
* 'blueprint' for creating objects

```ruby
class BankAccount

end
```

* Starts uppercase and then CamelCase the rest of the class name

---
## Classes
* We can use a class to create an instance of an object

```ruby
account = BankAccount.new
```

* Each instance is unique
* Each has it's own spot in memory
* Inherits behavior from basic object

```ruby
account.to_s #=> #<BankAccount:0x007fb66b04c1c0>
```

---
## Classes
* We can add methods to classes, even override existing ones

```ruby
class BankAccount
  def to_s
    "$0.00"
  end
end
```

---
## Classes

* Now we can pass the ```to_s``` message to our account object which we have defined a method to respond to

```ruby
account.to_s #=> "$0.00"
```

---
## Classes
* Attributes can be created on a class
* Just a variable 'inside' the object that holds data

```ruby
class BankAccount
  attr_accesor :balance
  .
  .
  .
end
```

# Pragmatic Video

---
# Data Types

---
## Data types
* booleans
* symbols
* numbers
* strings
* hashs
* arrays

---
## Booleans

--
## Symbols

---
## Numbers
* Fixnum
* Bignum

---
## Strings
* Concatination `'foo' + ' bar' #=> 'foo bar'`
* interpolation `"#{Time.now} was a great day" #=> "2017-09-17 20:53:03 -0500 was a great day"`
* Single vs Double quotes

---
## Hashs

```ruby
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
## Arrays

```ruby
> a = ["one", 2, "three", :four, "five".length]
 => ["one", 2, "three", :four, 4]
> a.last
 => 4
> a << "pizza"
 => ["one", 2, "three", :four, 4, "pizza"]
> a << {pizza: "cheese"}
 => ["one", 2, "three", :four, 4, "pizza", {:pizza=>"cheese"}]
> a.each do |value|
>     puts value
>   end
one
2
three
four
4
pizza
{:pizza=>"cheese"}
 => ["one", 2, "three", :four, 4, "pizza", {:pizza=>"cheese"}]
```

---
# Blocks
* Represented by `{` somecode `}` or `do` and `end`
* Simply means that it is code which can take code as an argument
* Typically itterators (blocks) take code to execute on each itteration

```
> a = ["one", 2, "three", :four, "five".length]
> a.each { |i| puts i }

one
2
three
four
4
```

^ http://rubylearning.com/satishtalim/ruby_blocks.html

---
##Next Week
* Chapter 3 and 5
* Sketch some wireframes for your app, they'll be due in week 6.
    * After next week's class you'll have all the knowledge on how to generate static pages and can start on that before showing your wireframes
    * If you want to start working ahead scan/take picturs of your wireframes and email them to me.  I'll look while traveling.

---
