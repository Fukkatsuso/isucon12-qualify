isuports: test go.mod go.sum *.go cmd/isuports/*
	go build -o isuports ./cmd/isuports

test:
	go test -v ./...

build:
	echo "build is not needed"

deploy:
	sudo systemctl daemon-reload
	cp -r ./ ~/webapp/go/
	cp -r ../sql ~/webapp/
	sudo systemctl restart isuports.service

show-applog:
	sudo journalctl -u isuports.service
