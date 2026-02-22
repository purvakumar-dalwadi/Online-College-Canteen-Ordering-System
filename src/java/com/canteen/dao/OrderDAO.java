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
            String orderSql = "INSERT INTO orders (user_id, total_amount, status, payment_method, payment_status) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, order.getUserId());
            orderStmt.setDouble(2, order.getTotalAmount());
            orderStmt.setString(3, "Pending");
            orderStmt.setString(4, order.getPaymentMethod());
            orderStmt.setString(5, "Pending");
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
        String sql = "SELECT o.*, u.username FROM orders o JOIN users u ON o.user_id = u.user_id WHERE o.user_id = ? ORDER BY o.order_date DESC";
        
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
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setUserName(rs.getString("username"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setTransactionId(rs.getString("transaction_id"));
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
        String sql = "SELECT o.*, u.username FROM orders o JOIN users u ON o.user_id = u.user_id ORDER BY o.order_date DESC";
        
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
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setUserName(rs.getString("username"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setTransactionId(rs.getString("transaction_id"));
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

    // Update payment status, transaction ID, and payment date for an order
    public boolean updatePaymentDetails(int orderId, String paymentStatus, String transactionId, Timestamp paymentDate) {
        String sql = "UPDATE orders SET payment_status = ?, transaction_id = ?, payment_date = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, paymentStatus);
            pstmt.setString(2, transactionId);
            pstmt.setTimestamp(3, paymentDate);
            pstmt.setInt(4, orderId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update payment status for an order (legacy, still usable)
    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        String sql = "UPDATE orders SET payment_status = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, paymentStatus);
            pstmt.setInt(2, orderId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
