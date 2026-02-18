<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.canteen.model.*" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    
    @SuppressWarnings("unchecked")
    List<CartItemBean> cart = (List<CartItemBean>) session.getAttribute("cart");
    
    double total = 0;
    if (cart != null) {
        for (CartItemBean item : cart) {
            total += item.getSubtotal();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - College Canteen</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    
    <div class="container">
        <h1 class="page-title">🛒 Shopping Cart</h1>
        
        <% if (cart == null || cart.isEmpty()) { %>
            <div class="empty-cart">
                <p>Your cart is empty!</p>
                <a href="menu.jsp" class="btn btn-primary">Browse Menu</a>
            </div>
        <% } else { %>
            <table class="cart-table">
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Subtotal</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (CartItemBean item : cart) { %>
                        <tr>
                            <td><%= item.getProduct().getName() %></td>
                            <td>₹<%= String.format("%.2f", item.getProduct().getPrice()) %></td>
                            <td>
                                <form action="cart" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="productId" value="<%= item.getProduct().getProductId() %>">
                                    <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1" max="<%= item.getProduct().getStockQuantity() %>" style="width:60px;">
                                    <button type="submit" class="btn btn-small">Update</button>
                                </form>
                            </td>
                            <td>₹<%= String.format("%.2f", item.getSubtotal()) %></td>
                            <td>
                                <form action="cart" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="productId" value="<%= item.getProduct().getProductId() %>">
                                    <button type="submit" class="btn btn-danger btn-small">Remove</button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="3"><strong>Total</strong></td>
                        <td><strong>₹<%= String.format("%.2f", total) %></strong></td>
                        <td></td>
                    </tr>
                </tfoot>
            </table>
            
            <div class="cart-actions">
                <form action="cart" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="clear">
                    <button type="submit" class="btn btn-secondary">Clear Cart</button>
                </form>
                <a href="menu.jsp" class="btn btn-secondary">Continue Shopping</a>
                <a href="checkout.jsp" class="btn btn-primary">Proceed to Checkout</a>
            </div>
        <% } %>
    </div>
</body>
</html>