#Ruby on Rails Development
##Week 4

---
#Chapters 3,4,5

---
#Generate App

- Scaffold based on wire frames

```bash
$ rails g scaffold Project title:string description:text start_date:date end_date:date client_id:integer

$ rails g scaffold Client name:string contact_name:string phone:string contact_email:string street:string city:string state:string postal_code:string

$ rails g scaffold Task employee_name:string  time:integer date:date description:text
```

---
#Adding relationships

---
##Client has many Projects
* Test first

```ruby
require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  test "project relationship" do
    assert_respond_to( Client.new, :projects)
  end
end
```

* Make it pass

```ruby
class Client < ActiveRecord::Base
  has_many :projects
end
```

---
##Project belongs to Client
* Test first

```ruby
require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "client relationship" do
    assert_respond_to( Project.new, :client)
  end
end
```

* Make it pass

```ruby
class Project < ActiveRecord::Base
  belongs_to :client
end
```

---
##Task belongs to Project
* Test first

```ruby
require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test "project relationship" do
    assert_respond_to(Task.new, :project)
  end
end
```

* Make it pass

```ruby
class Task < ActiveRecord::Base
  belongs_to :project
end
```

---
#Styling

---
#Asset pipeline

---
![full](http://media.railscasts.com/assets/episodes/videos/279-understanding-the-asset-pipeline.mp4)

---
![full](http://media.railscasts.com/assets/subscriptions/ywfAHv9Jp7nypbOyVi4ISg/videos/341-asset-pipeline-in-production.mp4)

---
#Getting Styles
* [http://startbootstrap.com/](http://startbootstrap.com/)
* [http://bootswatch.com/](http://bootswatch.com/)
