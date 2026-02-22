package com.canteen.controller;

import com.canteen.dao.OrderDAO;
import com.canteen.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO;
    
    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("place".equals(action)) {
            placeOrder(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.sendRedirect("my_orders.jsp");
    }
    
    private void placeOrder(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        @SuppressWarnings("unchecked")
        List<CartItemBean> cart = (List<CartItemBean>) session.getAttribute("cart");
        
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }
        
        // Create order
        OrderBean order = new OrderBean();
        order.setUserId(userId);
        String paymentMethod = request.getParameter("paymentMethod");
        if (paymentMethod == null || paymentMethod.isEmpty()) {
            request.setAttribute("error", "Please select a payment method.");
            request.getRequestDispatcher("payment.jsp").forward(request, response);
            return;
        }
        order.setPaymentMethod(paymentMethod);
        
        double totalAmount = 0;
        List<OrderDetailBean> orderDetails = new ArrayList<>();
        
        for (CartItemBean cartItem : cart) {
            OrderDetailBean detail = new OrderDetailBean();
            detail.setProductId(cartItem.getProduct().getProductId());
            detail.setProductName(cartItem.getProduct().getName());
            detail.setQuantity(cartItem.getQuantity());
            detail.setPriceAtOrder(cartItem.getProduct().getPrice());
            
            orderDetails.add(detail);
            totalAmount += cartItem.getSubtotal();
        }
        
        order.setTotalAmount(totalAmount);
        order.setOrderDetails(orderDetails);
        
        boolean success = orderDAO.placeOrder(order);

        if (success) {
            // Get the latest order for this user (assuming just placed)
            List<OrderBean> userOrders = orderDAO.getOrdersByUserId(userId);
            OrderBean latestOrder = userOrders != null && !userOrders.isEmpty() ? userOrders.get(0) : null;
            int orderId = latestOrder != null ? latestOrder.getOrderId() : -1;

            String paymentStatus = "Pending";
            String transactionId = null;
            java.sql.Timestamp paymentDate = null;

            if ("Cash on Pickup".equals(paymentMethod)) {
                paymentStatus = "Pending";
                // No transactionId or paymentDate for cash at this stage
            } else {
                paymentStatus = "Completed";
                // Always generate and save a mock transaction ID for online payments
                transactionId = "TXN" + orderId + System.currentTimeMillis();
                paymentDate = new java.sql.Timestamp(System.currentTimeMillis());
            }

            // Update payment details in DB if orderId is valid
            if (orderId > 0) {
                orderDAO.updatePaymentDetails(orderId, paymentStatus, transactionId, paymentDate);
            }

            session.removeAttribute("cart");
            request.setAttribute("orderTotal", totalAmount);
            request.setAttribute("paymentMethod", paymentMethod); // Pass payment method to success.jsp
            request.setAttribute("transactionId", transactionId); // Pass transactionId to success.jsp
            request.setAttribute("paymentStatus", paymentStatus);
            request.setAttribute("paymentDate", paymentDate);
            request.getRequestDispatcher("success.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Order placement failed! Please try again.");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
}