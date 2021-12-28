.DEFAULT_GOAL 	:= help

ETH2=-
TESTNET=-
run:
	@./main.sh --consensus_engine $(ETH2) --testnet $(TESTNET) 

install:
	@./main.sh --consensus_engine $(ETH2) --testnet $(TESTNET) -s

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'