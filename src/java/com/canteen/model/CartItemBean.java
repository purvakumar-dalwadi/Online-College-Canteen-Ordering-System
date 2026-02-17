package com.canteen.model;

public class CartItemBean {
    private ProductBean product;
    private int quantity;
    
    // Constructors
    public CartItemBean() {}
    
    public CartItemBean(ProductBean product, int quantity) {
        this.product = product;
        this.quantity = quantity;
    }
    
    // Getters and Setters
    public ProductBean getProduct() { return product; }
    public void setProduct(ProductBean product) { this.product = product; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    // Calculate subtotal for this cart item
    public double getSubtotal() {
        return product.getPrice() * quantity;
    }
}