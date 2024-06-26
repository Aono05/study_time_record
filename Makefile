.PHONY: update
update:
	bundle exec whenever --update-crontab

.PHONY: clear
clear:
	bundle exec whenever --clear-crontab

.PHONY: list
list:
	crontab -l

.PHONY: ranking
ranking:
	bundle exec rake ranking:update_ranking

.PHONY: seed
seed:
	bundle exec rake db:seed

.PHONY: migrate
migrate:
	rails db:migrate

.PHONY: rollback
rollback:
	rails db:rollback

.PHONY: status
status:
	rails db:migrate:status

.PHONY: reset
reset:
	rails db:migrate:reset
