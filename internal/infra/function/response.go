package function

import (
	"encoding/json"

	"github.com/aws/aws-lambda-go/events"
)

func NewResponse(statusCode int, json []byte) events.APIGatewayProxyResponse {
	return events.APIGatewayProxyResponse{
		StatusCode: statusCode,
		Body:       string(json),
	}
}

type ResponseBody struct {
	Message string `json:"message"`
}

func NewResponseBody(message string) *ResponseBody {
	return &ResponseBody{
		Message: message,
	}
}

func (r *ResponseBody) Marshal() ([]byte, error) {
	return json.Marshal(r)
}
