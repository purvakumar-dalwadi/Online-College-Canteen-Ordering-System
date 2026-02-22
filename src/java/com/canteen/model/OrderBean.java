package com.canteen.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class OrderBean {
    private String paymentMethod;
    private String userName; // For display only, not persisted
    private String paymentStatus;
    private String transactionId;
    private Timestamp paymentDate;

    // Returns order details as a formatted string for display
    public String getOrderDetailsSummary() {
        if (orderDetails == null || orderDetails.isEmpty()) return "No items.";
        StringBuilder sb = new StringBuilder();
        sb.append("Order ID: ").append(orderId).append("\n");
        sb.append("User: ").append(userName != null && !userName.isEmpty() ? userName : userId).append("\n");
        sb.append("Payment Method: ").append(paymentMethod != null && !paymentMethod.isEmpty() ? paymentMethod : "N/A").append("\n");
        sb.append("Status: ").append(status).append("\n");
        sb.append("Order Date: ").append(orderDate).append("\n");
        sb.append("\nProduct Name        Qty   Price   Subtotal\n");
        sb.append("------------------------------------------\n");
        double total = 0;
        for (OrderDetailBean d : orderDetails) {
            double subtotal = d.getSubtotal();
            total += subtotal;
            sb.append(String.format("%-18s %3d  ₹%-7.2f ₹%.2f\n",
                d.getProductName(), d.getQuantity(), d.getPriceAtOrder(), subtotal));
        }
        sb.append("------------------------------------------\n");
        sb.append(String.format("Total: ₹%.2f", total));
        return sb.toString();
    }
    private int orderId;
    private int userId;
    private double totalAmount;
    private Timestamp orderDate;
    private String status;
    private List<OrderDetailBean> orderDetails;
    
    // Constructors
    public OrderBean() {
        this.orderDetails = new ArrayList<>();
        this.paymentMethod = "";
        this.userName = "";
        this.paymentStatus = "";
        this.transactionId = "";
        this.paymentDate = null;
    }
    
    public OrderBean(int orderId, int userId, double totalAmount, Timestamp orderDate, String status) {
        this.orderId = orderId;
        this.userId = userId;
        this.totalAmount = totalAmount;
        this.orderDate = orderDate;
        this.status = status;
        this.orderDetails = new ArrayList<>();
        this.paymentMethod = "";
        this.userName = "";
        this.paymentStatus = "";
        this.transactionId = "";
        this.paymentDate = null;
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
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    public Timestamp getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Timestamp paymentDate) { this.paymentDate = paymentDate; }

    public void setOrderDetails(List<OrderDetailBean> orderDetails) { this.orderDetails = orderDetails; }
}