<%-- 
    Document   : tambahbuku
    Created on : 29 May 2025, 16.51.23
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
%>

<!DOCTYPE html>
<html>
<head>
    <title>Tambah Buku - MEINLIB</title>
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
    <h2>Tambah Buku Baru</h2>
    <form action="TambahBukuServlet" method="post">
        <div class="mb-3">
            <label for="bookID">Book ID</label>
            <input type="text" id="bookID" name="bookID" class="form-control" required maxlength="10">
            <small class="form-text text-muted">ID unik, misal: B051 atau E051</small>
        </div>

        <div class="mb-3">
            <label for="judul">Judul</label>
            <input type="text" id="judul" name="judul" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="penulis">Penulis</label>
            <input type="text" id="penulis" name="penulis" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="penerbit">Penerbit</label>
            <input type="text" id="penerbit" name="penerbit" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="tahun">Tahun Terbit</label>
            <input type="number" id="tahun" name="tahun" class="form-control" required min="1000" max="9999">
        </div>

        <div class="mb-3">
            <label for="isbn">ISBN</label>
            <input type="text" id="isbn" name="isbn" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="jenis">Jenis Buku</label>
            <select id="jenis" name="jenis" class="form-select" required>
                <option value="">-- Pilih Jenis Buku --</option>
                <option value="ebook">Ebook</option>
                <option value="fisik">Fisik</option>
            </select>
        </div>

        <button type="submit" class="btn btn-primary">Tambah Buku</button>
        <a href="books_admin.jsp" class="btn btn-cancel">Batal</a>
    </form>
</div>

</body>
</html>

