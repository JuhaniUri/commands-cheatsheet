# Elasticsearch 

## General

### Get indices by creation date
```
GET /_cat/indices/*somename-*/?h=i,ss,creation.date.string&s=creation.date
```


## Query DSL 

### Search with multi condition
```
 {
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "fields": ["Firstname", "Lastname"],
            "query": "John"
          }
        },
        {
          "range": {
            "timestamp": {
              "lt": "2021-04-07 17:49:45.090", "format": "yyyy-MM-dd HH:mm:ss.SSS" 
            }
          }
        }
      ]
    }
  }
}

```




### Count with query 
https://www.elastic.co/guide/en/elasticsearch/reference/current/search-count.html

```
GET /audit.index/_count
{
  "query" : {
    "term" : { "stage" : "prod" }
  }
}
```

### Data migration with reindex and timestamp plus field query.

Where "stage" is field
"query" is value.
$i is elasticsearch index  


```
curl -X POST -k -u $NEW_ELASTIC_USERNAME:$NEW_ELASTIC_PASSWORD "https://$NEW_ELASTIC_IP:9200/_reindex?pretty" -H 'Content-Type: application/json' -d'
{
  "source": {
    "remote": {
      "host": "https://$OLD_ELASIC_IP:9200",
      "username": "'$OLD_ELASTIC_USERNAME'",
      "password": "'$OLD_ELASTIC_PASSWORD'"
    },
    "index": "'$i'",
     "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "default_field": "stage",
            "query": "prod"
          }
        },
        {
          "range": {
            "timestamp": {
             "lt": "2021-04-07 17:49:45.090", "format": "yyyy-MM-dd HH:mm:ss.SSS" }
            }
          }
      ]
    }
  }
},
  "dest": {
    "index": "audit.prod-migrated-000001"
  }
}

```
