# ?? BabyBloom - Full Stack E-Commerce Web Application

BabyBloom is a modern, responsive full-stack MERN (MongoDB, Express.js, React, Node.js) e-commerce web platform designed for baby care products, infant fashion, and developmental toys.

---

## ?? Key Features

### ??? **Customer Storefront**
- **Product Catalog & Categorization:** Browse baby care products across categories (`Baby Care`, `Toys`, `Boys Fashion`, `Girls Fashion`).
- **Live Search & Filtering:** Dynamic category filter pills and live search by keywords.
- **Product Details & Buy Now:** In-depth product view with high-resolution imagery, stock tracking, and 1-click **Buy Now**.
- **Interactive Shopping Cart:** Real-time quantity increment/decrement, item removal, and auto-computed GST (18%) + grand total.
- **Smooth Checkout Process:** Form for recipient details, shipping address, contact phone, and multiple payment methods (`Cash on Delivery`, `UPI`, `Card`).
- **User Account & Profile Management:** Profile customization and order tracking.

### ??? **Admin Dashboard (`/admin`)**
- **Analytics & Overview:** High-level metrics for Total Products, Total Orders, Registered Users, and Gross Sales Revenue.
- **Product Management:** Add new items with image upload (Multer), edit price/stock/details, and delete existing inventory.
- **Order Management:** View all incoming customer orders, shipping addresses, and recipient contacts.
- **User Management:** View registered users and manage user accounts.

---

## ??? Tech Stack

- **Frontend:** React 19, React Router v7, Axios, Bootstrap 5, Ionicons
- **Backend:** Node.js, Express.js (ES Modules), Mongoose, Multer, JSON Web Tokens (JWT), Bcrypt
- **Database:** MongoDB
- **Styling:** CSS3, Bootstrap 5

---

## ?? Project Structure

```
BabyBloom/
+-- Backend/
¦   +-- middleware/        # JWT Authentication & Multer upload middleware
¦   +-- models/            # Mongoose Schemas (User, Product, Cart, Order)
¦   +-- routes/            # REST API endpoints (user, product, cart, order)
¦   +-- uploads/           # Uploaded product image storage
¦   +-- index.js           # Express app entry point
¦   +-- seedProducts.js    # Database seeding utility
¦   +-- .env               # Environment configuration
¦   +-- package.json       # Backend dependencies
+-- frontend/
¦   +-- public/            # Static assets, banners, HTML template
¦   +-- src/
¦   ¦   +-- components/    # Reusable UI components (Navbar, CartItem, QuantityControl, etc.)
¦   ¦   +-- pages/         # Storefront pages (Home, Products, Cart, Order, Profile, Login)
¦   ¦   ¦   +-- admin/     # Admin pages (Dashboard, Products, Orders, Users, Profile)
¦   ¦   +-- App.jsx        # Route definitions & Authentication state
¦   ¦   +-- index.jsx      # React DOM entry point
¦   +-- package.json       # Frontend dependencies
+-- README.md
```

---

## ?? Getting Started

### Prerequisites
- [Node.js](https://nodejs.org/) (v18 or higher recommended)
- [MongoDB](https://www.mongodb.com/try/download/community) installed and running locally on port `27017`

---

### 1?? Clone the Repository
```bash
git clone https://github.com/<your-username>/BabyBloom.git
cd BabyBloom
```

---

### 2?? Backend Setup
1. Navigate to the backend directory:
   ```bash
   cd Backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Create a `.env` file in the `Backend` directory (or copy from `.env.example`):
   ```env
   JWT_SECRET=your_jwt_secret_key
   mongoSecret=mongodb://localhost:27017/babyBloom
   ```
4. *(Optional)* Seed initial products into MongoDB:
   ```bash
   node seedProducts.js
   ```
5. Start the backend server:
   ```bash
   npm start
   ```
   *Backend will run at `http://localhost:5000`.*

---

### 3?? Frontend Setup
1. In a new terminal, navigate to the frontend directory:
   ```bash
   cd ../frontend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start the React development server:
   ```bash
   npm start
   ```
   *Frontend will run at `http://localhost:3000` (or `http://localhost:3001`).*

---

## ?? Default Credentials

| Role | Email | Password | Access Level |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin@gmail.com` | `admin123` | Full access to Admin Panel (`/admin`) |
| **Customer** | `user@gmail.com` | `user123` | Standard Storefront & Shopping |

---

## ?? License
This project is open-source and available under the [ISC License](LICENSE).
