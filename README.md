# Online College Canteen Ordering System

A Jakarta EE (JSP/Servlet) web application that lets college students order meals online while admins manage menu items, inventory, and order statuses. The app uses MySQL for persistence and includes mock payment flows for demo use.

## Features
- Student registration and login with role-based access (student/admin)
- Menu browsing by category with stock visibility
- Session-based cart with quantity updates and removal
- Checkout flow with payment selection:
  - Cash on Pickup
  - UPI (demo)
  - Credit/Debit Card (demo)
  - College Wallet (demo)
- Order placement with stock decrement and concurrency safety
- Order history with payment details and status tracking
- Admin dashboard for product CRUD and order status updates

## Tech Stack
- Java (NetBeans project targets Java 25; update `javac.source`/`javac.target` if needed)
- Jakarta EE 10 (Servlets + JSP)
- Apache Tomcat 10+
- MySQL 8+ (Connector/J 9.6.0 referenced in `nbproject/project.properties`)
- HTML/CSS/JavaScript for UI

## Project Structure
```
src/java/com/canteen/controller  # Servlets (auth, cart, order, admin)
src/java/com/canteen/dao         # DAO layer (users, products, orders)
src/java/com/canteen/model       # Beans
src/java/com/canteen/util        # DB connection helper
web/                             # JSP views, CSS, static assets
web/WEB-INF/web.xml              # Servlet mappings
```

## Setup & Configuration

### Prerequisites
1. JDK 25 (or adjust `nbproject/project.properties` to your installed JDK).
2. Apache Tomcat 10+.
3. MySQL 8+ and MySQL Connector/J (the project references `mysql-connector-j-9.6.0.jar`).

### Database Setup
1. Create database: `CREATE DATABASE canteen_db;`
2. Create tables with the schema below.
3. Update credentials in `src/java/com/canteen/util/DBConnection.java`.

#### Suggested Schema
```sql
USE canteen_db;

CREATE TABLE users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  email VARCHAR(100) NOT NULL,
  role VARCHAR(20) NOT NULL
);

CREATE TABLE products (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  category VARCHAR(50) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  stock_quantity INT NOT NULL,
  image_url VARCHAR(255),
  description TEXT
);

CREATE TABLE orders (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20) NOT NULL,
  payment_method VARCHAR(50),
  payment_status VARCHAR(20),
  transaction_id VARCHAR(100),
  payment_date TIMESTAMP NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE order_details (
  detail_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  price_at_order DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### Optional Demo Data
```sql
INSERT INTO users (username, password, email, role) VALUES
('admin', 'admin123', 'admin@college.com', 'admin'),
('student', 'student123', 'student@college.com', 'student');

INSERT INTO products (name, category, price, stock_quantity, description) VALUES
('Masala Dosa', 'Breakfast', 40.00, 50, 'Crispy dosa with potato filling'),
('Veg Thali', 'Lunch', 80.00, 30, 'Daily special thali'),
('Samosa', 'Snacks', 15.00, 100, 'Classic snack'),
('Cold Coffee', 'Beverages', 35.00, 40, 'Chilled coffee with milk');
```

### Running the App
- **NetBeans (recommended)**
  1. Open the project in NetBeans.
  2. Configure Tomcat 10+ as the server.
  3. Ensure the MySQL Connector/J JAR is available on the project classpath.
  4. Run the project.

- **Ant + Manual Deploy**
  1. Build the WAR: `ant dist`
  2. Deploy `dist/Online_College_Canteen_Ordering_System.war` to Tomcat.
  3. Navigate to: `http://localhost:8080/Online_College_Canteen_Ordering_System/`

## Application Routes
- `/index.jsp` — Landing page
- `/login.jsp` & `/register.jsp` — Authentication UI
- `/menu.jsp`, `/cart.jsp`, `/checkout.jsp`, `/payment.jsp` — Ordering flow
- `/my_orders.jsp` — Order history
- `/admin_dashboard.jsp` & `/add_item.jsp` — Admin tools
- Servlet endpoints:
  - `/auth` — login/register/logout
  - `/cart` — cart operations
  - `/order` — order placement and order list
  - `/admin` — product and order management

## Notes
- Payment methods other than "Cash on Pickup" are demo flows (no real transactions).
- Inventory is updated within a transaction when placing orders (`OrderDAO.placeOrder`).

## Testing
- No automated tests are configured in this repository at the moment.
