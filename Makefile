.PHONY: help ## ヘルプ
help:
	@grep -E '[#]# ' $(MAKEFILE_LIST) | awk '{printf "\033[36m%-20s\033[0m %s\n", $$(NF-2), $$(NF)}'

export GO111MODULE=on
DB_HOST:=127.0.0.1
DB_PORT:=3306
DB_USER:=isucon
DB_PASS:=isucon
DB_NAME:=isuumo

PROJECT_ROOT:=/home/isucon/isuumo
BUILD_DIR:=/home/isucon/isuumo/webapp/go
BIN_NAME:=isuumo

MYSQL_CMD:=mysql -h$(DB_HOST) -P$(DB_PORT) -u$(DB_USER) -p$(DB_PASS) $(DB_NAME)
NGX_LOG:=/var/log/nginx/access.log
MYSQL_LOG:=/tmp/slow-query.log

KATARU_CFG:=./kataribe.toml

PPROF:=go tool pprof -png -output pprof.png http://localhost:6060/debug/pprof/profile


SYSTEMCTL_NAME:=isucondition.go.service

CA:=-o /dev/null -s -w "%{http_code}\n"

# .PHONY: clean
# clean:
#	    cd $(BUILD_DIR); \
#	    rm -rf torb
#
# deps:
#	    cd $(BUILD_DIR); \
#	    go mod download
#

.PHONY: build
build:
	cd $(BUILD_DIR); \
	go build -o $(BIN_NAME)

# ここから下もともと作ってある秘伝のタレ

.PHONY: test ## curlで状況確認
test:
	curl localhost $(CA)

.PHONY: app-restart ## アプリの再起動
app-restart:
	sudo systemctl restart $(SYSTEMCTL_NAME)

.PHONY: dev-run ## アプリをビルドしてそのまま実行する
dev-run: build
	cd $(BUILD_DIR); \
	./$(BIN_NAME)

.PHONY: bench-dev ## コミットしてログローテート、スロークエリログをONにしてビルド、そのまま実行する（benchで良さそう）
bench-dev: commit log-rotate slow-on dev-run

.PHONY: bench ## コミットしてログの退避、アプリビルド、アプリ再起動、スロークエリログをON、その後journalログ出力
bench: log-rotate slow-on build app-restart journal-log-out

.PHONY: journal-log-out ## journalログ出力
journal-log-out:
	sudo journalctl -u isucari.golang -n10 -f

.PHONY: maji ## git_commitしてログを退避してビルド、アプリを再起動
bench: commit log-rotate build app-restart


.PHONY: commit ## git_commit
commit:
	cd $(PROJECT_ROOT); \
	git add .; \
	git commit --allow-empty -m "bench"

.PHONY: log-rotate ## Nginx,MySQLのログを退避してNginx,MySQL再起動
log-rotate:
	$(eval when := $(shell date "+%s"))
	mkdir -p $(HOME)/logs/raw/$(when)
	@if [ -f $(NGX_LOG) ]; then \
	        sudo mv -f $(NGX_LOG) $(HOME)/logs/raw/$(when)/ ; \
	fi
	@if [ -f $(MYSQL_LOG) ]; then \
	        sudo mv -f $(MYSQL_LOG) $(HOME)/logs/raw/$(when)/ ; \
	fi
	sudo systemctl restart nginx
	sudo systemctl restart mysql

.PHONY: analyze ## MysqlAnalyzeとNginxAnalyzeを動かしてanalyze結果を退避する
analyze: mysql-analyze nginx-analyze analyze-rotate

.PHONY: mysql-analyze ## MySQLのスロークエリログをpt-query-digestに食わせる
mysql-analyze:
	mkdir -p $(HOME)/logs/analyze
	sudo pt-query-digest $(MYSQL_LOG) > $(HOME)/logs/analyze/mysqlAnalyze.log

.PHONY: nginx-analyze ## Nginxのログをkataribeに食わせる
nginx-analyze:
	mkdir -p $(HOME)/logs/analyze
	sudo cat $(NGX_LOG) | kataribe -f ./kataribe.toml > $(HOME)/logs/analyze/nginxAnalyze.log

.PHONY: analyze-rotate
analyze-rotate:
	$(eval when := $(shell date "+%s"))
	mkdir -p $(HOME)/logs/analyze/$(when)
	sudo cp -f $(HOME)/logs/analyze/mysqlAnalyze.log $(HOME)/logs/analyze/$(when)/mysqlAnalyze.log
	sudo cp -f $(HOME)/logs/analyze/nginxAnalyze.log $(HOME)/logs/analyze/$(when)/nginxAnalyze.log


.PHONY: pprof ## Go言語のpprofを出力する
pprof:
	$(PPROF)

.PHONY: slow-on ## スロークエリログの出力をONにする
slow-on:
	sudo mysql -e "set global slow_query_log_file = '$(MYSQL_LOG)'; set global long_query_time = 0; set global slow_query_log = ON;"
	# sudo $(MYSQL_CMD) -e "set global slow_query_log_file = '$(MYSQL_LOG)'; set global long_query_time = 0; set global slow_query_log = ON;"

.PHONY: slow-off ## スロークエリログの出力をOFFにする
slow-off:
	sudo mysql -e "set global slow_query_log = OFF;"
	# sudo $(MYSQL_CMD) -e "set global slow_query_log = OFF;"

.PHONY: install-app ## 諸々のアプリをインストール
install-app:
	sudo apt install -y percona-toolkit dstat git unzip wget
	git config --global user.email "tkancf@tkan.dev"
	git config --global user.name "tkancf"
	wget https://github.com/matsuu/kataribe/releases/download/v0.4.1/kataribe-v0.4.1_linux_amd64.zip -O kataribe.zip
	unzip -o kataribe.zip
	sudo mv kataribe /usr/local/bin/
	sudo chmod +x /usr/local/bin/kataribe
	rm kataribe.zip
	kataribe -generate
	wget https://github.com/KLab/myprofiler/releases/download/0.2/myprofiler.linux_amd64.tar.gz
	tar xf myprofiler.linux_amd64.tar.gz
	rm myprofiler.linux_amd64.tar.gz
	sudo mv myprofiler /usr/local/bin/
	sudo chmod +x /usr/local/bin/myprofiler
