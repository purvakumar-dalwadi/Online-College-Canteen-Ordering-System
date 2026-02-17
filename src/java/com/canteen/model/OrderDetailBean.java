package com.canteen.model;

public class OrderDetailBean {
    private int detailId;
    private int orderId;
    private int productId;
    private String productName;
    private int quantity;
    private double priceAtOrder;
    
    // Constructors
    public OrderDetailBean() {}
    
    public OrderDetailBean(int productId, String productName, int quantity, double priceAtOrder) {
        this.productId = productId;
        this.productName = productName;
        this.quantity = quantity;
        this.priceAtOrder = priceAtOrder;
    }
    
    // Getters and Setters
    public int getDetailId() { return detailId; }
    public void setDetailId(int detailId) { this.detailId = detailId; }
    
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public double getPriceAtOrder() { return priceAtOrder; }
    public void setPriceAtOrder(double priceAtOrder) { this.priceAtOrder = priceAtOrder; }
    
    public double getSubtotal() {
        return priceAtOrder * quantity;
    }
}