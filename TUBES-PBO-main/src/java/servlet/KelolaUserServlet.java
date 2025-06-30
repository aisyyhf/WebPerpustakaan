/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import classes.JDBC;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/KelolaUserServlet")
public class KelolaUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userID = request.getParameter("userID");

        if (userID == null || userID.isEmpty()) {
            response.sendRedirect("kelolauser.jsp?error=UserID tidak ditemukan");
            return;
        }

        try (Connection conn = JDBC.getConnection()) {
            String sql = "DELETE FROM pengguna WHERE userID = ? AND role = 'pembaca'";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, userID);

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                response.sendRedirect("kelolauser.jsp?success=Akun berhasil dihapus");
            } else {
                response.sendRedirect("kelolauser.jsp?error=Gagal menghapus akun");
            }
            stmt.close();

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("kelolauser.jsp?error=Terjadi kesalahan server");
        }
    }
}
