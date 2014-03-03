# Scraper for http://www.alamedaco.info/

## Requirements
**Ruby**
Preferably version 2.0 or above. Use [rvm](https://rvm.io/) if you don't have it installed.

**MongoDB**
Pupa uses MongoDB (for now). Check [here](http://www.mongodb.org/downloads#packages) for installation instructions.

## Running this script
```ruby
bundle install
bundle exec ruby alamedaco.rb
```

## Notes
This scraper uses the amazing [Pupa](https://github.com/opennorth/pupa-ruby) library from OpenNorth. You might need to cross reference the documentation to understand some of the code but its mostly readable. If something isn't clear or you have a suggestion, feel free to file an issue.

You don't need to touch the `web_cache` or `scraped_data` directory. `web_cache` is the cache of every page visited by the scraper and `scraped_data` is a json representation of the extraction.

Normally, I would add `scraped_data` and `web_cache` to the `.gitignore` but we hit a lot of pages that don't change often so I thought it would be polite not to overload alamedaco.info's servers. If you change the extraction logic of the script, it will automatically update `scraped_data`.
