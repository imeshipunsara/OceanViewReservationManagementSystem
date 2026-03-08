# OceanView Resort Reservation System

OceanView is a comprehensive web-based reservation management system designed for resort staff and administrators to handle guest bookings, room assignments, and billing efficiently.

## 👥 User Personas

- **Administrators**: Manage system users, room inventory, and oversee all resort operations.
- **Staff (Receptionist/Manager)**: Handle day-to-day reservations, guest check-ins/check-outs, and room maintenance.
- **Guests**: Browse available room types and submit booking requests through the public portal.

---

## ✨ Key Features

### 🏢 Staff Dashboard
- **Real-time Metrics**: Overview of today's bookings, available rooms, active guests, and pending requests.
- **Quick Links**: Fast access to New Reservations, Check-ins, Check-outs, and Room Management.
- **Room Status**: Visual indicators for room availability and occupancy.

### 🛡️ Admin Panel
- **Sidebar Navigation**: Dedicated sections for User, Room, Guest, and Reservation management.
- **Role-Based Access Control**:
    - **Admins**: Full access to user management and system settings.
    - **Staff**: Operational access restricted to day-to-day tasks.
- **User Management**: Add, edit, or remove system users with secure password handling.
- **Inventory Control**: Manage room details, pricing, and category assignments.

### 📅 Guest Booking Portal
- **Visual Room Showcase**: Interactive display of room types (Standard, Deluxe, Suite) with high-quality images and descriptions.
- **Real-time Availability**: Immediate feedback on room status for selected dates.
- **Streamlined Booking**: User-friendly form for guests to submit details and preferences.

### 💰 Billing & Invoicing
- **Automated Bill Generation**: Calculates total cost based on room rate and duration of stay.
- **Extra Charges**: Ability to add miscellaneous costs to a reservation bill.
- **Payment Tracking**: Records payment methods (Cash, Card, Online) and status.

### 🔒 Security
- **Authentication Filter**: `AuthFilter` intercepts requests to ensure only authenticated users access protected resources.
- **Session Management**: Secure session handling for logged-in users.
- **Password Hashing**: User passwords are securely stored (implementation details in `UserDAO`).

---

## 🏗️ Technical Architecture

The application follows the **Model-View-Controller (MVC)** design pattern, ensuring a clean separation of concerns.

- **Frontend (View)**: Built using **JSP (JavaServer Pages)**, styled with **Bootstrap 5.3** for responsiveness, and **FontAwesome 6.4** for modern icons.
- **Controller Layer**: **Java Servlets** handle incoming HTTP requests, session management, and routing.
- **Service Layer**: Encapsulates business logic, including billing calculations and email notifications.
- **Data Access Layer (DAO)**: Interfaces with the MySQL database using JDBC to perform CRUD operations.
- **Database**: **MySQL** provides persistent storage and handles complex logic via stored procedures and triggers.

---

## 💾 Database Logic

The system leverages advanced database features to ensure data integrity and automate workflows.

### 📋 Core Tables
- `users`: Stores staff and admin credentials and roles.
- `guests`: Maintains guest contact information.
- `rooms`: Tracks room availability, types, and pricing.
- `reservations`: The central table linking guests, rooms, and stay dates.
  - **Statuses**: `Pending`, `Confirmed`, `Checked In`, `Checked Out`, `Cancelled`.
- `billing`: Manages total amounts and billing dates.
- `payments`: Records individual payment transactions linked to bills.

### ⚙️ Procedures & Functions
- **`fn_calculate_nights(check_in, check_out)`**: Automatically calculates the duration of stay using MySQL `DATEDIFF`.
- **`sp_create_reservation(guest_id, room_id, check_in, check_out)`**: A stored procedure that automates the creation of guest records and initial reservation standing.
- **`sp_confirm_reservation(reservation_id, staff_id)`**: Handles the transition from 'Pending' to 'Confirmed', calculates the final bill, and triggers notification logs.

### ⚡ Triggers
- **`before_reservation_insert`**: **CRITICAL SAFETY FEATURE**. Prevents double bookings by validating room availability against existing reservations for the selected date range before any record is inserted.

---

## 📧 Automated Communications
The system includes an **Email Service** that automatically sends booking confirmations to guests once their reservation is marked as "Confirmed" by the staff.
