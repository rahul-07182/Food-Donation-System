<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
         https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd"
         version="6.0">

    <display-name>Online Food Donation System</display-name>
    <description>Phase 2: User Registration System with MySQL Database Integration</description>

    <!-- Test Database Connection Servlet -->
    <servlet>
        <servlet-name>TestDBServlet</servlet-name>
        <servlet-class>database.TestDBServlet</servlet-class>
    </servlet>
    
    <servlet-mapping>
        <servlet-name>TestDBServlet</servlet-name>
        <url-pattern>/testdb</url-pattern>
    </servlet-mapping>

    <!-- User Registration Servlet -->
    <servlet>
        <servlet-name>RegisterServlet</servlet-name>
        <servlet-class>servlet.RegisterServlet</servlet-class>
    </servlet>
    
    <servlet-mapping>
        <servlet-name>RegisterServlet</servlet-name>
        <url-pattern>/register</url-pattern>
    </servlet-mapping>

    <!-- User Login Servlet -->
    <servlet>
        <servlet-name>LoginServlet</servlet-name>
        <servlet-class>servlet.LoginServlet</servlet-class>
    </servlet>
    
    <servlet-mapping>
        <servlet-name>LoginServlet</servlet-name>
        <url-pattern>/login</url-pattern>
    </servlet-mapping>

    <!-- User Logout Servlet -->
    <servlet>
        <servlet-name>LogoutServlet</servlet-name>
        <servlet-class>servlet.LogoutServlet</servlet-class>
    </servlet>
    
    <servlet-mapping>
        <servlet-name>LogoutServlet</servlet-name>
        <url-pattern>/logout</url-pattern>
    </servlet-mapping>

    <!-- Food Donation Servlet -->
    <servlet>
        <servlet-name>DonateServlet</servlet-name>
        <servlet-class>servlet.DonateServlet</servlet-class>
    </servlet>

    <servlet-mapping>
        <servlet-name>DonateServlet</servlet-name>
        <url-pattern>/donate</url-pattern>
    </servlet-mapping>

    <!-- Admin Login Servlet (Separate Admin Login) -->
    <servlet>
        <servlet-name>AdminLoginServlet</servlet-name>
        <servlet-class>servlet.AdminLoginServlet</servlet-class>
    </servlet>

    <servlet-mapping>
        <servlet-name>AdminLoginServlet</servlet-name>
        <url-pattern>/admin-login</url-pattern>
    </servlet-mapping>

    <!-- Admin Servlet -->
    <servlet>
        <servlet-name>AdminServlet</servlet-name>
        <servlet-class>servlet.AdminServlet</servlet-class>
    </servlet>

    <servlet-mapping>
        <servlet-name>AdminServlet</servlet-name>
        <url-pattern>/admin</url-pattern>
    </servlet-mapping>

    <!-- NGO Panel Servlet (Phase 6) -->
    <servlet>
        <servlet-name>NGOServlet</servlet-name>
        <servlet-class>servlet.NGOServlet</servlet-class>
    </servlet>

    <servlet-mapping>
        <servlet-name>NGOServlet</servlet-name>
        <url-pattern>/ngo</url-pattern>
    </servlet-mapping>

    <welcome-file-list>
        <welcome-file>index.html</welcome-file>
        <welcome-file>index.jsp</welcome-file>
    </welcome-file-list>

    <!-- Session Configuration -->
    <session-config>
        <session-timeout>30</session-timeout>
        <cookie-config>
            <http-only>true</http-only>
            <secure>false</secure>
        </cookie-config>
    </session-config>

    <!-- Error Pages -->
    <error-page>
        <error-code>404</error-code>
        <location>/error404.html</location>
    </error-page>
    
    <error-page>
        <error-code>500</error-code>
        <location>/error500.html</location>
    </error-page>

</web-app>
