#Lab 11
* Points 10

##Assignment

* You will need to create a rails application that can search for weather by
zip/postal code.  The site should display the most recent 10 zip/postal codes
that were searched and their current weather.  The weather should be cached for
5 minutes (save to the database and use ```updated_at```) to reduce the number of calls to the weather service.

* Weather API [http://openweathermap.org/api](http://openweathermap.org/api) -
you will need a free API key for this assignment
* A gem I like to use to make API calls is https://github.com/rest-client/rest-client
* Sample request url: ```http://api.openweathermap.org/data/2.5/weather?zip=SOME_POSTAL_CODE,us&appid=YOUR_API_KEY```

###Sample UI

![](https://dl.dropboxusercontent.com/s/g6mkpnpu72obbj6/2016-01-31%20at%208.07%20AM.png)

##Turn in instructions
* Show your instructor the completed assignment
* After you have shown your instructor you may delete this from Heroku/Github if you want
