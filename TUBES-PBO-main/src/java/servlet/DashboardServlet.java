package servlet;

import model.Pengguna;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");

        if (pengguna == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = pengguna.getRole();

        if ("admin".equalsIgnoreCase(role)) {
            response.sendRedirect("dashboard_admin.jsp");
        } else {
            response.sendRedirect("dashboard_user.jsp");
        }
    }
}
