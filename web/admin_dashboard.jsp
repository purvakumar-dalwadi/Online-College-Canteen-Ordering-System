<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.canteen.model.*, com.canteen.dao.*" %>
<%
    if (session.getAttribute("user") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    ProductDAO productDAO = new ProductDAO();
    OrderDAO orderDAO = new OrderDAO();
    
    List<ProductBean> products = productDAO.getAllProducts();
    List<OrderBean> orders = orderDAO.getAllOrders();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - College Canteen</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    
    <div class="container">
        <h1 class="page-title">🔧 Admin Dashboard</h1>
        
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success">
                <%= request.getParameter("success") %>
            </div>
        <% } %>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-error">
                <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <!-- Dashboard Tabs -->
        <div class="tab-container">
            <button class="tab-button active" onclick="openTab(event, 'products')">Products Management</button>
            <button class="tab-button" onclick="openTab(event, 'orders')">Orders Management</button>
        </div>
        
        <!-- Products Tab -->
        <div id="products" class="tab-content active">
            <div class="section-header">
                <h2>Menu Items</h2>
                <a href="add_item.jsp" class="btn btn-primary">+ Add New Item</a>
            </div>
            
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (ProductBean product : products) { %>
                        <tr>
                            <td><%= product.getProductId() %></td>
                            <td><%= product.getName() %></td>
                            <td><%= product.getCategory() %></td>
                            <td>₹<%= String.format("%.2f", product.getPrice()) %></td>
                            <td>
                                <span class="<%= product.isInStock() ? "stock-available" : "stock-out" %>">
                                    <%= product.getStockQuantity() %>
                                </span>
                            </td>
                            <td>
                                <button onclick="editProduct(<%= product.getProductId() %>, '<%= product.getName() %>', '<%= product.getCategory() %>', <%= product.getPrice() %>, <%= product.getStockQuantity() %>, '<%= product.getDescription() != null ? product.getDescription().replace("'", "\\'") : "" %>')" class="btn btn-small btn-secondary">Edit</button>
                                <form action="admin" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="deleteProduct">
                                    <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                                    <button type="submit" class="btn btn-small btn-danger" onclick="return confirm('Are you sure?')">Delete</button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
        <!-- Orders Tab -->
        <div id="orders" class="tab-content">
            <h2>All Orders</h2>
            
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>User ID</th>
                        <th>Total</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (OrderBean order : orders) { %>
                        <tr>
                            <td>#<%= order.getOrderId() %></td>
                            <td><%= order.getUserId() %></td>
                            <td>₹<%= String.format("%.2f", order.getTotalAmount()) %></td>
                            <td><%= order.getOrderDate() %></td>
                            <td>
                                <span class="order-status status-<%= order.getStatus().toLowerCase() %>">
                                    <%= order.getStatus() %>
                                </span>
                            </td>
                            <td>
                                <form action="admin" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="updateOrderStatus">
                                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                    <select name="status" onchange="this.form.submit()">
                                        <option value="Pending" <%= "Pending".equals(order.getStatus()) ? "selected" : "" %>>Pending</option>
                                        <option value="Preparing" <%= "Preparing".equals(order.getStatus()) ? "selected" : "" %>>Preparing</option>
                                        <option value="Ready" <%= "Ready".equals(order.getStatus()) ? "selected" : "" %>>Ready</option>
                                        <option value="Completed" <%= "Completed".equals(order.getStatus()) ? "selected" : "" %>>Completed</option>
                                        <option value="Cancelled" <%= "Cancelled".equals(order.getStatus()) ? "selected" : "" %>>Cancelled</option>
                                    </select>
                                </form>
                                <button onclick="viewOrderDetails(<%= order.getOrderId() %>, '<%= order.getOrderDetails() %>')" class="btn btn-small">View Details</button>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Edit Product Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2>Edit Product</h2>
            <form action="admin" method="post">
                <input type="hidden" name="action" value="updateProduct">
                <input type="hidden" id="editProductId" name="productId">
                
                <div class="form-group">
                    <label>Name</label>
                    <input type="text" id="editName" name="name" required>
                </div>
                
                <div class="form-group">
                    <label>Category</label>
                    <select id="editCategory" name="category" required>
                        <option value="Breakfast">Breakfast</option>
                        <option value="Lunch">Lunch</option>
                        <option value="Snacks">Snacks</option>
                        <option value="Beverages">Beverages</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Price (₹)</label>
                    <input type="number" id="editPrice" name="price" step="0.01" required>
                </div>
                
                <div class="form-group">
                    <label>Stock Quantity</label>
                    <input type="number" id="editStock" name="stock" required>
                </div>
                
                <div class="form-group">
                    <label>Description</label>
                    <textarea id="editDescription" name="description" rows="3"></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary">Update Product</button>
            </form>
        </div>
    </div>
    
    <script>
        function openTab(evt, tabName) {
            var i, tabcontent, tabbuttons;
            
            tabcontent = document.getElementsByClassName("tab-content");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].classList.remove("active");
            }
            
            tabbuttons = document.getElementsByClassName("tab-button");
            for (i = 0; i < tabbuttons.length; i++) {
                tabbuttons[i].classList.remove("active");
            }
            
            document.getElementById(tabName).classList.add("active");
            evt.currentTarget.classList.add("active");
        }
        
        function editProduct(id, name, category, price, stock, description) {
            document.getElementById('editProductId').value = id;
            document.getElementById('editName').value = name;
            document.getElementById('editCategory').value = category;
            document.getElementById('editPrice').value = price;
            document.getElementById('editStock').value = stock;
            document.getElementById('editDescription').value = description;
            document.getElementById('editModal').style.display = "block";
        }
        
        function closeModal() {
            document.getElementById('editModal').style.display = "none";
        }
        
        function viewOrderDetails(orderId, details) {
            alert("Order #" + orderId + " details:\n" + details);
        }
        
        window.onclick = function(event) {
            var modal = document.getElementById('editModal');
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>
</body>
</html>