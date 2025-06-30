<%-- 
    Document   : editbuku
    Created on : 29 May 2025, 16.34.02
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

    String bookID = request.getParameter("bookID");
    if (bookID == null || bookID.isEmpty()) {
        response.sendRedirect("books_admin.jsp");
        return;
    }

    // Ambil data buku dari DB berdasarkan bookID
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String judul = "";
    String penulis = "";
    String penerbit = "";
    String tahun = "";
    String isbn = "";
    String jenis = "";
    String status = "";

    try {
        conn = JDBC.getConnection();
        String sql = "SELECT * FROM books WHERE bookID = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, bookID);
        rs = stmt.executeQuery();

        if (rs.next()) {
            judul = rs.getString("judul");
            penulis = rs.getString("penulis");
            penerbit = rs.getString("penerbit");
            tahun = rs.getString("tahunTerbit");
            isbn = rs.getString("isbn");
            jenis = rs.getString("jenis");
            status = rs.getString("statusKetersediaan");
        } else {
            // Kalau bookID gak ketemu, redirect ke halaman books_admin
            response.sendRedirect("books_admin.jsp");
            return;
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("books_admin.jsp?error=Terjadi kesalahan saat memuat data buku.");
        return;
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception e) {}
        if (stmt != null) try { stmt.close(); } catch(Exception e) {}
        if (conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Buku - MEINLIB</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 600px; margin: auto; }
        label { font-weight: bold; }
        .btn-primary, .btn-cancel {
            padding: 8px 16px;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
        }
        .btn-primary {
            background-color: black;
            color: white;
            border: none;
        }
        .btn-primary:hover {
            background-color: white;
            color: black;
            border: 2px solid black;
            transition: 0.3s;
        }
        .btn-cancel {
            background-color: white;
            color: black;
            border: 2px solid black;
            margin-left: 10px;
        }
        .btn-cancel:hover {
            background-color: black;
            color: white;
            transition: 0.3s;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Edit Buku</h2>
    <form action="EditServlet" method="post">
        <input type="hidden" name="bookID" value="<%= bookID %>">
        
        <div class="mb-3">
            <label for="judul">Judul</label>
            <input type="text" id="judul" name="judul" class="form-control" value="<%= judul %>" required>
        </div>

        <div class="mb-3">
            <label for="penulis">Penulis</label>
            <input type="text" id="penulis" name="penulis" class="form-control" value="<%= penulis %>" required>
        </div>

        <div class="mb-3">
            <label for="penerbit">Penerbit</label>
            <input type="text" id="penerbit" name="penerbit" class="form-control" value="<%= penerbit %>" required>
        </div>

        <div class="mb-3">
            <label for="tahun">Tahun Terbit</label>
            <input type="number" id="tahun" name="tahun" class="form-control" value="<%= tahun %>" required min="1000" max="9999">
        </div>

        <div class="mb-3">
            <label for="isbn">ISBN</label>
            <input type="text" id="isbn" name="isbn" class="form-control" value="<%= isbn %>" required>
        </div>

        <div class="mb-3">
            <label for="jenis">Jenis</label>
            <select id="jenis" name="jenis" class="form-select" required>
                <option value="ebook" <%= "ebook".equalsIgnoreCase(jenis) ? "selected" : "" %>>Ebook</option>
                <option value="fisik" <%= "fisik".equalsIgnoreCase(jenis) ? "selected" : "" %>>Fisik</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="status">Status Ketersediaan</label>
            <select id="status" name="status" class="form-select" required>
                <option value="tersedia" <%= "tersedia".equalsIgnoreCase(status) ? "selected" : "" %>>Tersedia</option>
                <option value="tidak tersedia" <%= "tidak tersedia".equalsIgnoreCase(status) ? "selected" : "" %>>Tidak Tersedia</option>
            </select>
        </div>

        <button type="submit" class="btn btn-primary">Simpan Perubahan</button>
        <a href="books_admin.jsp" class="btn btn-cancel">Batal</a>
    </form>
</div>

</body>
</html>

