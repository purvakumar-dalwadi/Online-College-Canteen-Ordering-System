<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Double orderTotal = (Double) request.getAttribute("orderTotal");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Success - College Canteen</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    
    <div class="container">
        <div class="success-box">
            <div class="success-icon">✅</div>
            <h1>Order Placed Successfully!</h1>
            <p>Thank you for your order.</p>
            <% if (orderTotal != null) { %>
                <p class="order-total">Total Amount: ₹<%= String.format("%.2f", orderTotal) %></p>
            <% } %>
            <p>Your order is being prepared.</p>
            
            <div class="action-buttons">
                <a href="my_orders.jsp" class="btn btn-primary">View My Orders</a>
                <a href="menu.jsp" class="btn btn-secondary">Order More</a>
            </div>
        </div>
    </div>
</body>
</html>