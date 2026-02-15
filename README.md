# Ocean View Resort Reservation System

## Overview
This is a distributed web application for the Ocean View Resort, managing guest reservations, billing, and room availability. Built using Java EE (JSP/Servlet), MySQL, and Maven.

## Features
- **User Authentication**: Secure staff login.
- **Reservation Management**: Create, View, and Confirm reservations.
- **Billing**: Automated nightly calculation.
- **Guest Portal**: Online room booking availability.
- **Email Alerts**: Integration stub for checking confirmation emails.

## Technology Stack
- **Backend**: Java Servlets, DAO Pattern, Service Layer.
- **Frontend**: JSP, CSS3 (Glassmorphism design).
- **Database**: MySQL 8.0 (Stored Procedures, Triggers).
- **Build Tool**: Maven.
- **Testing**: JUnit 4.

## Setup Instructions
1.  **Database**:
    - Import `database.sql` into your MySQL server.
    - Update credentials in `src/main/java/com/oceanview/util/DBConnection.java`.
2.  **Build**:
    - Run `mvn clean install`.
3.  **Run**:
    - Deploy `OceanView.war` to Tomcat/Jetty.
    - Or use `mvn tomcat7:run` (if configured).

## Testing
- Run unit tests: `mvn test`

## Design & Architecture
- Follows **3-Tier Architecture** (Presentation, Logic, Data).
- **Design Patterns**: MVC, Singleton (DBConnection), DAO.
