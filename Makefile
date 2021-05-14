# Make will use bash instead of sh
SHELL := /usr/bin/env bash

.PHONY: help
help:
	@echo 'Usage:'
	
	@echo '	make create CLUSTER=(private|public) WINDOWS=(true|false) STATE=(local|gcs)	Create Cluster and associated resources'
	@echo	''
	@echo '	make secure CLUSTER=(private|public) WINDOWS=(true|false) STATE=(local|gcs)	Create GCS + Big Query log sinks for GKE Audit'
	@echo '						Logs. Use with make start-proxy,for private' 			
	@echo	'						clusters'
	@echo	''
	@echo '	make start-proxy			Generates SSH Tunnel to proxy kubectl connections;'
	@echo '						use with Private Cluster'
	@echo	''
	@echo '	make stop-proxy				Stop SSH Tunnel'
	@echo	''
	@echo '	make destroy CLUSTER=(private|public)	Destroy Cluster and associated resources'
	@echo	''
	@echo '	make start-wi-demo	                Boot strap the workload identity demo into GKE'
	@echo	''
	@echo '	make stop-wi-demo	                Delete workload identity demo resources from GKE'
	@echo	''
.PHONY: create
create:
	@source	scripts/create_cluster.sh $(CLUSTER) $(WINDOWS) $(STATE)


.PHONY: secure
secure:
	@source scripts/secure_cluster.sh $(CLUSTER) $(WINDOWS) $(STATE)

.PHONY: start-proxy
start-proxy:
	@source scripts/proxy_connection.sh

.PHONY: stop-proxy
stop-proxy:
	@source scripts/stop_proxy_connection.sh

.PHONY: destroy
destroy:
	@source scripts/destroy_cluster.sh $(CLUSTER)

.PHONY: start-wi-demo
start-wi-demo:
	@source scripts/start-wi-demo.sh

.PHONY: stop-wi-demo
stop-wi-demo:
	@source scripts/stop-wi-demo.sh
