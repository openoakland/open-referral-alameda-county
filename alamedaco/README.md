# Scraper for http://www.alamedaco.info/

## Requirements
**Ruby**
Preferably version 2.0 or above. Use [rvm](https://rvm.io/) if you don't have it installed.

**MongoDB**
Pupa uses MongoDB (for now). Check [here](http://www.mongodb.org/downloads#packages) for installation instructions.

## Running this script
```
bundle install
bundle exec ruby alamedaco_scraper.rb
bundle exec ruby transformer.rb
```

This will output a `alamedaco.json` file. You can import this into [ohana-api](https://github.com/codeforamerica/ohana-api).

## Notes
This scraper uses the amazing [Pupa](https://github.com/opennorth/pupa-ruby) library from OpenNorth. You might need to cross reference the documentation to understand some of the code but its mostly readable. If something isn't clear or you have a suggestion, feel free to file an issue.

The scraper first checks if the page it wants to visit is available in `web cache`. It isn't part of the `.gitignore` to reduce some of the load on alamedaco.info's servers. Most pages will be available there.

## To Do
* Add more than just the required fields
* Scrape more than the first page
* Refactor transformer.rb into `alamaeda_scraper.rb`
  * Remove dependency on mongoid
  * Investigate multiple foreign keys
* Robust logging system for broke entries
* Tag entires with categories
* Remove MongoDB with Postgresql (need to update Pupa-Ruby)
* Learn more about data set (how often is updated?)
* Clear up main readme a bit and add instructions on how to run multiple scrapers at once
