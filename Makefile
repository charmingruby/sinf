LAMBDA_DIR := function
BINARY_DIR := bin
PACKAGED_LAMBDA_DIR := dist

LAMBDAS := hello world

define build_lambda
	@echo "Building $(1)..."
	GOOS=linux GOARCH=amd64 go build -o $(BINARY_DIR)/$(1) $(LAMBDA_DIR)/$(1)/main.go
	@echo "Packaging $(1)..."
	zip -j $(PACKAGED_LAMBDA_DIR)/$(1).zip $(BINARY_DIR)/$(1)
	@echo "$(1) built and packaged successfully."
endef

bootstrap: $(LAMBDAS)

build-func:
	@echo "Building and packaging Lambda: $(LAMBDA)"
	$(call build_lambda,$(LAMBDA))

$(LAMBDAS):
	$(call build_lambda,$@)

clean:
	@echo "Cleaning up..."
	@for lambda in $(LAMBDAS); do \
		rm -f $(BINARY_DIR)/$$lambda $(PACKAGED_LAMBDA_DIR)/$$lambda.zip; \
	done
	@echo "Cleanup complete."

.PHONY: bootstrap build-func clean 