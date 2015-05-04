# Notifications Rails
Push Notification Service

####Steps

First install needed gems(bundle) and prepare databases.

###### Then

```shell
$ cd /path/to/notifications-rails
```
###### Create .env config file
```shell
$ vim .env
```
###### Fill it *(use your own settings instead)* :
```ruby
RACK_ENV=development
PORT=3000
AWS_REGION=us-west-2
S3_BUCKET_PNS=pnscredentials-development
AWS_ACCESS_KEY_ID=YOURDEVAWSACCESSKEYID
AWS_SECRET_ACCESS_KEY=YOURDEVAWSSECRETACCESSKEY
ADMIN_NAME=First User
ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=STRONGADMINPASSWORD
ADMIN_SEX=male
GMAIL_DOMAIN=example.com
GMAIL_USERNAME=yourname@example.com
GMAIL_PASSWORD=YOURGMAILPASSWORD
DOMAIN_NAME=example.herokuapp.com
API_MASTER_KEY=YOURLONGAPIMASTERKEY
```
Get your developement pnscredentials certifitate file from Apple. (for sending push notifications using Apple PNS)

And then place it in Amazon AWS S3 with S3_BUCKET_PNS name.
###### Prepare db
```shell
$ foreman run rake db:migrate
```
###### Start server
```shell
$ foreman start
```

###### Browser adderss:
    localhost:3000
