<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>MeinLib | Selamat Datang</title>
    <!-- Bootstrap CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .hero-section {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 50px;
            background-color: #f8f9fa;
        }
        .hero-left {
            max-width: 50%;
        }
        .hero-right {
            text-align: center;
        }
        .hero-right img {
            max-width: 300px;
        }
    </style>
</head>
<body>

<div class="hero-section">
    <div class="hero-left">
        <h1 class="display-5 fw-bold">📚 Selamat Datang di <span class="text-dark">MeinLib</span></h1>
        <p class="lead">Platform perpustakaan online tempat kamu bisa meminjam buku, membuat wishlist, dan melihat review!</p>
        <div class="mt-4">
            <a href="login.jsp" class="btn btn-dark me-2">Masuk</a>
            <a href="register.jsp" class="btn btn-outline-dark">Daftar</a>
        </div>
    </div>

    <div class="hero-right">
        <!-- Ganti dengan gambar/logo -->
        <img src="https://cdn-icons-png.flaticon.com/512/29/29302.png" alt="Logo MeinLib">
        <p class="mt-3">Versi Beta - 2025</p>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
