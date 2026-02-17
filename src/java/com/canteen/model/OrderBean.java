package com.canteen.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class OrderBean {
    private int orderId;
    private int userId;
    private double totalAmount;
    private Timestamp orderDate;
    private String status;
    private List<OrderDetailBean> orderDetails;
    
    // Constructors
    public OrderBean() {
        this.orderDetails = new ArrayList<>();
    }
    
    public OrderBean(int orderId, int userId, double totalAmount, Timestamp orderDate, String status) {
        this.orderId = orderId;
        this.userId = userId;
        this.totalAmount = totalAmount;
        this.orderDate = orderDate;
        this.status = status;
        this.orderDetails = new ArrayList<>();
    }
    
    // Getters and Setters
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    
    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public List<OrderDetailBean> getOrderDetails() { return orderDetails; }
    public void setOrderDetails(List<OrderDetailBean> orderDetails) { this.orderDetails = orderDetails; }
}