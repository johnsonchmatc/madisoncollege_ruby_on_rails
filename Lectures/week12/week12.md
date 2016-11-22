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
gem 'will_paginate'
```

* Then we'll need to install the gem

```bash
$ bundle install
```

* Simply adjust the index action you want to paginate

```ruby
  def index
    @parcels = Parcel.all.paginate(:page => params[:page], :per_page => 10)
  end
```

* Then add the page picker helper to your index page

```erb
<div class="row">
  <div class="col-md-12">
    <%= will_paginate @parcels %>
  </div>
</div>
```

#Endless Scrolling

* Add support for handlebars to application layout
```html
<script src="http://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.0/handlebars.min.js"> </script>
```

* Modify our index.json.jbuilder to support our needed information

```ruby
json.array!(@parcels) do |parcel|
  # Extract from the objec the fields we don't need to modify
  json.extract! parcel, :id, :address, :created_at, :updated_at
  # Use our helper method to modify the values so that we return the same if the
  # user has javascript or not
  json.current_year_value display_us_dollar(parcel.current_year_value)  
  json.previous_year_value display_us_dollar(parcel.previous_year_value)  
  json.total_taxes display_us_dollar(parcel.total_taxes)  

  json.url parcel_url(parcel)
end
```

* Create a pagination.js file in your assets/javascripts folder

```js
(function($) {
  var currentPage = 0;

  function loadData(data) {
    $('#parcels').append(Handlebars.compile("{{#parcels}} \
      <tr> \
        <td>{{address}}</td> \
        <td>{{current_year_value}}</td> \
        <td>{{previous_year_value}}</td> \
        <td>{{total_taxes}}</td> \
        <td><a href='{{url}}'>View Parcel</a></td> \
      </tr> \
    {{/parcels}}")({ parcels: data }));
    if (data.length == 0) $('#next_page_spinner').hide();
  }

  function nextPageWithJSON() {
    currentPage += 1;
    var newURL = '/parcels.json?page=' + currentPage;

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

* create an assets initializer confid.initializers/asset.rb

```ruby
Rails.application.config.assets.precompile += %w( pagination.js )
```

* Now adjust the index

```erb
<div class="row">
  <div class="col-lg-12">
    <p id="notice"><%= notice %></p>
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
  <h1>Parcels</h1>
  </div>
</div>

<div class="row">
  <div class="col-lg-12">
    <table class="table table-striped table-hover">
      <thead>
        <tr>
          <th>Address</th>
          <th>Current year value</th>
          <th>Previous year value</th>
          <th>Total taxes</th>
          <th colspan="3"></th>
        </tr>
      </thead>

      <tbody id="parcels">
      </tbody>
    </table>
  </div>
</div>

<img src='http://www.fostersystems.com/ccdata/images/spinner.gif' id='next_page_spinner' />

<br>

<%= link_to 'New Parcel', new_parcel_path %>

<%= javascript_include_tag 'pagination' %>
```

Next we can add some more information to our parcels show page.  Let's start with
showing the weather

# Weather API
* Go to [http://openweathermap.org/](http://openweathermap.org/) and sign up for a free account

![](http://files.johnsonch.com/Members_1DE3E330.png)

* Get your API key and add it to your application.yml (first copy application.yml.example to application.yml)

```yaml
  weather_api: <YOUR KEY HERE>
```

* Add a weather.js.coffee

```
@convertKToF = (k) ->
  Math.round((k - 273.15)* 1.8000 + 32.00)

@convertBearing = (bearing) ->
  points = ["N ","NE","E","SE","S","SW","W","NW"]
  seg_size = 360 / points.length
  points[Math.floor(((parseInt(bearing) + (seg_size / 2)) % 360) / seg_size)]

@renderWeather = (data) ->
  weatherPanel = $("#weather-data")
  weatherPanel.html ""
  weatherPanel.append Handlebars.compile(
    "{{#weather}}
      <h3>Weather</h3>
 Temperature:
      <ul>
        <li>Current Temp {{main.temp}}&degF</li>
        <li>Wind: {{main.wind_speed}} mph {{main.wind_direction}}</li>
       </ul>
    {{/weather}}")(weather: data)
  return

@renderError = () ->
  weatherPanel = $("#weather-data")
  weatherPanel.html ""
  weatherPanel.append Handlebars.compile(
    "<h3>Error Retrieving Weather</h3>")
  return

@populateWeather = (data) ->
  if data.cod == "404"
    renderError()
  else
    sanitizedData = {
      main: {
        temp: convertKToF(data.main.temp),
        wind_direction: convertBearing(data.wind.deg),
        wind_speed: data.wind.speed
      }
    }
    renderWeather(sanitizedData)

@getWeather = (url) ->
  $.ajax
    method: "get"
    url: url
    success: (data) ->
      populateWeather(data)
      return
    error: (data) ->
      console.log "error", data
      renderError()
      return
```

* Update assets initializer

```
Rails.application.config.assets.precompile += %w( pagination.js weather.js )
```

* Add weather to show page
```
<!-- inside the right column -->
  <div class="row">
    <div class="col-lg-12" id="weather-data">
      <h3>Weather</h3>
      <%= image_tag("http://www.fostersystems.com/ccdata/images/spinner.gif", :id => 'next_page_spinner') %>
    </div>
  </div>

<!-- at the bottom of the page -->
<%= javascript_include_tag 'weather' %>

<script>
  <% if @parcel.latitude && @parcel.longitude %>
  var url =<%=raw "'http://api.openweathermap.org/data/2.5/weather?lat=#{@parcel.latitude}&lon=#{@parcel.longitude}&appid=#{ENV['weather_api']}'" %>
  <% else %>
  var url =<%=raw "'http://api.openweathermap.org/data/2.5/weather?q=madison,wi,us&appid=#{ENV['weather_api']}'" %>
  <% end %>
  window.getWeather(url);
</script>
```

