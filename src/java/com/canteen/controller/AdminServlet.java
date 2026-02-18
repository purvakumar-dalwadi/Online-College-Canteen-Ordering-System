package com.canteen.controller;

import com.canteen.dao.OrderDAO;
import com.canteen.dao.ProductDAO;
import com.canteen.model.ProductBean;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


public class AdminServlet extends HttpServlet {
    private ProductDAO productDAO;
    private OrderDAO orderDAO;
    
    @Override
    public void init() {
        productDAO = new ProductDAO();
        orderDAO = new OrderDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "addProduct":
                addProduct(request, response);
                break;
            case "updateProduct":
                updateProduct(request, response);
                break;
            case "deleteProduct":
                deleteProduct(request, response);
                break;
            case "updateOrderStatus":
                updateOrderStatus(request, response);
                break;
            default:
                response.sendRedirect("admin_dashboard.jsp");
        }
    }
    
    private void addProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        double price = Double.parseDouble(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String description = request.getParameter("description");
        
        ProductBean product = new ProductBean();
        product.setName(name);
        product.setCategory(category);
        product.setPrice(price);
        product.setStockQuantity(stock);
        product.setDescription(description);
        
        boolean success = productDAO.addProduct(product);
        
        if (success) {
            response.sendRedirect("admin_dashboard.jsp?success=Product added successfully");
        } else {
            response.sendRedirect("add_item.jsp?error=Failed to add product");
        }
    }
    
    private void updateProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int productId = Integer.parseInt(request.getParameter("productId"));
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        double price = Double.parseDouble(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String description = request.getParameter("description");
        
        ProductBean product = new ProductBean();
        product.setProductId(productId);
        product.setName(name);
        product.setCategory(category);
        product.setPrice(price);
        product.setStockQuantity(stock);
        product.setDescription(description);
        
        boolean success = productDAO.updateProduct(product);
        
        if (success) {
            response.sendRedirect("admin_dashboard.jsp?success=Product updated successfully");
        } else {
            response.sendRedirect("admin_dashboard.jsp?error=Failed to update product");
        }
    }
    
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        int productId = Integer.parseInt(request.getParameter("productId"));
        boolean success = productDAO.deleteProduct(productId);
        
        if (success) {
            response.sendRedirect("admin_dashboard.jsp?success=Product deleted successfully");
        } else {
            response.sendRedirect("admin_dashboard.jsp?error=Failed to delete product");
        }
    }
    
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");
        
        boolean success = orderDAO.updateOrderStatus(orderId, status);
        
        if (success) {
            response.sendRedirect("admin_dashboard.jsp?success=Order status updated");
        } else {
            response.sendRedirect("admin_dashboard.jsp?error=Failed to update order");
        }
    }
}