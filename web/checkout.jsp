<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.canteen.model.*" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<CartItemBean> cart = (List<CartItemBean>) session.getAttribute("cart");
    
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("cart.jsp");
        return;
    }
    
    double total = 0;
    for (CartItemBean item : cart) {
        total += item.getSubtotal();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - College Canteen</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    
    <div class="container">
        <h1 class="page-title">💳 Checkout</h1>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <div class="checkout-container">
            <div class="order-summary">
                <h2>Order Summary</h2>
                <table class="summary-table">
                    <% for (CartItemBean item : cart) { %>
                        <tr>
                            <td><%= item.getProduct().getName() %> x <%= item.getQuantity() %></td>
                            <td>₹<%= String.format("%.2f", item.getSubtotal()) %></td>
                        </tr>
                    <% } %>
                    <tr class="total-row">
                        <td><strong>Total</strong></td>
                        <td><strong>₹<%= String.format("%.2f", total) %></strong></td>
                    </tr>
                </table>
            </div>
            
            <div class="payment-section">
                <h2>Confirm Order</h2>
                <form action="order" method="post">
                    <input type="hidden" name="action" value="place">
                    <p>Click below to place your order</p>
                    <button type="submit" class="btn btn-primary btn-block">Place Order</button>
                </form>
                <a href="cart.jsp" class="btn btn-secondary btn-block">Back to Cart</a>
            </div>
        </div>
    </div>
</body>
</html>