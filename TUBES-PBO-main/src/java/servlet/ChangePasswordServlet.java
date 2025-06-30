/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Pengguna;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import classes.JDBC;

/**
 *
 * @author HP
 */
@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/ChangePasswordServlet"})
public class ChangePasswordServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Password baru dan konfirmasi password tidak cocok");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }
        
        try (Connection conn = JDBC.getConnection()) {
            // Verifikasi password lama
            String sql = "SELECT * FROM pengguna WHERE userID = ? AND password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, pengguna.getUserID());
            ps.setString(2, currentPassword);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // Update password
                String updateSql = "UPDATE pengguna SET password = ? WHERE userID = ?";
                PreparedStatement updatePs = conn.prepareStatement(updateSql);
                updatePs.setString(1, newPassword);
                updatePs.setString(2, pengguna.getUserID());
                updatePs.executeUpdate();
                
                // Update session
                pengguna.setPassword(newPassword);
                session.setAttribute("pengguna", pengguna);
                
                request.setAttribute("message", "Password berhasil diubah");
                request.getRequestDispatcher("change_password.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Password lama salah");
                request.getRequestDispatcher("change_password.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Gagal mengubah password");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
        }
    }
}    