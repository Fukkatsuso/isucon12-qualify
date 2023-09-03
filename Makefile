build:
	make -C webapp/go build

deploy:
	make -C webapp/go deploy

bench-prepare:
	sudo rm -f /var/log/nginx/access.log
	sudo systemctl reload nginx.service
	sudo rm -f /var/log/mysql/mysql-slow.log
	sudo systemctl restart mysql.service

bench-result:
	mkdir -p alp/dump
	cat /var/log/nginx/access.log \
	| alp ltsv \
		-m '/api/organizer/player/[0-9a-z]+/disqualified,/api/organizer/competition/[0-9a-z]+/finish,/api/organizer/competition/[0-9a-z]+/score,/api/player/player/[0-9a-z]+,/api/player/competition/[0-9a-z]+/ranking' \
		--sort avg -r --dump alp/dump/`git show --format='%h' --no-patch` \
	> /dev/null

latest-alp:
	mkdir -p alp/result
	alp ltsv --sort avg -r --load alp/dump/`git show --format='%h' --no-patch` \
		> alp/result/`git show --format='%h' --no-patch`
	vim alp/result/`git show --format='%h' --no-patch`

show-slowlog:
	sudo mysqldumpslow /var/log/mysql/mysql-slow.log

show-applog:
	make -C webapp/go show-applog
