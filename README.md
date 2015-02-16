PermittedApp.create!

curl http://localhost:3000/api/users -H 'Authorization: Token token="jzjqCpXsTmhTFmbEdDJWDyiW1GvboLs1Ug"'


curl http://localhost:3000/api/users.json -H 'Content-Type: application/json' -H 'Authorization: Token token="jzjqCpXsTmhTFmbEdDJWDyiW1GvboLs1Ug"' -d '{"user":{"email":"Demo@example.com","sex":"DemoSex","lat":9.99,"lng":9.99, "device_attributes":{"token":"0280df49e2ec993c4e987f54948553ffd8e21ca0d7d22abb786a63f0ba3e5243", "platform":"ios"}}}' -v


hide app, when send notification
