# Open Referral Alameda County

This repo is a staging ground for OpenOakland's work around the "Open Referral"/"Open 211" initiative to standardize and provide data on social service providers.

### Current Workplan

This is a short-term work plan to get the project some traction and build a proof-of-concept with the data and resources we already have:

- [✓] **Evaluate data source:** Look at the data in the Alameda County 211 site (example: http://www.alamedaco.info/resource/agency.cfm?pid=PG002363_2_1_0 ) and see if we have enough to populate an Ohana API ( https://github.com/codeforamerica/ohana-api ) instance with the required fields ( per https://github.com/codeforamerica/hsd_specification/blob/master/HSD_specification.mdown#content )

  [Completed by Dave](https://github.com/openoakland/open-referral-alameda-county/blob/master/HSD-required-fields-assessment-of-AC-data-source.csv)

- [✓] **Data scraper:** If that 211 site **does** have sufficient data to deploy Ohana, write a proof-of-concept scraper to get data for the required fields for an Ohana instance
- [ ] **ETL for scraped data into Ohana spec:** Write up a small ETL app to transform the data into the structure necessary to load into the Ohana API
- [ ] **Deploy Ohana API alpha:** Stand up an instance of Ohana API with the scraped data
- [ ] **Deploy SMC Connect alpha:** Stand up an instance of SMC Connect ( the front-end for Ohana http://www.smc-connect.org/ ) so people can easily access the data for Alameda County

### People

- Sameer ([@siruguri on Twitter](https://twitter.com/siruguri)) has taken the lead on organizing this effort in Alameda County
- Sunny ([@SunnyRJuneja on Twitter](https://twitter.com/SunnyRJuneja)) is interested in doing a lot of the technical development (tentative choice seems to use mostly Ruby)
- Dave ([@allafarce on Twitter](https://twitter.com/allafarce)) is helping out where useful (like writing this README and maybe helping with scrapers)
- Folks that joined us at Oakland Data Day Feb 2013
  - Dennis Hsieh (pointed us to multiple new datasets!)
  - Paul Young (contributed a Python script to scrape some of Dennis' data)
  - James Bond
  - Mike Ubell

### Additional Background & Links

Sameer has led the effort so far, and has connected with folks at Highland Hospital -- the county's public hospital -- who have their own service provider data that we're trying to get to use for this. They would love a tool to help them use, update, and add this data.

#### Open Referral/211 links

- The Ohana API ( https://github.com/codeforamerica/ohana-api ) is an open source API for social service provider data; it was a 2013 Code for America fellowship project and was awarded a Knight grant in 2014 to continue development and expand the project
- The Human Services Data Specification (HSDS, https://github.com/codeforamerica/hsd_specification/blob/master/HSD_specification.mdown#content ) is a draft data standard for this kind of data that the Ohana API is built upon
- "Open Referral" ( https://www.changemakers.com/project/openreferral ) is a project headed by Greg Bloom ([@greggish on Twitter](https://twitter.com/greggish)) to push for a data standard for service provider data
- Eden I&R ( http://www.edenir.org/ ) provides a directory for Alameda County's social service providers

#### Technical links

- activewarehouse-etl ( https://github.com/activewarehouse/activewarehouse-etl ) is a an ETL framework written in Ruby, and about the most friendly ETL DSL I've seen; it's a bit poorly-documented, but this presentation is helpful: https://speakerdeck.com/thbar/transforming-data-with-ruby-and-activewarehouse-etl
- wombat ( https://github.com/felipecsl/wombat ) is a Ruby web scraping DSL that looks good
- upton ( https://github.com/propublica/upton ) is another Ruby scraping DSL, by ProPublica
- pupa-ruby (https://github.com/opennorth/pupa-ruby) Pupa.rb is a Ruby 2.x fork of Sunlight Labs' Pupa. It implements an Extract, Transform and Load (ETL) process to scrape data from online sources, transform it, and write it to a database.
- A bunch of other Ruby scraping frameworks: https://www.ruby-toolbox.com/categories/Web_Content_Scrapers

### Getting Involved

Contact any of the above folks on Twitter and/or open an Issue here to get involved in the project.
