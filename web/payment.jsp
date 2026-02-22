<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.canteen.model.*" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<CartItemBean> cart = (List<CartItemBean>) session.getAttribute("cart");
    
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("cart.jsp");
        return;
    }
    
    double total = 0;
    for (CartItemBean item : cart) {
        total += item.getSubtotal();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - College Canteen</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    
    <div class="container">
        <h1 class="page-title">💳 Payment</h1>
        
        <div class="checkout-container">
            <!-- Order Summary -->
            <div class="order-summary-box">
                <h2>📋 Order Summary</h2>
                <table class="summary-table">
                    <% for (CartItemBean item : cart) { %>
                        <tr>
                            <td><%= item.getProduct().getName() %> × <%= item.getQuantity() %></td>
                            <td style="text-align: right;">₹<%= String.format("%.2f", item.getSubtotal()) %></td>
                        </tr>
                    <% } %>
                    <tr class="total-row">
                        <td><strong>Total Amount</strong></td>
                        <td style="text-align: right;"><strong>₹<%= String.format("%.2f", total) %></strong></td>
                    </tr>
                </table>
            </div>
            
            <!-- Payment Methods -->
            <div class="payment-section">
                <h2>💰 Select Payment Method</h2>
                
                <form action="order" method="post" id="paymentForm">
                    <input type="hidden" name="action" value="place">
                    <input type="hidden" name="paymentMethod" id="selectedPaymentMethod" required>
                    
                    <div class="payment-methods">
                        <!-- Cash on Pickup -->
                        <div class="payment-method-card" onclick="selectPayment('Cash on Pickup', 'cash')">
                            <input type="radio" name="payment" id="cash" value="Cash on Pickup">
                            <div class="payment-icon">💵</div>
                            <h3>Cash on Pickup</h3>
                            <p>Pay when you collect</p>
                        </div>
                        
                        <!-- UPI -->
                        <div class="payment-method-card" onclick="selectPayment('UPI', 'upi')">
                            <input type="radio" name="payment" id="upi" value="UPI">
                            <div class="payment-icon">📱</div>
                            <h3>UPI</h3>
                            <p>GooglePay, PhonePe, Paytm</p>
                        </div>
                        
                        <!-- Credit Card -->
                        <div class="payment-method-card" onclick="selectPayment('Credit Card', 'card')">
                            <input type="radio" name="payment" id="card" value="Credit Card">
                            <div class="payment-icon">💳</div>
                            <h3>Credit/Debit Card</h3>
                            <p>Visa, Mastercard, Rupay</p>
                        </div>
                        
                        <!-- College Wallet -->
                        <div class="payment-method-card" onclick="selectPayment('College Wallet', 'wallet')">
                            <input type="radio" name="payment" id="wallet" value="College Wallet">
                            <div class="payment-icon">🎓</div>
                            <h3>College Wallet</h3>
                            <p>Use your student wallet</p>
                        </div>
                    </div>
                    
                    <!-- Cash Details -->
                    <div id="cash-details" class="payment-details">
                        <h3>💵 Cash on Pickup</h3>
                        <div style="background: white; padding: 20px; border-radius: 8px; border-left: 4px solid #28a745;">
                            <p style="margin: 10px 0;"><strong>✅ Your order will be confirmed</strong></p>
                            <p style="margin: 10px 0;"><strong>💵 Pay ₹<%= String.format("%.2f", total) %></strong> when you collect your order</p>
                            <p style="margin: 10px 0;"><strong>📍 Collection Counter:</strong> Main Canteen</p>
                            <p style="margin: 10px 0;"><strong>⏰ Estimated Ready Time:</strong> 15-20 minutes</p>
                        </div>
                    </div>
                    
                    <!-- UPI Details -->
                    <div id="upi-details" class="payment-details">
                        <h3>📱 UPI Payment (Demo)</h3>
                        <p style="text-align: center; color: #666; margin-bottom: 15px;">Scan QR Code or Enter UPI ID</p>
                        <div style="text-align: center;">
                            <div class="qr-code-box">
                                <p style="font-size: 80px; margin: 0;">📱</p>
                                <p style="margin: 10px 0; font-weight: bold;">Scan with any UPI app</p>
                                <p style="background: #f0f4ff; padding: 10px; border-radius: 5px; margin: 10px 0;">
                                    <strong>UPI ID:</strong> canteen@college.upi
                                </p>
                                <p style="color: #667eea; font-size: 12px;">Mock Payment - Will auto-confirm</p>
                            </div>
                        </div>
                        <div class="form-group" style="margin-top: 20px;">
                            <label>UPI Transaction ID (Optional)</label>
                            <input type="text" class="mock-card-input" placeholder="Enter 12-digit transaction ID (Demo)">
                            <p style="font-size: 12px; color: #666; margin-top: 5px;">
                                💡 This is a demo. Any transaction ID will be accepted.
                            </p>
                        </div>
                    </div>
                    
                    <!-- Card Details -->
                    <div id="card-details" class="payment-details">
                        <h3>💳 Card Payment (Demo)</h3>
                        <p style="color: #667eea; text-align: center; margin-bottom: 15px;">
                            ℹ️ This is a mock payment. No real transaction will occur.
                        </p>
                        <div class="form-group">
                            <label>Card Number</label>
                            <input type="text" class="mock-card-input" placeholder="4532 1234 5678 9010" maxlength="19" 
                                   onkeyup="this.value=this.value.replace(/[^\d]/g,'').replace(/(.{4})/g,'$1 ').trim()">
                        </div>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                            <div class="form-group">
                                <label>Expiry Date</label>
                                <input type="text" class="mock-card-input" placeholder="MM/YY" maxlength="5"
                                       onkeyup="this.value=this.value.replace(/[^\d]/g,'').replace(/(.{2})/,'$1/').substr(0,5)">
                            </div>
                            <div class="form-group">
                                <label>CVV</label>
                                <input type="password" class="mock-card-input" placeholder="123" maxlength="3"
                                       onkeyup="this.value=this.value.replace(/[^\d]/g,'')">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Cardholder Name</label>
                            <input type="text" class="mock-card-input" placeholder="Name on card">
                        </div>
                        <p style="background: #fff3cd; padding: 10px; border-radius: 5px; font-size: 14px; margin-top: 10px;">
                            <strong>Demo Mode:</strong> Any card details will be accepted. No real charge will be made.
                        </p>
                    </div>
                    
                    <!-- Wallet Details -->
                    <div id="wallet-details" class="payment-details">
                        <h3>🎓 College Wallet (Demo)</h3>
                        <div class="wallet-balance">
                            <p style="font-size: 14px; margin: 0;">Available Balance</p>
                            <p style="font-size: 36px; font-weight: bold; margin: 10px 0;">₹500.00</p>
                        </div>
                        <div style="background: white; padding: 15px; border-radius: 8px;">
                            <p style="margin: 10px 0;">Amount to be deducted: <strong>₹<%= String.format("%.2f", total) %></strong></p>
                            <% if (total > 500) { %>
                                <p style="color: #dc3545; background: #f8d7da; padding: 10px; border-radius: 5px; margin: 10px 0;">
                                    ⚠️ Insufficient balance! Please choose another payment method.
                                </p>
                            <% } else { %>
                                <p style="color: #28a745; background: #d4edda; padding: 10px; border-radius: 5px; margin: 10px 0;">
                                    ✅ Sufficient balance available
                                </p>
                                <p style="color: #666; font-size: 12px; margin: 10px 0;">
                                    💡 This is a demo wallet. In production, this would connect to your student account.
                                </p>
                            <% } %>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-block" id="payButton" disabled style="margin-top: 20px;">
                        <span id="buttonText">Select a Payment Method</span>
                    </button>
                </form>
                
                <a href="checkout.jsp" class="btn btn-secondary btn-block" style="margin-top: 10px;">
                    ← Back to Checkout
                </a>
            </div>
        </div>
    </div>
    
    <script>
        function selectPayment(method, id) {
            // Remove all selected classes
            document.querySelectorAll('.payment-method-card').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Add selected class to clicked card
            event.currentTarget.classList.add('selected');
            
            // Set hidden input value
            document.getElementById('selectedPaymentMethod').value = method;
            
            // Hide all payment details
            document.querySelectorAll('.payment-details').forEach(detail => {
                detail.classList.remove('active');
            });
            
            // Show selected payment details
            document.getElementById(id + '-details').classList.add('active');
            
            // Enable and update pay button
            const payButton = document.getElementById('payButton');
            const buttonText = document.getElementById('buttonText');
            payButton.disabled = false;
            
            if (method === 'Cash on Pickup') {
                buttonText.textContent = 'Confirm Order (Pay on Pickup)';
            } else {
                buttonText.textContent = 'Pay ₹<%= String.format("%.2f", total) %> with ' + method;
            }
        }
        
        // Mock payment processing
        document.getElementById('paymentForm').addEventListener('submit', function(e) {
            const method = document.getElementById('selectedPaymentMethod').value;
            
            if (method === 'UPI' || method === 'Credit Card' || method === 'College Wallet') {
                // Show processing message for demo
                const confirmed = confirm(
                    '🎭 DEMO MODE\n\n' +
                    'This is a mock payment system for demonstration.\n' +
                    'No real transaction will occur.\n\n' +
                    'Payment Method: ' + method + '\n' +
                    'Amount: ₹<%= String.format("%.2f", total) %>\n\n' +
                    'Proceed with demo payment?'
                );
                
                if (!confirmed) {
                    e.preventDefault();
                    return false;
                }
            }
        });
        
        // Auto-format card number with spaces
        function formatCardNumber(input) {
            let value = input.value.replace(/\s/g, '');
            let formattedValue = value.match(/.{1,4}/g);
            input.value = formattedValue ? formattedValue.join(' ') : value;
        }
    </script>
</body>
</html>
