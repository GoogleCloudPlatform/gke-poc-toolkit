# Make will use bash instead of sh
SHELL := /usr/bin/env bash

.PHONY: help
help:
	@echo 'Usage:'
	
	@echo '	make create CLUSTER=(private|public)	Create Cluster and associated resources'
	@echo	''
	@echo '	make secure CLUSTER=(private|public)	Create GCS + Big Query log sinks for GKE Audit'
	@echo '						Logs. Use with make start-proxy,for private' 			
	@echo	'						clusters'
	@echo	''
	@echo '	make start-proxy			Generates SSH Tunnel to proxy kubectl connections;'
	@echo '						use with Private Cluster'
	@echo	''
	@echo '	make stop-proxy				Stop SSH Tunnel'
	@echo	''
	@echo '	make destroy CLUSTER=(private|public)	Destroy Cluster and associated resources'
.PHONY: create
create:
	@source	scripts/create_cluster.sh $(CLUSTER)


.PHONY: secure
secure:
	@source scripts/secure_cluster.sh $(CLUSTER)

.PHONY: start-proxy
start-proxy:
	@source scripts/proxy_connection.sh

.PHONY: stop-proxy
stop-proxy:
	@source scripts/stop_proxy_connection.sh

.PHONY: destroy
destroy:
	@source scripts/destroy_cluster.sh $(CLUSTER)
