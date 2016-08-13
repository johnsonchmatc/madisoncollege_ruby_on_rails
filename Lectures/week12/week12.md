footer:@johnsonch :: Chris Johnson :: Ruby on Rails Development :: Week 11
autoscale: true

#Ruby on Rails Development
##Week 12

* https://codecaster.io room: johnsonch

---
#Demo
###If you need to re-clone
* ```$ git clone git@bitbucket.org:johnsonch/wolfiereader.git```
* ```$ cd wolfiereader```
* ```$ bundle install --without production```

###If you have it already cloned
* cd into ```wolfiereader```
* ```$ git add . ```
* ```$ git commit -am 'commiting files from in class'```
* ```$ git checkout master```
* ```$ git fetch```
* ```$ git pull ```
* ```$ git checkout week12_start```
* ```$ rm -f db/*.sqlite3```
* ```$ bundle```
* ```$ bundle exec rake db:migrate```
* ```$ bundle exec rake fake:all_data```

---
##Style Feeds Index

Let's make our feeds index look a bit better

```erb
<p id="notice"><%= notice %></p>

<h1>My Feeds</h1>

<p>
<%= link_to 'New Feed', new_user_feed_path %>
</p>

<% @feeds.each do |feed| %>
  <div class="well well-sm">
    <div class="row">
      <span class="col-sm-10 feed-name">
        <%= link_to feed.name, user_feed_path(id: feed) %>
      </span>
      <span class="col-sm-2">
        <%= link_to('Remove', user_feed_path(id: feed), method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-danger") %>
      </span>
    </div>
  </div>
<% end %>
```


## WillPaginate

```ruby
gem 'will_paginate', '~> 3.0.6'
```

* Then we'll need to install the gem

```bash
$ bundle install
```

* Simply adjust the index action you want to paginate

```ruby
  def index
    @feeds = @user.feeds.paginate(:page => params[:page], :per_page => 10)
  end
```

* Then add the page picker helper to your index page

```erb
<div class="row">
  <div class="col-md-12">
    <%= will_paginate @feeds %>
  </div>
</div>
```

#Endless Scrolling

* Add support for handlebars to application layout
```
<script src="http://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.0/handlebars.min.js"> </script>
```

* Modify our index.json.jbuilder to support our needed information

```ruby
json.array!(@feeds) do |feed|
  # we don't need the feed's url in this data, we'll keep it small this way
  json.extract! feed, :id, :name
  # over the stock generate schema we need to pass in our user instance variable
  # so we can generate the proper url.
  json.url user_feed_url(@user, feed, format: :json)
end
```

* Create a pagination.js file in your assets/javascripts folder

```
(function($) {
  var currentPage = 0;

  function loadData(data) {
    $('#feeds').append(Handlebars.compile("{{#feeds}} \
      <div class='well well-sm'> \
        <div class='row'> \
          <span class='col-sm-10 feed-name'><a href='{{url}}'>{{name}}</a></span> \
          <span class='col-sm-2'>  \
            <a data-confirm='Are you sure?' class='btn btn-danger' rel='nofollow' data-method='delete' href='{{url}}'>Remove</a> \
          </span> \
        </div> \
      </div> \
    {{/feeds}}")({ feeds: data }));
    if (data.length == 0) $('#next_page_spinner').hide();
  }

  function nextPageWithJSON() {
    currentPage += 1;
    var newURL = '/users/64/feeds.json?page=' + currentPage;

    var splitHref = document.URL.split('?');
    var parameters = splitHref[1];
    if (parameters) {
      parameters = parameters.replace(/[?&]page=[^&]*/, "");
      newURL += '&' + parameters;
    }
    return newURL;
  }

  var loadingPage = 0;
  function getNextPage() {
    if (loadingPage != 0) return;

    loadingPage++;
    $.getJSON(nextPageWithJSON(), {}, updateContent).
      complete(function() { loadingPage-- });
  }

  function updateContent(response) {
    loadData(response);
  }

  function readyForNextPage() {
    if (!$('#next_page_spinner').is(':visible')) return;

    var threshold = 200;
    var bottomPosition = $(window).scrollTop() + $(window).height();
    var distanceFromBottom = $(document).height() - bottomPosition;

    return distanceFromBottom <= threshold;
  }

  function observeScroll(event) {
    if (readyForNextPage()) getNextPage();
  }

  $(document).scroll(observeScroll);

  getNextPage();
})(jQuery);
```

* create an assets initializer

```
Rails.application.config.assets.precompile += %w( pagination.js )
```

* Now adjust the index

```
<p id="notice"><%= notice %></p>

<h1>My Feeds</h1>

<p>
<%= link_to 'New Feed', new_user_feed_path %>
</p>

<div id="feeds">
</div>

<img src='http://www.fostersystems.com/ccdata/images/spinner.gif' id='next_page_spinner' />
<script>
  var userId = <%= @user.id %>;
</script>
<%= javascript_include_tag 'pagination' %>
```

