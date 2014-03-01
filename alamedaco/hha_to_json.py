#!/usr/bin/env python

import json
from collections import defaultdict
import argparse


def to_json(fpath):
    """docstring for to_json"""
    return json.dumps(
        to_obj(fpath),
        sort_keys=True,
        indent=4
        )


def to_obj(fpath):
    """
    Takes in a tab separated file from HHA PHP RESOURCE SPREADSHEET
    and outputs a jsonable object.
    """
    f = open(fpath, "r")
    output = []
    headers = f.readline().strip().split("\t")
    for line in f:
        output.append(parse_org(line, headers))
    return output


def parse_org(org_line, headers):
    """
    Takes a tsv line representing an organization and outputs json
    representation.
    """
    org_split = org_line.strip().split("\t")
    org_dict = defaultdict(str)
    for i in range(0, len(org_split)-1):
        org_dict[headers[i]] = org_split[i]
    output = [
        {
            "name": org_dict['name'],
            "locations":[
                {
                    "name": org_dict['name'],
                    "contacts": [],
                    "description": org_dict["description"],
                    "short_desc": "",
                    # TODO: need to parse address into diff fields
                    "address": org_dict["address"],
                    "hours": org_dict["hours"],
                    "languages": org_dict["languages"],
                    "phones":{
                        "number": org_dict["phone"],
                        "type": "voice"
                        },
                    "internet_resource":{
                        "url": org_dict["website"]
                        },
                    "services":[
                        {
                            "audience": org_dict["population"],
                            "fees": org_dict["cost"]
                        }
                        ]
                    }
                ]
        }
    ]
    return output


def main():
    """Just a test"""
    parser = argparse.ArgumentParser(description="Transorm .tsv file into HSD json format")
    parser.add_argument("infile", help='File to be transformed')
    parser.add_argument("outfile", help='File to be written to')
    args = parser.parse_args()
    result = to_json(args.infile)
    outfile = open(args.outfile, "w")
    outfile.writelines(result)

if __name__ == '__main__':
    main()
