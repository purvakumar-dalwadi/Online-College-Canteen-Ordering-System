package com.canteen.controller;

import com.canteen.dao.ProductDAO;
import com.canteen.model.CartItemBean;
import com.canteen.model.ProductBean;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private ProductDAO productDAO;
    
    @Override
    public void init() {
        productDAO = new ProductDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addToCart(request, response);
        } else if ("update".equals(action)) {
            updateCart(request, response);
        } else if ("remove".equals(action)) {
            removeFromCart(request, response);
        } else if ("clear".equals(action)) {
            clearCart(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.sendRedirect("cart.jsp");
    }
    
    private void addToCart(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        
        ProductBean product = productDAO.getProductById(productId);
        
        if (product == null || !product.isInStock() || product.getStockQuantity() < quantity) {
            request.setAttribute("error", "Product not available or insufficient stock!");
            request.getRequestDispatcher("menu.jsp").forward(request, response);
            return;
        }
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<CartItemBean> cart = (List<CartItemBean>) session.getAttribute("cart");
        
        if (cart == null) {
            cart = new ArrayList<>();
        }
        
        // Check if product already in cart
        boolean found = false;
        for (CartItemBean item : cart) {
            if (item.getProduct().getProductId() == productId) {
                int newQuantity = item.getQuantity() + quantity;
                if (newQuantity <= product.getStockQuantity()) {
                    item.setQuantity(newQuantity);
                    found = true;
                }
                break;
            }
        }
        
        if (!found) {
            CartItemBean newItem = new CartItemBean(product, quantity);
            cart.add(newItem);
        }
        
        session.setAttribute("cart", cart);
        response.sendRedirect("menu.jsp?added=true");
    }
    
    private void updateCart(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<CartItemBean> cart = (List<CartItemBean>) session.getAttribute("cart");
        
        if (cart != null) {
            for (CartItemBean item : cart) {
                if (item.getProduct().getProductId() == productId) {
                    if (quantity > 0) {
                        item.setQuantity(quantity);
                    } else {
                        cart.remove(item);
                    }
                    break;
                }
            }
            session.setAttribute("cart", cart);
        }
        
        response.sendRedirect("cart.jsp");
    }
    
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int productId = Integer.parseInt(request.getParameter("productId"));
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<CartItemBean> cart = (List<CartItemBean>) session.getAttribute("cart");
        
        if (cart != null) {
            cart.removeIf(item -> item.getProduct().getProductId() == productId);
            session.setAttribute("cart", cart);
        }
        
        response.sendRedirect("cart.jsp");
    }
    
    private void clearCart(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession();
        session.removeAttribute("cart");
        response.sendRedirect("cart.jsp");
    }
}