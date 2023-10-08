build:
	make -C webapp/go build

deploy:
	mkdir -p ~/webapp/sqlite && touch ~/webapp/sqlite/trace.json
	sudo cp limits.conf /etc/security/limits.conf
	make -C webapp/go deploy

bench-prepare:
	rm -f ~/webapp/sqlite/trace.json && touch ~/webapp/sqlite/trace.json
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

enable-pprof:
	sed -i -e 's/PPROF=0/PPROF=1/' ~/webapp/env.sh

disable-pprof:
	sed -i -e 's/PPROF=1/PPROF=0/' ~/webapp/env.sh

start-pprof: enable-pprof deploy
	sleep 3 # wait surver up
	go tool pprof -http=0.0.0.0:1080 http://localhost:6060/debug/pprof/profile?seconds=80

