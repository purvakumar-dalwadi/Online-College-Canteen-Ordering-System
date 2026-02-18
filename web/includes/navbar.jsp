<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
%>
<nav class="navbar">
    <div class="nav-container">
        <a href="<%= "admin".equals(role) ? "admin_dashboard.jsp" : "menu.jsp" %>" class="nav-brand">
            🍽️ College Canteen
        </a>
        
        <div class="nav-menu">
            <% if (username != null) { %>
                <% if ("admin".equals(role)) { %>
                    <a href="admin_dashboard.jsp" class="nav-link">Dashboard</a>
                    <a href="add_item.jsp" class="nav-link">Add Item</a>
                <% } else { %>
                    <a href="menu.jsp" class="nav-link">Menu</a>
                    <a href="cart.jsp" class="nav-link">
                        🛒 Cart
                        <%
    java.util.List cartList = (java.util.List) session.getAttribute("cart");
    if (cartList != null && !cartList.isEmpty()) {
%>
    <span class="cart-badge"><%= cartList.size() %></span>
<% } %>
                    </a>
                    <a href="my_orders.jsp" class="nav-link">My Orders</a>
                <% } %>
                
                <span class="nav-user">👤 <%= username %></span>
                
                <form action="auth" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="btn btn-logout">Logout</button>
                </form>
            <% } else { %>
                <a href="login.jsp" class="nav-link">Login</a>
                <a href="register.jsp" class="nav-link">Register</a>
            <% } %>
        </div>
    </div>
</nav>