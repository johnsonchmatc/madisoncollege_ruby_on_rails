## Rake task to generate stories and turns

```ruby
desc "generates fake stories"
task stories: :environment do
  story_text =<<-EOF
    {{adjective}} Macdonald had a {{noun}}, E-I-E-I-O
    and on that {{noun}} he had an {{adjective}} {{verb}}, E-I-E-I-O
    EOF
  story = Story.create(content: story_text)
  50.times do
    Turn.create(story: story,
                noun: Faker::Hacker.noun,
                verb: Faker::Hacker.verb,
                adverb: Faker::Hacker.ingverb,
                adjective: Faker::Hacker.adjective)
  end
end
```


## WillPaginate

```ruby
gem 'will_paginate'
```

* Then we'll need to install the gem

```bash
$ bundle install
```

* Adjust the index action you want to paginate

```ruby
  def index
    @stories = Turn.all.paginate(page: params[:page],
                                 per_page: 10)
  end
```

* Then add the page picker helper to your index page

```erb
<div class="row">
  <div class="col-md-12">
    <%= will_paginate @stories %>
  </div>
</div>
```

#Endless Scrolling

```
gem 'jquery-rails'
```

* The turns index will need to paginate so the javascript can get a few at a time
```
  def index
    @turns = Turn.all.paginate(page: params[:page],
                              per_page: 10)
  end
```

* Add support for handlebars to application layout

```html
<script src="http://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.0/handlebars.min.js"> </script>
```

* Add jquery to our application.js

```
//= require jquery
```

* Modify our turns/index.json.jbuilder to support our needed information

```ruby
json.array!(@turns) do |turn|
  json.story turn.generate_story
  json.author 'Someone Famous'
end
```

* Create a pagination.js file in your assets/javascripts folder

```js
(function($) {
  var currentPage = 0;

  function loadData(data) {
    $('#stories').append(Handlebars.compile("{{#stories}} \
        <blockquote> \
          <p>{{story}}</p> \
          <small>{{author}}</small> \
        </blockquote> \
    {{/stories}}")({ stories: data }));
    if (data.length == 0) $('#next_page_spinner').hide();
  }

  function nextPageWithJSON() {
    currentPage += 1;
    var newURL = '/turns.json?page=' + currentPage;

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

    var threshold = 500;
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

* create an assets initializer config/initializers/asset.rb

```ruby
Rails.application.config.assets.precompile += %w( pagination.js )
```

* Now adjust the static home page

```erb
<div id="stories">
</div>

<img src='http://www.fostersystems.com/ccdata/images/spinner.gif' id='next_page_spinner' />



<%= javascript_include_tag 'pagination' %>
```

```
gem 'rest-client'

https://opendata.arcgis.com/datasets/5815e94a364c408ea51d09c81329e57b_25.geojson

def madison_data
  response = RestClient.get 'https://opendata.arcgis.com/datasets/5815e94a364c408ea51d09c81329e57b_25.geojson'
  parsed = JSON.parse(response)
  @stop_collection = []
  10.times.with_index do |i|
   @stop_collection << parsed["features"][i]["properties"]
  end
end

<table>
  <tr>
    <th>Stop</th>
    <th>Route</th>
    <th>Weather</th>
  </tr>
<% @stop_collection.each do |stop| %>
  <tr>
    <td><%=stop["StopID"] %></td>
    <td><%=stop["Route"] %></td>
    <td><%=stop["StopID"] %></td>
  </tr>
<% end %>
</table>

```

If time add http://openweathermap.org/api
