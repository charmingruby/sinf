LAMBDA_DIR := function
BINARY_DIR := bin
PACKAGED_LAMBDA_DIR := dist

LAMBDAS := hello world

define build_lambda
	@echo "Building $(1)..."
	GOOS=linux GOARCH=amd64 go build -tags lambda.norpc -o bin/${1} ./function/${1}/main.go
	@echo "Packaging $(1)..."
	cp bin/${1} bin/bootstrap
    zip -j dist/bootstrap.zip bin/bootstrap
	@echo "$(1) built and packaged successfully."
endef

bootstrap: $(LAMBDAS) 

build-func:
	@echo "Building and packaging Lambda: $(LAMBDA)"
	$(call build_lambda,$(LAMBDA))

$(LAMBDAS):
	$(call build_lambda,$@)

.PHONY: bootstrap build-func 