<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.canteen.model.*, com.canteen.dao.*" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    ProductDAO productDAO = new ProductDAO();
    List<ProductBean> products = productDAO.getAllProducts();
    
    // Group products by category
    Map<String, List<ProductBean>> productsByCategory = new LinkedHashMap<>();
    for (ProductBean product : products) {
        productsByCategory.computeIfAbsent(product.getCategory(), k -> new ArrayList<>()).add(product);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu - College Canteen</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    
    <div class="container">
        <h1 class="page-title">🍽️ Our Menu</h1>
        
        <% if (request.getParameter("added") != null) { %>
            <div class="alert alert-success">
                Item added to cart successfully!
            </div>
        <% } %>
        
        <% for (Map.Entry<String, List<ProductBean>> entry : productsByCategory.entrySet()) { %>
            <div class="category-section">
                <h2 class="category-title"><%= entry.getKey() %></h2>
                
                <div class="product-grid">
                    <% for (ProductBean product : entry.getValue()) { %>
                        <div class="product-card">
                            <h3><%= product.getName() %></h3>
                            <p class="product-description"><%= product.getDescription() != null ? product.getDescription() : "" %></p>
                            <p class="product-price">₹<%= String.format("%.2f", product.getPrice()) %></p>
                            
                            <% if (product.isInStock()) { %>
                                <p class="stock-info">In Stock: <%= product.getStockQuantity() %></p>
                                <form action="cart" method="post" class="add-to-cart-form">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                                    <input type="number" name="quantity" value="1" min="1" max="<%= product.getStockQuantity() %>" required>
                                    <button type="submit" class="btn btn-primary btn-small">Add to Cart</button>
                                </form>
                            <% } else { %>
                                <p class="out-of-stock">Out of Stock</p>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            </div>
        <% } %>
    </div>
</body>
</html>