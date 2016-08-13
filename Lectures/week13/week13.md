#Ruby on Rails Development
##Week 13

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

