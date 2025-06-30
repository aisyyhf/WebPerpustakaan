<%-- 
    Document   : kelolauser
    Created on : 29 May 2025, 17.01.51
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="classes.JDBC" %>
<%@ page import="model.Pengguna" %>

<%
    // Cek session dan role admin
    if (session == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");
    if (pengguna == null || !"admin".equalsIgnoreCase(pengguna.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = JDBC.getConnection();

    String sql = "SELECT userID, nama, email FROM pengguna WHERE role = 'pembaca'";
    PreparedStatement ps = conn.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Kelola User - MEINLIB</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #aaa;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f0f0f0;
        }
        .btn-delete {
            background-color: white;
            border: 2px solid black;
            color: black;
            padding: 6px 12px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: 0.3s;
        }
        .btn-delete:hover {
            background-color: black;
            color: white;
        }
    </style>
</head>
<body>

<h2>Kelola User Pembaca</h2>
<a href="dashboard_admin.jsp" class="btn btn-secondary mb-3">⬅ Kembali ke Dashboard</a>

<table>
    <thead>
        <tr>
            <th>Nama</th>
            <th>Email</th>
            <th>Aksi</th>
        </tr>
    </thead>
    <tbody>
    <%
        boolean adaUser = false;
        while (rs.next()) {
            adaUser = true;
            String userID = rs.getString("userID");
            String namaUser = rs.getString("nama");
            String emailUser = rs.getString("email");
    %>
        <tr>
            <td><%= namaUser %></td>
            <td><%= emailUser %></td>
            <td>
                <form action="KelolaUserServlet" method="post" onsubmit="return confirm('Yakin ingin menghapus akun ini?');" style="margin:0;">
                    <input type="hidden" name="userID" value="<%= userID %>">
                    <button type="submit" class="btn-delete">Hapus Akun</button>
                </form>
            </td>
        </tr>
    <% } 
        if (!adaUser) { %>
        <tr>
            <td colspan="3" style="text-align:center;">Tidak ada user pembaca.</td>
        </tr>
    <% } %>
    </tbody>
</table>

</body>
</html>

<%
    rs.close();
    ps.close();
    conn.close();
%>

