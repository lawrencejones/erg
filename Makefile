CS := ./node_modules/coffee-script/bin/coffee
CS_FLAGS := --compile --bare

MOCHA := ./node_modules/mocha/bin/mocha
BOWER := ./node_modules/bower/bin/bower

SRC_DIR := src
TEST_DIR := test

.PHONY: all clean test integ install

# Runs coffee-script application
dev:
	$(CS) $(SRC_DIR)/cli.coffee

# Runs mocha test suite
test:
	$(MOCHA) ./$(TEST_DIR)/spec_helper.coffee \
		--recursive $(TEST_DIR) \
		--compilers coffee:coffee-script/register \
		--ui bdd \
		--reporter spec \
		--colors

