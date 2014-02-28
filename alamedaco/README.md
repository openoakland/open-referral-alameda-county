# Oakland Data Day

_Note from Paul Young on Python scraper script_ (`hha_to_json.py`):

I worked on parsing [the spreadsheets containing the HHA PHP (Pocket Health Protector) data](https://docs.google.com/spreadsheet/ccc?key=0AsJuq0MKKTu2dF9sNGR6UmZ5bXFXNWUycVdlODFHZ2c&usp=drive_web#gid=2) into the json specification from https://github.com/codeforamerica/hsd_specification

The output is the attached python script.

To use the script download one of the spreadsheets in tsv format (some of the fields have commas in them making csv tricky). Then run the script as follows:

    python tojson.py infile.tsv outfile.json

This will read in the data from the infile and create the outfile.

The script isn't perfect, there are some field mismatches and I got lazy in parsing the address (should be easy to fix). If this type of script is useful, then it should be easy to adapt to some of the other datasets and I would be happy to do that.
