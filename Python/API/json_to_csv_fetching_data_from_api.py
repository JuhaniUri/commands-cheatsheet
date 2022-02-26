import json
import csv
import requests
## For CVS modification
import pandas as pd  

## API endpoint
v_api_url = 'https://api.disneyapi.dev/characters'
## Disneyapi does not require key, adding this as an example
v_api_header = {"X-API-KEY" : "xxxx" }

## Get data
v_api_request = requests.get(v_api_url, headers=v_api_header).json()

## Access data
v_json_data = v_api_request["data"]

## Loop trought pages (pagination)
## Check for the value "nextPage" from JSON
while "nextPage" in v_api_request: 
    v_api_request = requests.get(v_api_request["nextPage"],headers=v_api_header).json()
    v_json_data.extend(v_api_request["data"])

## Save it all as one file
with open("sample.json", "w") as outfile:
    json.dump(v_json_data, outfile)
    
## Read JSON and export to CSV
df = pd.read_json (r'sample.json', encoding='utf-8')
df.to_csv (r'sample.csv',  encoding='utf-8', index = None)


## Modify the JSON and keep only some columns
v_json_file = pd.read_json('sample.json', orient='_id')
v_columns_we_keep = ['_id','films','url']
v_modified_out = v_json_file[v_columns_we_keep]
print(v_modified_out)


