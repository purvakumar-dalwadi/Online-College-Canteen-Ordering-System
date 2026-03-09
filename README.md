# Online-College-Canteen-Ordering-System

A Jakarta EE web application for managing college canteen orders, menu items, payments, and basic inventory tracking.

## Overview

This project is a classic MVC-style web application built with:

- **JSP** for the UI
- **Servlets** for request handling
- **DAO classes** for database access
- **MySQL** for persistence
- **Apache Tomcat** as the application server
- **Apache Ant / NetBeans project files** for building and deployment

The application supports student ordering flows as well as admin-side menu and order management.

## Main Features

### Student features

- User registration and login
- Browse menu items by category
- Add items to a session-based cart
- Review cart and checkout
- Choose a payment method:
  - Cash on Pickup
  - UPI (demo)
  - Credit/Debit Card (demo)
  - College Wallet (demo)
- Place orders and view order history

### Admin features

- View all products
- Add, edit, and delete menu items
- Track stock quantities
- View all customer orders
- Update order status:
  - Pending
  - Preparing
  - Ready
  - Completed
  - Cancelled

## Project Structure

```text
Online-College-Canteen-Ordering-System/
├── build.xml
├── nbproject/
├── src/
│   ├── conf/
│   │   └── MANIFEST.MF
│   └── java/
│       └── com/canteen/
│           ├── controller/
│           │   ├── AdminServlet.java
│           │   ├── AuthServlet.java
│           │   ├── CartServlet.java
│           │   └── OrderServlet.java
│           ├── dao/
│           │   ├── OrderDAO.java
│           │   ├── ProductDAO.java
│           │   └── UserDAO.java
│           ├── model/
│           │   ├── CartItemBean.java
│           │   ├── OrderBean.java
│           │   ├── OrderDetailBean.java
│           │   ├── ProductBean.java
│           │   └── UserBean.java
│           └── util/
│               └── DBConnection.java
└── web/
    ├── META-INF/
    │   └── context.xml
    ├── WEB-INF/
    │   └── web.xml
    ├── css/
    │   └── style.css
    ├── includes/
    │   └── navbar.jsp
    ├── add_item.jsp
    ├── admin_dashboard.jsp
    ├── cart.jsp
    ├── checkout.jsp
    ├── index.jsp
    ├── login.jsp
    ├── menu.jsp
    ├── my_orders.jsp
    ├── payment.jsp
    ├── register.jsp
    └── success.jsp
```

## Package Responsibilities

### `com.canteen.controller`

Servlets that handle incoming requests and coordinate between the UI and data layer.

- `AuthServlet` - login, registration, logout
- `CartServlet` - add, update, remove, and clear cart items
- `OrderServlet` - place orders
- `AdminServlet` - product management and order status updates

### `com.canteen.dao`

Database access layer.

- `UserDAO` - registration, login, username lookup
- `ProductDAO` - menu item CRUD and stock updates
- `OrderDAO` - order creation, payment updates, order history, admin order listing

### `com.canteen.model`

JavaBeans used to move data between the DAO, servlet, and JSP layers.

### `com.canteen.util`

- `DBConnection` - central MySQL JDBC connection utility

## JSP Pages

- `index.jsp` - landing page
- `login.jsp` - login form
- `register.jsp` - registration form
- `menu.jsp` - product browsing by category
- `cart.jsp` - current cart
- `checkout.jsp` - checkout review
- `payment.jsp` - payment selection and demo payment UI
- `success.jsp` - order confirmation page
- `my_orders.jsp` - logged-in user order history
- `admin_dashboard.jsp` - admin dashboard for products and orders
- `add_item.jsp` - add a new menu item
- `includes/navbar.jsp` - shared navigation bar

## Servlet Routes

Defined in `web/WEB-INF/web.xml`:

- `/auth`
- `/cart`
- `/order`
- `/admin`

The application context path is configured in `web/META-INF/context.xml` as:

```text
/Online_College_Canteen_Ordering_System
```

## Database Notes

The JDBC connection is configured in:

`src/java/com/canteen/util/DBConnection.java`

Current defaults in the repository:

- Database URL: `jdbc:mysql://localhost:3306/canteen_db`
- Username: `root`
- Password: empty string

The code expects at least these tables to exist:

- `users`
- `products`
- `orders`
- `order_details`

> Note: the repository does not currently include SQL schema or migration files, so the database must be created manually.

## Build and Run Notes

This repository is a **NetBeans Ant web project**.

Important project assumptions from the checked-in configuration:

- Tomcat is the target server
- Jakarta Servlet 6.0 descriptors are used
- `nbproject/project.properties` is configured with `j2ee.platform=10-web`
- The project currently references a local MySQL Connector/J JAR path in `nbproject/project.properties`

### Prerequisites

- JDK installed
- Apache Tomcat 10+ installed
- MySQL installed and running
- MySQL Connector/J available to the project/server

### Local setup checklist

1. Create the `canteen_db` database in MySQL.
2. Create the required tables manually.
3. Update MySQL credentials in `DBConnection.java` if needed.
4. Ensure the MySQL JDBC driver is available.
5. Open the project in NetBeans or deploy it to Tomcat as a WAR.

## Testing Status

There is currently **no automated test suite** checked into the repository:

- no `test/` sources are present
- no JUnit/TestNG tests are included

In this environment, `ant test` also fails before running any tests because the NetBeans `CopyLibs` Ant property is not configured.

## Summary

This project provides a straightforward college canteen ordering workflow with:

- student authentication
- menu browsing and cart management
- order placement with demo payment flows
- admin product and order management
- basic stock tracking through the order pipeline
