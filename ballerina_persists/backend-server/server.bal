import ballerina/log;
import ballerina/http;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"]
    }
}
service /sales on new http:Listener(9090) {

    function init() {
        string[]|error submitCargoResult = sClient->/cargos.post([
            sampleCargo
        ]);

        if (submitCargoResult is error) {
            log:printInfo(submitCargoResult.message());
        }
    }

    // Add a new order by posting a JSON payload
    resource function post orders(Order 'order) returns http:Ok|http:BadRequest {
        string[]|error submitOrderResult = sClient->/orders.post(['order]);
        if submitOrderResult is string[] {
            http:Ok res = {};
            return res;
        }
        http:BadRequest res = {
            body: {
                message: submitOrderResult.message()
            }
        };
        return res;
    };

    // Get all orders. Example: http://localhost:9090/sales/orders
    resource function get orders() returns Order[]|error {
        stream<Order, error?> orders = sClient->/orders;
        return from Order 'order in orders
            select 'order;
    };

    // Get all orders for a given cargo ID. Example: http://localhost:9090/sales/cargoOrders?cargoId=HM-238
    resource function get cargoOrders(string cargoId) returns Order[]|error {
        return from Order 'order in sClient->/orders(targetType = Order)
            where 'order.cargoId == cargoId
            select 'order;
    };

    // Get order by ID. Example: http://localhost:9090/sales/orders/HM-238
    resource function get orders/[string id]() returns Order|http:BadRequest {
        Order|error 'order = sClient->/orders/[id];
        if 'order is Order {
            return 'order;
        }
        http:BadRequest res = {
            body: {
                message: 'order.message()
            }
        };
        return res;
    };
}
