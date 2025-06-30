package servlet;

import classes.JDBC;
import model.Pengguna;
import model.Admin;
import model.Pembaca;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = JDBC.getConnection()) {
            String sql = "SELECT * FROM pengguna WHERE email = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Membuat objek Pengguna berdasarkan role
                Pengguna pengguna = null;
                String role = rs.getString("role");

                if ("admin".equals(role)) {
                    pengguna = new Admin();  // Jika role admin, buat objek Admin
                } else {
                    pengguna = new Pembaca();  // Jika role pembaca, buat objek Pembaca
                }

                // Set data pengguna
                pengguna.setUserID(rs.getString("userID"));
                pengguna.setNama(rs.getString("nama"));
                pengguna.setEmail(rs.getString("email"));
                pengguna.setRole(rs.getString("role"));
                pengguna.setPhoneNumber(rs.getString("phone_number"));


                // Menyimpan objek Pengguna di session
                HttpSession session = request.getSession();
                session.setAttribute("pengguna", pengguna);

                // Redirect ke halaman dashboard sesuai role
                if ("admin".equals(role)) {
                    response.sendRedirect("dashboard_admin.jsp");  // Redirect ke dashboard admin
                } else {
                    response.sendRedirect("dashboard_user.jsp");  // Redirect ke dashboard pembaca
                }
            } else {
                response.sendRedirect("login.jsp?error=Email atau password salah.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Terjadi kesalahan server.");
        }
    }
}
