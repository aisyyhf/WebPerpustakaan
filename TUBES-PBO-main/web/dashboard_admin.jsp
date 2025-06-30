<%-- 
    Document   : dashboard_admin
    Created on : 24 May 2025, 19.15.54
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Pengguna" %>

<%
    if (session == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");
    if (pengguna == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String nama = pengguna.getNama();
    String namaDepan = nama.split(" ")[0];
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Dashboard Admin - MEINLIB</title>
    <style>
        * {
            box-sizing: border-box;
        }
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #fff;
            color: #000;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            background-color: #111;
            color: white;
        }

        header h1 {
            margin: 0;
            font-weight: bold;
            font-size: 24px;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
            font-size: 16px;
        }

        .header-right span {
            font-weight: 600;
        }

        .btn-logout {
            background: none;
            border: 2px solid white;
            color: white;
            padding: 6px 15px;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
            text-decoration: none;
        }

        .btn-logout:hover {
            background-color: white;
            color: black;
        }

        main {
            padding: 30px;
        }

        .greeting {
            font-size: 22px;
            margin-bottom: 30px;
            font-weight: 600;
        }

        .dashboard-grid {
            display: flex;
            gap: 25px;
            flex-wrap: wrap;
        }

        .dashboard-card {
            flex: 1 1 280px;
            background-color: #f2f2f2;
            padding: 40px 20px;
            border-radius: 15px;
            text-align: center;
            font-weight: bold;
            font-size: 20px;
            cursor: pointer;
            color: black;
            border: 2px solid transparent;
            transition: all 0.3s ease;
            user-select: none;
        }

        .dashboard-card:hover {
            background-color: #111;
            color: white;
            border-color: #111;
        }
    </style>
</head>
<body>

<header>
    <h1>MEINLIB Admin</h1>
    <div class="header-right">
        <span>Halo, <%= namaDepan %>!</span>
        <a href="LogoutServlet" class="btn-logout">Logout</a>
    </div>
</header>

<main>
    <p class="greeting">Apa yang mau kamu lakukan hari ini?</p>

    <div class="dashboard-grid">
        <div class="dashboard-card" onclick="location.href='books_admin.jsp'">
            📚 Kelola Buku
        </div>
        <div class="dashboard-card" onclick="location.href='kelolauser.jsp'">
            👥 Kelola User
        </div>
        <div class="dashboard-card" onclick="location.href='persetujuan_peminjaman.jsp'">
            ✅ Persetujuan Peminjaman
        </div>
    </div>
</main>

</body>
</html>