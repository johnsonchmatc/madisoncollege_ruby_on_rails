#Ruby on Rails Development
##Week 13

---
#Adding pagination and Ajax

---
#Demo
* cd into ```wolfies_list```

```
$ git add . 
$ git commit -am 'commiting files from in class'
$ git checkout master 
$ git fetch
$ git pull origin master
$ git checkout week13_start
$ bundle install --path=vendor/bundle
 * may need to update rails version ```$ bundle update rails```
$ bundle exec rake db:migrate
## if you get a database error
$ bundle exec rake db:drop
$ bundle exec rake db:create
$ bundle exec rake db:migrate
```

---
#Will Paginate
* [https://github.com/mislav/will_paginate](https://github.com/mislav/will_paginate)

* Add the gem ```gem 'will_paginate', '~> 3.0.6'```

* change the controller
```
@ads = Ad.all.paginate(:page => params[:page])
```
* Set the per page limit on the model
```
self.per_page = 10
```
* add the pagination helper to the view
```
<%= will_paginate @ads %>
````



#Endless Scrolling

* Add support for handlebars to application layout
```
<script src="http://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.0/handlebars.min.js"> </script>

```

* Create a pagination.js file in your assets/javascripts folder
```
(function($) {
  var currentPage = 0;

  function loadData(data) {
    $('#ads').append(Handlebars.compile("{{#ads}} \
      <tr class='ad'> \
        <td><a href='/ads/{{id}}'>{{title}}</a></td> \
        <td><a href='/ads/{{id}}'>{{description}}</a></td> \
        <td><a href='/ads/{{id}}'>{{price}}</a></td> \
        </tr>{{/ads}}")({ ads: data }));
    if (data.length == 0) $('#next_page_spinner').hide();
  }

  function nextPageWithJSON() {
    currentPage += 1;
    var newURL = '/ads.json?page=' + currentPage;

    var splitHref = document.URL.split('?');
    var parameters = splitHref[1];
    if (parameters) {
      parameters = parameters.replace(/[?&]page=[^&]*/, '');
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

* create an assets initializer to ignore pre-compiling
```
Rails.application.config.assets.precompile += %w( pagination.js )
```

* Now adjust the index
```
<h1>Listing ads</h1>
<% if logged_in? %>
<br>
<%= link_to 'New Ad', new_user_ad_path(current_user) %>
<% end %>

<table class="table table-striped table-hover">
  <thead>
    <tr>
      <th>Title</th>
      <th>Description</th>
      <th>Price</th>
    </tr>
  </thead>


  <tbody id="ads">
  </tbody>
</table>

  <img src='http://www.fostersystems.com/ccdata/images/spinner.gif' id='next_page_spinner' />

  <%= javascript_include_tag 'pagination' %>

```

# Weather API
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
        <li>Current {{main.temp}}&degF</li>
       </ul>
    {{/weather}}")(weather: data)
  return

@populateWeather = (data) ->
  sanitizedData = {
    main: {
      temp: convertKToF(data.main.temp),
      wind: convertBearing(data.wind.deg)
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
      console.log data
      return
```

* Add weather to show page
```
<div class="col-md-2" id="weather-data">
  <h3>Weather</h3>
  <%= image_tag("http://www.fostersystems.com/ccdata/images/spinner.gif", :id => 'next_page_spinner') %>
</div>

<%= javascript_include_tag 'weather' %>

<script>
  var url =<%=raw "'http://api.openweathermap.org/data/2.5/weather?lat=#{@ad.latitude}&lon=#{@ad.longitude};'" %>
  window.getWeather(url);
</script>
```
