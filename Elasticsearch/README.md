# Elasticsearch 

- [Elasticsearch](#elasticsearch)
  - [General](#general)
    - [Get indices by creation date](#get-indices-by-creation-date)
  - [Query DSL](#query-dsl)
    - [Search with multi condition](#search-with-multi-condition)
    - [Count with query](#count-with-query)
    - [Data migration with reindex and timestamp plus field query.](#data-migration-with-reindex-and-timestamp-plus-field-query)
    - [Details on the shards status](#details-on-the-shards-status)
    - [Exlude some nodes by IP](#exlude-some-nodes-by-ip)

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

### Details on the shards status

```
GET _cat/shards?v&h=index,shard,prirep,state,store,ip,unassigned.reason
```


### Exlude some nodes by IP
```
curl -X PUT -k -u $ELASTIC_USERNAME:$ELASTIC_PASSWORD "https://localhost:9200/_cluster/settings?pretty" -H 'Content-Type: application/json' -d'
{
  "transient": {
    "cluster.routing.allocation.exclude._ip": "10.175.138.*"
  }
}
```