package servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.User;

/**
 * User Logout Servlet
 * Handles logout for regular users and administrators.
 * Redirects to admin-login.jsp or login.jsp based on who logged out.
 */
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        boolean adminLogout = "admin".equals(request.getParameter("from"));

        HttpSession session = request.getSession(false);

        if (session != null) {
            User loggedInUser = (User) session.getAttribute("loggedInUser");

            if (loggedInUser != null && loggedInUser.isAdmin()) {
                adminLogout = true;
            }

            if (loggedInUser != null) {
                System.out.println("User logged out: " + loggedInUser.getEmail()
                        + " (" + loggedInUser.getUserType() + ")");
            }

            session.invalidate();
        }

        if (adminLogout) {
            response.sendRedirect("admin-login.jsp?logout=success");
        } else {
            response.sendRedirect("login.jsp?logout=success");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
