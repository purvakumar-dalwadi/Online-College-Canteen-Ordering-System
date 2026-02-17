package com.canteen.dao;

import com.canteen.model.ProductBean;
import com.canteen.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    
    // Get all products
    public List<ProductBean> getAllProducts() {
        List<ProductBean> products = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY category, name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                ProductBean product = extractProductFromResultSet(rs);
                products.add(product);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return products;
    }
    
    // Get product by ID
    public ProductBean getProductById(int productId) {
        String sql = "SELECT * FROM products WHERE product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, productId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractProductFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Get products by category
    public List<ProductBean> getProductsByCategory(String category) {
        List<ProductBean> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category = ? ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, category);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ProductBean product = extractProductFromResultSet(rs);
                products.add(product);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return products;
    }
    
    // Add new product (Admin)
    public boolean addProduct(ProductBean product) {
        String sql = "INSERT INTO products (name, category, price, stock_quantity, description) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getCategory());
            pstmt.setDouble(3, product.getPrice());
            pstmt.setInt(4, product.getStockQuantity());
            pstmt.setString(5, product.getDescription());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Update product (Admin)
    public boolean updateProduct(ProductBean product) {
        String sql = "UPDATE products SET name = ?, category = ?, price = ?, stock_quantity = ?, description = ? WHERE product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getCategory());
            pstmt.setDouble(3, product.getPrice());
            pstmt.setInt(4, product.getStockQuantity());
            pstmt.setString(5, product.getDescription());
            pstmt.setInt(6, product.getProductId());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete product (Admin)
    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM products WHERE product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, productId);
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Update stock quantity
    public boolean updateStock(int productId, int quantity) {
        String sql = "UPDATE products SET stock_quantity = stock_quantity - ? WHERE product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, productId);
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Helper method to extract product from ResultSet
    private ProductBean extractProductFromResultSet(ResultSet rs) throws SQLException {
        ProductBean product = new ProductBean();
        product.setProductId(rs.getInt("product_id"));
        product.setName(rs.getString("name"));
        product.setCategory(rs.getString("category"));
        product.setPrice(rs.getDouble("price"));
        product.setStockQuantity(rs.getInt("stock_quantity"));
        product.setImageUrl(rs.getString("image_url"));
        product.setDescription(rs.getString("description"));
        return product;
    }
}