<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Double orderTotal = (Double) request.getAttribute("orderTotal");
    String paymentMethod = (String) request.getAttribute("paymentMethod");
    String transactionId = (String) request.getAttribute("transactionId");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Success - College Canteen</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .success-box {
            background: white;
            border-radius: 15px;
            padding: 60px 40px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            max-width: 600px;
            margin: 0 auto;
        }
        
        .success-icon {
            font-size: 100px;
            margin-bottom: 20px;
            animation: scaleIn 0.5s ease-out;
        }
        
        @keyframes scaleIn {
            0% { transform: scale(0); }
            50% { transform: scale(1.2); }
            100% { transform: scale(1); }
        }
        
        .success-box h1 {
            color: #28a745;
            margin-bottom: 15px;
            font-size: 32px;
        }
        
        .order-details {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            margin: 25px 0;
            text-align: left;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
        }
        
        .detail-row:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            color: #666;
            font-weight: 500;
        }
        
        .detail-value {
            color: #333;
            font-weight: bold;
        }
        
        .payment-badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
        }
        
        .payment-completed {
            background: #d4edda;
            color: #155724;
        }
        
        .payment-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .pickup-info {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
        
        .pickup-info p {
            margin: 8px 0;
        }
        
        .transaction-id {
            background: white;
            border: 2px dashed #667eea;
            padding: 15px;
            border-radius: 8px;
            font-family: monospace;
            font-size: 18px;
            color: #667eea;
            margin: 15px 0;
        }
    </style>
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    
    <div class="container">
        <div class="success-box">
            <div class="success-icon">✅</div>
            <h1>Order Placed Successfully!</h1>
            <p style="font-size: 18px; color: #666; margin-bottom: 25px;">
                Thank you for your order. Your food is being prepared!
            </p>
            
            <!-- Order Details -->
            <div class="order-details">
                <% if (orderTotal != null) { %>
                    <div class="detail-row">
                        <span class="detail-label">💰 Total Amount</span>
                        <span class="detail-value">₹<%= String.format("%.2f", orderTotal) %></span>
                    </div>
                <% } %>
                
                <% if (paymentMethod != null) { %>
                    <div class="detail-row">
                        <span class="detail-label">💳 Payment Method</span>
                        <span class="detail-value"><%= paymentMethod %></span>
                    </div>
                <% } %>
                
                <% if (transactionId != null) { %>
                    <div class="detail-row">
                        <span class="detail-label">🔑 Transaction ID</span>
                        <span class="detail-value" style="font-size: 12px; word-break: break-all;"><%= transactionId %></span>
                    </div>
                <% } %>
                
                <div class="detail-row">
                    <span class="detail-label">📅 Date & Time</span>
                    <span class="detail-value"><%= new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new java.util.Date()) %></span>
                </div>
                
                <div class="detail-row">
                    <span class="detail-label">📊 Payment Status</span>
                    <span class="detail-value">
                        <% if ("Cash on Pickup".equals(paymentMethod)) { %>
                            <span class="payment-badge payment-pending">⏳ Pending</span>
                        <% } else { %>
                            <span class="payment-badge payment-completed">✅ Completed</span>
                        <% } %>
                    </span>
                </div>
            </div>
            
            <!-- Payment Specific Information -->
            <% if ("Cash on Pickup".equals(paymentMethod)) { %>
                <div class="pickup-info">
                    <h3 style="margin: 0 0 15px 0; font-size: 20px;">📍 Pickup Instructions</h3>
                    <p><strong>💵 Payment:</strong> Cash on Pickup</p>
                    <p><strong>💰 Amount to Pay:</strong> ₹<%= String.format("%.2f", orderTotal) %></p>
                    <p><strong>📍 Location:</strong> Main Canteen Counter</p>
                    <p><strong>⏰ Estimated Ready Time:</strong> 15-20 minutes</p>
                    <p style="font-size: 14px; margin-top: 15px; opacity: 0.9;">
                        Please show your transaction ID when collecting your order
                    </p>
                </div>
            <% } else { %>
                <div style="background: #d4edda; padding: 15px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #28a745;">
                    <p style="margin: 0; color: #155724;">
                        <strong>✅ Payment Confirmed!</strong><br>
                        Your payment has been successfully processed.
                    </p>
                </div>
                <div style="background: #cfe2ff; padding: 15px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #0d6efd;">
                    <p style="margin: 0; color: #084298;">
                        <strong>📍 Pickup Location:</strong> Main Canteen Counter<br>
                        <strong>⏰ Ready in:</strong> 15-20 minutes
                    </p>
                </div>
            <% } %>
            
            <!-- Transaction ID Display -->
            <% if (transactionId != null) { %>
                <div style="margin: 25px 0;">
                    <p style="font-size: 14px; color: #666; margin-bottom: 10px;">Save your transaction ID for reference:</p>
                    <div class="transaction-id">
                        <%= transactionId %>
                    </div>
                    <button onclick="copyTransactionId()" class="btn btn-secondary btn-small" style="margin-top: 10px;">
                        📋 Copy Transaction ID
                    </button>
                </div>
            <% } %>
            
            <!-- Next Steps -->
            <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 25px 0; text-align: left;">
                <h4 style="margin: 0 0 15px 0; color: #333;">📝 What's Next?</h4>
                <ol style="margin: 0; padding-left: 20px; color: #666;">
                    <li style="margin: 8px 0;">You'll receive a notification when your order is ready</li>
                    <li style="margin: 8px 0;">Head to the Main Canteen Counter</li>
                    <li style="margin: 8px 0;">Show your transaction ID</li>
                    <% if ("Cash on Pickup".equals(paymentMethod)) { %>
                        <li style="margin: 8px 0;">Pay ₹<%= String.format("%.2f", orderTotal) %> in cash</li>
                    <% } %>
                    <li style="margin: 8px 0;">Collect and enjoy your food! 🍽️</li>
                </ol>
            </div>
            
            <!-- Action Buttons -->
            <div class="action-buttons" style="margin-top: 30px;">
                <a href="my_orders.jsp" class="btn btn-primary">
                    📦 View My Orders
                </a>
                <a href="menu.jsp" class="btn btn-secondary">
                    🍽️ Order More Food
                </a>
            </div>
            
            <!-- Help Section -->
            <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #dee2e6;">
                <p style="font-size: 14px; color: #666; margin: 0;">
                    Need help? Contact the canteen staff or visit the help desk.
                </p>
            </div>
        </div>
    </div>
    
    <script>
        function copyTransactionId() {
            const transactionId = '<%= transactionId %>';
            
            // Create temporary textarea
            const textarea = document.createElement('textarea');
            textarea.value = transactionId;
            document.body.appendChild(textarea);
            
            // Select and copy
            textarea.select();
            document.execCommand('copy');
            
            // Remove textarea
            document.body.removeChild(textarea);
            
            // Show feedback
            alert('✅ Transaction ID copied to clipboard!\n\n' + transactionId);
        }
        
        // Auto-redirect to orders page after 10 seconds
        let countdown = 10;
        const showCountdown = false; // Set to true if you want countdown
        
        if (showCountdown) {
            const countdownInterval = setInterval(() => {
                countdown--;
                if (countdown <= 0) {
                    clearInterval(countdownInterval);
                    window.location.href = 'my_orders.jsp';
                }
            }, 1000);
        }
    </script>
</body>
</html>
