public type Order record {|
    readonly string orderId;
    string customerId;
    float totalAmount;
    string? shipId;
    string date;
    string eta;
    OrderStatus status;
|};

public enum OrderStatus {
    PENDING,
    SHIPPED,
    DELIVERED,
    CANCELED,
    RETURNED
};
