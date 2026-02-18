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
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    
    <div class="container">
        <h1 class="page-title">📦 My Orders</h1>
        
        <% if (orders == null || orders.isEmpty()) { %>
            <div class="empty-orders">
                <p>You haven't placed any orders yet!</p>
                <a href="menu.jsp" class="btn btn-primary">Browse Menu</a>
            </div>
        <% } else { %>
            <div class="orders-container">
                <% for (OrderBean order : orders) { %>
                    <div class="order-card">
                        <div class="order-header">
                            <h3>Order #<%= order.getOrderId() %></h3>
                            <span class="order-status status-<%= order.getStatus().toLowerCase() %>">
                                <%= order.getStatus() %>
                            </span>
                        </div>
                        
                        <div class="order-info">
                            <p><strong>Order Date:</strong> <%= order.getOrderDate() %></p>
                            <p><strong>Total Amount:</strong> ₹<%= String.format("%.2f", order.getTotalAmount()) %></p>
                        </div>
                        
                        <div class="order-items">
                            <h4>Items:</h4>
                            <ul>
                                <% for (OrderDetailBean detail : order.getOrderDetails()) { %>
                                    <li>
                                        <%= detail.getProductName() %> 
                                        x <%= detail.getQuantity() %> 
                                        - ₹<%= String.format("%.2f", detail.getSubtotal()) %>
                                    </li>
                                <% } %>
                            </ul>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
</body>
</html>