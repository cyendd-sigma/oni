@echo off
set webhook=https://discord.com/api/webhooks/1327746317128306750/LgI9puzilqp0yX0QXxZ5aHLyYF5HXUHchCOhJTtX7d2sN5ysfw5OrHNSbz58QlxTj8Pi
set message=@everyone new hit!

curl -X POST -H "Content-type: application/json" --data "{\"content\": \"%message%\"}" %webhook%
exit