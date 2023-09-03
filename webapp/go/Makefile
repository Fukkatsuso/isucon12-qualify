isuports: test go.mod go.sum *.go cmd/isuports/*
	go build -o isuports ./cmd/isuports

test:
	go test -v ./...

build: go.mod go.sum *.go cmd/isuports/*
	go build -o isuports ./cmd/isuports

deploy:
	sudo systemctl stop isuports.go.service
	cp isuports ~/webapp/go/
	cp -r ../sql ~/webapp/
	sudo systemctl start isuports.go.service

show-applog:
	sudo journalctl -u isuports.go.service
