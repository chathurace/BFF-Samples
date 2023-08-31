import ballerina/http;

service /orders on new http:Listener(9090) {
    resource function post 'submit(Order 'orders) returns http:Ok|SubmitFailureResponse {
        Order|error submitOrderResult = submitOrder('orders);
        if submitOrderResult is Order {
            http:Ok res = {};
            return res;
        }
        return <SubmitFailureResponse> {
            body: {
                message: submitOrderResult.message()
            }
        };
    };

    resource function get getAllOrders() returns Order[] {
        return getAllOrders();
    };
}
