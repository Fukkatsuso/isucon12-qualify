isuports: test go.mod go.sum *.go cmd/isuports/*
	go build -o isuports ./cmd/isuports

test:
	go test -v ./...

build:
	echo "build is not needed"

deploy:
	cp -r ./ ~/webapp/go/
	cp -r ../sql ~/webapp/
	cp ../docker-compose-go.yml ~/webapp/
	cp ./isuports.service /etc/systemd/system/isuports.service
	sudo systemctl daemon-reload
	sudo systemctl restart isuports.service

show-applog:
	sudo journalctl -u isuports.service
