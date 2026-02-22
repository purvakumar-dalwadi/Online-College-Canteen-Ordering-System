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
        <h1 class="page-title">✅ Checkout</h1>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <div class="checkout-container">
            <!-- Order Summary -->
            <div class="order-summary">
                <h2>📋 Order Summary</h2>
                <table class="summary-table">
                    <thead>
                        <tr>
                            <th>Item</th>
                            <th>Qty</th>
                            <th>Price</th>
                            <th>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (CartItemBean item : cart) { %>
                            <tr>
                                <td><%= item.getProduct().getName() %></td>
                                <td><%= item.getQuantity() %></td>
                                <td>₹<%= String.format("%.2f", item.getProduct().getPrice()) %></td>
                                <td>₹<%= String.format("%.2f", item.getSubtotal()) %></td>
                            </tr>
                        <% } %>
                    </tbody>
                    <tfoot>
                        <tr class="total-row">
                            <td colspan="3"><strong>Total Amount</strong></td>
                            <td><strong>₹<%= String.format("%.2f", total) %></strong></td>
                        </tr>
                    </tfoot>
                </table>
                
                <!-- Additional Info -->
                <div class="checkout-info-box">
                    <p class="checkout-info-text">
                        <strong>📍 Pickup Location:</strong> Main Canteen Counter
                    </p>
                    <p class="checkout-info-text">
                        <strong>⏰ Estimated Time:</strong> 15-20 minutes after order
                    </p>
                    <p class="checkout-info-text">
                        <strong>📦 Total Items:</strong> <%= cart.size() %> items
                    </p>
                </div>
            </div>
            
            <!-- Checkout Actions -->
            <div class="payment-section">
                <h2>🚀 Ready to Order?</h2>
                <p class="checkout-desc">
                    Review your order and proceed to payment selection
                </p>
                
                <!-- Payment Preview -->
                <div class="payment-preview-box">
                    <h3 class="payment-preview-title">💳 Available Payment Methods</h3>
                    <div class="payment-methods-preview">
                        <div class="payment-method-preview cash">
                            <strong>💵 Cash on Pickup</strong> - Pay when you collect
                        </div>
                        <div class="payment-method-preview upi">
                            <strong>📱 UPI</strong> - GooglePay, PhonePe, Paytm
                        </div>
                        <div class="payment-method-preview card">
                            <strong>💳 Card</strong> - Credit/Debit Cards
                        </div>
                        <div class="payment-method-preview wallet">
                            <strong>🎓 Wallet</strong> - College Student Wallet
                        </div>
                    </div>
                </div>
                
                <!-- Order Summary Box -->
                <div class="order-summary-gradient-box">
                    <p class="order-summary-desc">You're about to pay</p>
                    <p class="order-summary-amount">₹<%= String.format("%.2f", total) %></p>
                    <p class="order-summary-items"><%= cart.size() %> items in your order</p>
                </div>
                
                <!-- Action Buttons -->
                <a href="payment.jsp" class="btn btn-primary btn-block checkout-pay-btn">
                    💳 Proceed to Payment
                </a>
                <a href="cart.jsp" class="btn btn-secondary btn-block checkout-back-btn">
                    ← Back to Cart
                </a>
                
                <!-- Terms -->
                <div class="checkout-terms-box">
                    <p class="checkout-terms-text">
                        By placing this order, you agree to our terms and conditions.<br>
                        All orders are subject to availability.
                    </p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
