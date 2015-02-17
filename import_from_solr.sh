#!/bin/sh

# Details on river usage: https://github.com/javanna/elasticsearch-river-solr/

echo "Creating river for importing some transPlant-EBI Solr data (limited to 3000 documents) into ebi_cluster"
curl -XPUT localhost:9221/_river/solr_river_ebi/_meta -d '
{
    "type" : "solr",
    "close_on_completion" : "true",
    "solr" : {
        "url" : "http://solr.transplantdb.eu/solr/transPlant-EBI/select",
        "q" : "gene",
        "fq" : "",
        "fl" : "",
        "qt" : "",
        "uniqueKey" : "id",
        "start" : "0",
        "rows" : 3000
    },
    "index" : {
        "index" : "transplant-ebi",
        "type" : "import",
        "bulk_size" : 3000,
        "max_concurrent_bulk" : 3,
        "mappings" : "",
        "settings": ""
    }
}'

echo "Creating river for importing some transPlant-URGI Solr data (limited to 3000 documents) into urgi_cluster"
curl -XPUT localhost:9211/_river/solr_river_urgi/_meta -d '
{
    "type" : "solr",
    "close_on_completion" : "true",
    "solr" : {
        "url" : "https://urgi.versailles.inra.fr/solr/URGI/select",
        "q" : "Arabidopsis*",
        "fq" : "",
        "fl" : "",
        "qt" : "",
        "uniqueKey" : "id",
        "start" : "0",
        "rows" : 3000
    },
    "index" : {
        "index" : "transplant-urgi",
        "type" : "import",
        "bulk_size" : 3000,
        "max_concurrent_bulk" : 3,
        "mappings" : "",
        "settings": ""
    }
}'

# curl -XDELETE localhost:9200/_river/solr_river/

# curl -XPUT localhost:9200/_river/solr_river/_meta -d '
# {
#     "type" : "solr",
#     "solr" : {
#         "url" : "https://urgi.versailles.inra.fr/solr/transPLANT/",
#         "q" : "*:*"
#     }
# }'


# http://solr.transplantdb.eu/solr/transPlant-EBI

