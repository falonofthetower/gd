# Installation

Run `bundle install`

# Database

create the test and development databases

`RACK_ENV=test rake db:migrate`
`rake db:migrate`

# Seed

`ruby seed.rb`

# Launch

`rackup -p 4567`

# Demo

- create request

```
curl -X POST \
  http://localhost:4567/request \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache' \
  -d '{
    "title": "1984",
    "email": "fake@example.com"
}'
```

- Delete Request

```
curl -X DELETE \
  http://localhost:4567/request/1 \
  -H 'Postman-Token: 8a879989-8b4d-4341-a050-b5f762cb2817' \
  -H 'cache-control: no-cache'

```

- Return list of requests

```
curl -X GET \
  http://localhost:4567/request \
  -H 'Postman-Token: c5729370-aef9-44a3-a81e-f0400f9107df' \
  -H 'cache-control: no-cache'
```
