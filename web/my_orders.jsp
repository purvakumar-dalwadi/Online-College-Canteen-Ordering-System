<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.canteen.model.*, com.canteen.dao.*" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Integer userId = (Integer) session.getAttribute("userId");
    OrderDAO orderDAO = new OrderDAO();
    List<OrderBean> orders = orderDAO.getOrdersByUserId(userId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - College Canteen</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .order-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        
        .order-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .order-id {
            font-size: 20px;
            font-weight: bold;
            color: #333;
        }
        
        .payment-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin: 15px 0;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .payment-detail {
            display: flex;
            flex-direction: column;
        }
        
        .payment-label {
            font-size: 12px;
            color: #666;
            margin-bottom: 5px;
        }
        
        .payment-value {
            font-size: 14px;
            font-weight: bold;
            color: #333;
        }
        
        .transaction-badge {
            background: #e3f2fd;
            color: #0d6efd;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-family: monospace;
            display: inline-block;
        }
    </style>
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    
    <div class="container">
        <h1 class="page-title">📦 My Orders</h1>
        
        <% if (orders == null || orders.isEmpty()) { %>
            <div class="empty-orders">
                <div style="font-size: 80px; margin-bottom: 20px;">🍽️</div>
                <p style="font-size: 24px; margin-bottom: 15px;">No orders yet!</p>
                <p style="color: #666; margin-bottom: 30px;">Start by browsing our delicious menu</p>
                <a href="menu.jsp" class="btn btn-primary">Browse Menu</a>
            </div>
        <% } else { %>
            <div class="orders-container">
                <% for (OrderBean order : orders) { %>
                    <div class="order-card">
                        <!-- Order Header -->
                        <div class="order-header">
                            <div>
                                <span class="order-id"># Order <%= order.getOrderId() %></span>
                                <p style="margin: 5px 0; color: #666; font-size: 14px;">
                                    <%= new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(order.getOrderDate()) %>
                                </p>
                            </div>
                            <span class="order-status status-<%= order.getStatus().toLowerCase() %>">
                                <%= order.getStatus() %>
                            </span>
                        </div>
                        
                        <!-- Order Items -->
                        <div class="order-items">
                            <h4 style="color: #667eea; margin: 0 0 15px 0; font-size: 16px;">🍽️ Items Ordered:</h4>
                            <div style="background: #f8f9fa; padding: 15px; border-radius: 8px;">
                                <ul style="list-style: none; padding: 0; margin: 0;">
                                    <% for (OrderDetailBean detail : order.getOrderDetails()) { %>
                                        <li style="padding: 8px 0; border-bottom: 1px solid #dee2e6; display: flex; justify-content: space-between;">
                                            <span>
                                                <%= detail.getProductName() %> 
                                                <span style="color: #666; font-size: 14px;">× <%= detail.getQuantity() %></span>
                                            </span>
                                            <span style="font-weight: bold;">
                                                ₹<%= String.format("%.2f", detail.getSubtotal()) %>
                                            </span>
                                        </li>
                                    <% } %>
                                    <li style="padding: 12px 0 0 0; display: flex; justify-content: space-between; font-size: 18px;">
                                        <strong>Total:</strong>
                                        <strong style="color: #667eea;">₹<%= String.format("%.2f", order.getTotalAmount()) %></strong>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        
                        <!-- Payment Information -->
                        <div style="margin-top: 20px;">
                            <h4 style="color: #667eea; margin: 0 0 10px 0; font-size: 16px;">💳 Payment Details:</h4>
                            <div class="payment-info-grid">
                                <div class="payment-detail">
                                    <span class="payment-label">Payment Method</span>
                                    <span class="payment-value">
                                        <% 
                                            String method = order.getPaymentMethod();
                                            String methodIcon = "💳";
                                            if ("Cash on Pickup".equals(method)) methodIcon = "💵";
                                            else if ("UPI".equals(method)) methodIcon = "📱";
                                            else if ("College Wallet".equals(method)) methodIcon = "🎓";
                                        %>
                                        <%= methodIcon %> <%= method %>
                                    </span>
                                </div>
                                
                                <div class="payment-detail">
                                    <span class="payment-label">Payment Status</span>
                                    <span class="payment-value">
                                        <% if ("Completed".equals(order.getPaymentStatus())) { %>
                                            <span style="color: #28a745;">✅ Paid</span>
                                        <% } else { %>
                                            <span style="color: #ffc107;">⏳ Pending</span>
                                        <% } %>
                                    </span>
                                </div>
                                
                                <div class="payment-detail">
                                    <span class="payment-label">Transaction ID</span>
                                    <span class="payment-value">
                                        <span class="transaction-badge">
                                            <% String txId = order.getTransactionId(); %>
                                            <% if (txId == null || txId.trim().isEmpty()) { %>
                                                N/A
                                            <% } else if (txId.length() > 15) { %>
                                                <%= txId.substring(0, 15) %>...
                                            <% } else { %>
                                                <%= txId %>
                                            <% } %>
                                        </span>
                                    </span>
                                </div>
                                
                                <% if (order.getPaymentDate() != null) { %>
                                    <div class="payment-detail">
                                        <span class="payment-label">Paid On</span>
                                        <span class="payment-value">
                                            <%= new java.text.SimpleDateFormat("dd MMM, hh:mm a").format(order.getPaymentDate()) %>
                                        </span>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                        
                        <!-- Action based on payment status -->
                        <% if ("Pending".equals(order.getPaymentStatus()) && "Cash on Pickup".equals(order.getPaymentMethod())) { %>
                            <div style="background: #fff3cd; padding: 15px; border-radius: 8px; margin-top: 15px; border-left: 4px solid #ffc107;">
                                <strong style="color: #856404;">⚠️ Payment Due:</strong>
                                <p style="margin: 5px 0; color: #856404;">
                                    Please pay ₹<%= String.format("%.2f", order.getTotalAmount()) %> in cash when collecting your order.
                                </p>
                            </div>
                        <% } else if ("Completed".equals(order.getPaymentStatus())) { %>
                            <div style="background: #d4edda; padding: 15px; border-radius: 8px; margin-top: 15px; border-left: 4px solid #28a745;">
                                <strong style="color: #155724;">✅ Payment Confirmed</strong>
                                <p style="margin: 5px 0; color: #155724;">
                                    Your payment has been successfully processed.
                                </p>
                            </div>
                        <% } %>
                        
                        <!-- Order Status Info -->
                        <% if ("Ready".equals(order.getStatus())) { %>
                            <div style="background: #cfe2ff; padding: 15px; border-radius: 8px; margin-top: 15px; border-left: 4px solid #0d6efd;">
                                <strong style="color: #084298;">📍 Your order is ready for pickup!</strong>
                                <p style="margin: 5px 0; color: #084298;">
                                    Please collect from Main Canteen Counter
                                </p>
                            </div>
                        <% } else if ("Preparing".equals(order.getStatus())) { %>
                            <div style="background: #fff3cd; padding: 15px; border-radius: 8px; margin-top: 15px; border-left: 4px solid #ffc107;">
                                <strong style="color: #856404;">👨‍🍳 Your order is being prepared</strong>
                                <p style="margin: 5px 0; color: #856404;">
                                    Estimated time: 15-20 minutes
                                </p>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
            
            <!-- Summary Statistics -->
            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; border-radius: 12px; margin-top: 30px;">
                <h3 style="margin: 0 0 20px 0; text-align: center;">📊 Order Summary</h3>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 20px; text-align: center;">
                    <div>
                        <p style="margin: 0; font-size: 14px; opacity: 0.9;">Total Orders</p>
                        <p style="margin: 10px 0 0 0; font-size: 32px; font-weight: bold;"><%= orders.size() %></p>
                    </div>
                    <div>
                        <p style="margin: 0; font-size: 14px; opacity: 0.9;">Total Spent</p>
                        <p style="margin: 10px 0 0 0; font-size: 32px; font-weight: bold;">
                            ₹<%= String.format("%.2f", orders.stream().mapToDouble(OrderBean::getTotalAmount).sum()) %>
                        </p>
                    </div>
                    <div>
                        <p style="margin: 0; font-size: 14px; opacity: 0.9;">Last Order</p>
                        <p style="margin: 10px 0 0 0; font-size: 18px; font-weight: bold;">
                            <%= orders.isEmpty() ? "N/A" : new java.text.SimpleDateFormat("dd MMM").format(orders.get(0).getOrderDate()) %>
                        </p>
                    </div>
                </div>
            </div>
        <% } %>
        
        <!-- Continue Shopping Button -->
        <div style="text-align: center; margin-top: 30px;">
            <a href="menu.jsp" class="btn btn-primary" style="padding: 15px 40px; font-size: 18px;">
                🍽️ Continue Shopping
            </a>
        </div>
    </div>
</body>
</html>
