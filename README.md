# extractor
A simple web scrapper in ruby using rack server
Before running the application, make sure you have following gems installed
- nokogiri: ```gem install nokogiri```
- opengraph_parser: ```gem install opengraph_parser```
- workers ```gem install workers```

Then do the following to run the application:
  - clone the application
  - cd into the application root directory and execute the following command:
     ```rackup -Ilib config.ru``` to start the rack server

In your browser visit the url:
  - localhost:9292

**Please note that making the network calls to scrap the required resources may take some time depending on your internet download speed so you will have to wait a couple of minutes/seconds while before the page loads the web page
