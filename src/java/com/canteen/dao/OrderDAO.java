package com.canteen.dao;

import com.canteen.model.OrderBean;
import com.canteen.model.OrderDetailBean;
import com.canteen.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    
    // Place new order
    public boolean placeOrder(OrderBean order) {
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Insert into orders table
            String orderSql = "INSERT INTO orders (user_id, total_amount, status) VALUES (?, ?, ?)";
            PreparedStatement orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, order.getUserId());
            orderStmt.setDouble(2, order.getTotalAmount());
            orderStmt.setString(3, "Pending");
            
            orderStmt.executeUpdate();
            
            // Get generated order_id
            ResultSet rs = orderStmt.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }
            
            // Insert order details and update stock
            String detailSql = "INSERT INTO order_details (order_id, product_id, quantity, price_at_order) VALUES (?, ?, ?, ?)";
            PreparedStatement detailStmt = conn.prepareStatement(detailSql);
            
            String stockSql = "UPDATE products SET stock_quantity = stock_quantity - ? WHERE product_id = ?";
            PreparedStatement stockStmt = conn.prepareStatement(stockSql);
            
            for (OrderDetailBean detail : order.getOrderDetails()) {
                // Insert order detail
                detailStmt.setInt(1, orderId);
                detailStmt.setInt(2, detail.getProductId());
                detailStmt.setInt(3, detail.getQuantity());
                detailStmt.setDouble(4, detail.getPriceAtOrder());
                detailStmt.executeUpdate();
                
                // Update stock
                stockStmt.setInt(1, detail.getQuantity());
                stockStmt.setInt(2, detail.getProductId());
                stockStmt.executeUpdate();
            }
            
            conn.commit(); // Commit transaction
            return true;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
            
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    // Get orders by user ID
    public List<OrderBean> getOrdersByUserId(int userId) {
        List<OrderBean> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                OrderBean order = new OrderBean();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                order.setStatus(rs.getString("status"));
                
                // Load order details
                order.setOrderDetails(getOrderDetails(order.getOrderId()));
                
                orders.add(order);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orders;
    }
    
    // Get all orders (Admin)
    public List<OrderBean> getAllOrders() {
        List<OrderBean> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY order_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                OrderBean order = new OrderBean();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                order.setStatus(rs.getString("status"));
                
                // Load order details
                order.setOrderDetails(getOrderDetails(order.getOrderId()));
                
                orders.add(order);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orders;
    }
    
    // Get order details
    private List<OrderDetailBean> getOrderDetails(int orderId) {
        List<OrderDetailBean> details = new ArrayList<>();
        String sql = "SELECT od.*, p.name FROM order_details od JOIN products p ON od.product_id = p.product_id WHERE od.order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                OrderDetailBean detail = new OrderDetailBean();
                detail.setDetailId(rs.getInt("detail_id"));
                detail.setOrderId(rs.getInt("order_id"));
                detail.setProductId(rs.getInt("product_id"));
                detail.setProductName(rs.getString("name"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setPriceAtOrder(rs.getDouble("price_at_order"));
                
                details.add(detail);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return details;
    }
    
    // Update order status (Admin)
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, orderId);
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}