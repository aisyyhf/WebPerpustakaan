<%-- 
    Document   : wishlist
    Created on : 27 May 2025, 22.57.57
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="classes.JDBC" %>
<%@ page import="model.Pengguna" %>

<%
    // Cek session dan ambil objek pengguna
    if (session == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");
    if (pengguna == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String userID = pengguna.getUserID();

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = JDBC.getConnection();
        String sql = "SELECT w.bookID, b.judul, b.penulis, w.statusBaca " +
                     "FROM wishlist w JOIN books b ON w.bookID = b.bookID " +
                     "WHERE w.userID = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, userID);
        rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Wishlist Saya - MEINLIB</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 10px; }
        th { background-color: #eee; }
        .btn-review, .btn-baca { padding: 5px 10px; margin: 0 2px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-review { background-color: #007bff; color: white; }
        .btn-baca { background-color: #28a745; color: white; }
        .btn-disabled { background-color: #ccc; color: #666; cursor: not-allowed; }
    </style>
</head>
<body class="container mt-4">
    <h2>Wishlist Saya</h2>
    <a href="dashboard_user.jsp" class="btn btn-secondary mb-3">⬅ Kembali ke Dashboard</a>

    <table class="table table-striped">
        <thead>
            <tr>
                <th>Judul</th>
                <th>Penulis</th>
                <th>Status Baca</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
         <%
            while(rs.next()) {
                String bookID = rs.getString("bookID");
                String judul = rs.getString("judul");
                String penulis = rs.getString("penulis");
                String statusBaca = rs.getString("statusBaca");
        %>
            <tr>
                <td><%= judul %></td>
                <td><%= penulis %></td>
                <td><%= statusBaca %></td>
                <td>
                    <% if ("sudah dibaca".equals(statusBaca)) { %>
                        <!-- Tombol Review hanya tersedia jika statusBaca "sudah dibaca" -->
                        <a href="review.jsp?bookID=<%= bookID %>" class="btn btn-review">Review</a>
                    <% } else { %>
                        <button class="btn btn-disabled" disabled>Review</button>
                    <% } %>

                    <!-- Tombol Baca -->
                    <a href="baca.jsp?bookID=<%= bookID %>" class="btn btn-baca">Baca</a>
                </td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>

<%
    } catch(Exception e) {
        out.println("<div class='alert alert-danger'>Terjadi kesalahan: " + e.getMessage() + "</div>");
    } finally {
        try { if(rs != null) rs.close(); } catch(Exception e) {}
        try { if(stmt != null) stmt.close(); } catch(Exception e) {}
        try { if(conn != null) conn.close(); } catch(Exception e) {}
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

