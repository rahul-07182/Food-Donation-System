# Online-food-donation-system

A web-based **Online Food Donation System** built with Java 17, JSP, Servlet, JDBC, MySQL, and Apache Tomcat 10.

## Features

- User registration and login (Donor, NGO, Admin)
- Separate admin login panel
- Food donation management
- NGO panel and food request system
- Admin dashboard

## Tech Stack

- Java 17
- JSP & Servlet (Jakarta EE / Tomcat 10)
- MySQL
- JDBC

## Setup

1. Import `database_setup.sql` into MySQL (`food_donation_db`)
2. Update database credentials in `WEB-INF/classes/database/DBConnection.java`
3. Deploy to Tomcat 10 under `webapps/FoodDonation`
4. Compile Java classes and restart Tomcat
5. Open: `http://localhost:8080/FoodDonation/`

## Default Test Accounts

| Role  | Email                     | Password     |
|-------|---------------------------|--------------|
| Admin | admin@fooddonation.com    | admin123     |
| Donor | john@email.com            | password123  |
| NGO   | mary@email.com              | password123  |

## Author

[chetankumar-mk](https://github.com/chetankumar-mk)
