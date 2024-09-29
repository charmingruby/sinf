package main

import (
	"context"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/charmingruby/sinf/internal/infra/function"
)

func handler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	json, err := function.NewResponseBody("hello?").Marshal()
	if err != nil {
		return function.NewResponse(http.StatusInternalServerError, []byte(err.Error())), err
	}

	return function.NewResponse(http.StatusOK, json), nil
}

func main() {
	lambda.Start(handler)
}
