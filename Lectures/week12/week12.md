footer:@johnsonch :: Chris Johnson :: Ruby on Rails Development :: Week 11
autoscale: true

#Ruby on Rails Development
##Week 12

* https://codecaster.io room: johnsonch

---
#Demo
* cd into ```wolfie_books```
* ```$ git add . ```
* ```$ git commit -am 'commiting files from in class'```
* ```$ git checkout master```
* ```$ git fetch```
* ```$ git pull ```
* ```$ git checkout week12_start```
* ```$ rm -f db/*.sqlite3```
* ```$ bundle```
* ```$ bundle exec rake db:migrate```
* ```$ bundle exec rake test``` We have a  couple failing tests from last week
* ```$ bundle exec rake fake:all_data```

---
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
    @projects = Project.paginate(:page => params[:page], :per_page => 10)
  end
```

* Then add the page picker helper to your index page

```erb
<div class="row">
  <div class="col-md-12">
    <%= will_paginate @projects %>
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
json.array!(@projects) do |project|
  json.extract! project, :id, :title, :start_date, :end_date, :client_id
  json.client project.client, :id, :name
  json.url project_url(project)
end
```

* Create a pagination.js file in your assets/javascripts folder

```
(function($) {
  var currentPage = 0;

  function loadData(data) {
    $('#projects').append(Handlebars.compile("{{#projects}} \
      <tr class='ad'> \
        <td><a href='/projects/{{id}}'>{{title}}</a></td> \
        <td><a href='/projects/{{id}}'>{{start_date}}/{{end_date}}</a></td> \
        <td><a href='/projects/{{id}}'>{{client.name}}</a></td> \
        </tr>{{/projects}}")({ projects: data }));
    if (data.length == 0) $('#next_page_spinner').hide();
  }

  function nextPageWithJSON() {
    currentPage += 1;
    var newURL = '/projects.json?page=' + currentPage;

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
    console.log("observeScroll");
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
<h1>Listing Projects</h1>

<%= link_to 'New Project', new_project_path %>

<table class="table table-striped table-hover">
  <thead>
    <tr>
      <th>Title</th>
      <th>Start date/End Date</th>
      <th>Client</th>
    </tr>
  </thead>

  <tbody id="projects">
  </tbody>
</table>

<br>

<img src='http://www.fostersystems.com/ccdata/images/spinner.gif' id='next_page_spinner' />

<%= javascript_include_tag 'pagination' %>

```

# Weather API
* Go to [http://openweathermap.org/](http://openweathermap.org/) and sign up for a free account
* Get your API key and add it to your application.yml

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
<!-- inside the left column -->
  <div class="col-md-2" id="weather-data">
    <h3>Weather</h3>
    <%= image_tag("http://www.fostersystems.com/ccdata/images/spinner.gif", :id => 'next_page_spinner') %>
  </div>

<!-- at the bottom of the page -->
<%= javascript_include_tag 'weather' %>

<script>
  var url =<%=raw "'http://api.openweathermap.org/data/2.5/weather?zip=#{@client.postal_code},us&appid=#{ENV['weather_api']}'" %>
  window.getWeather(url);
</script>
```

