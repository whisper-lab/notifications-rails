PermittedApp.create!

curl http://localhost:3000/api/users -H 'Authorization: Token token="jzjqCpXsTmhTFmbEdDJWDyiW1GvboLs1Ug"'


curl http://localhost:3000/api/users.json -H 'Content-Type: application/json' -H 'Authorization: Token token="jzjqCpXsTmhTFmbEdDJWDyiW1GvboLs1Ug"' -d '{"user":{"email":"Demo@example.com","sex":"DemoSex","lat":9.99,"lng":9.99, "device_attributes":{"token":"0280df49e2ec993c4e987f54948553ffd8e21ca0d7d22abb786a63f0ba3e5243", "platform":"ios"}}}' -v


hide app, when send notification


redis-server
redis-cli
----- flushdb

rerun foreman start
foreman run rake db:migrate
foreman run rails console
git push heroku master



curl http://localhost:3000/api/users -H 'Content-Type: application/json' -H 'Authorization: Token token="API_MASTER_KEY"' -d '{"user":{"name":"Alexey", "email":"lesha.pus@gmail.com","password":"12345678","sex":"male","lat":9.99,"lng":9.99, "device_attributes":{"token":"0280df49e2ec993c4e987f54948553ffd8e21ca0d7d22abb786a63f0ba3e5243", "platform":"ios"}}}' -v

curl http://localhost:3000/api/auth -H 'Content-Type: application/json' -H 'Authorization: Token token="API_MASTER_KEY"' -d '{"email":"lesha.pus@gmail.com", "password":"12345678"}' -v

curl http://localhost:3000/api/users -H 'Content-Type: application/json' -H 'Authorization: Token token="email:API_KEY"' -v

curl --request PATCH http://localhost:3000/api/users/2 -H 'Content-Type: application/json' -H 'Authorization: Token token="lesha.pus@gmail.com:API_KEY"' -d '{"user":"{"lng":"1"}"}' -v

curl --request DELETE http://localhost:3000/api/users/2 -H 'Content-Type: application/json' -H 'Authorization: Token token="lesha.pus@gmail.com:API_KEY"'  -v

