<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - MEINLIB</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .login-container {
            margin-top: 100px;
        }
        .left-panel {
            background-color: #fff;
            padding: 40px;
            border-radius: 10px 0 0 10px;
        }
        .right-panel {
            background-color: #111;
            color: #fff;
            padding: 40px;
            border-radius: 0 10px 10px 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        .right-panel h1 {
            font-size: 40px;
        }
        .btn-dark {
            background-color: #000;
            border: none;
        }
    </style>
</head>
<body>

<div class="container login-container">
    <div class="row shadow">
        <!-- Left: Login Form -->
        <div class="col-md-6 left-panel">
            <h3 class="text-center mb-4">Masuk ke MEINLIB</h3>
            <form action="LoginServlet" method="post">
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" id="email" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Kata Sandi</label>
                    <input type="password" name="password" class="form-control" id="password" required>
                </div>
                
                <div class="d-grid">
                    <button type="submit" class="btn btn-dark">Masuk</button>
                </div>
            </form>

            <% String error = request.getParameter("error");
               if (error != null) {
            %>
                <div class="alert alert-danger mt-3"><%= error %></div>
            <% } %>
            
            <% String logout = request.getParameter("logout");
                 if ("1".equals(logout)) {
            %>
                <div class="alert alert-success mt-3">Logout berhasil. Silakan login kembali.</div>
            <% } %>
            
            <% String resetSuccess = request.getParameter("resetSuccess");
                if ("1".equals(resetSuccess)) { %>
                <div class="alert alert-success mt-3">Link reset password telah dikirim ke email Anda</div>
            <% } %>

            <% String resetError = request.getParameter("resetError");
                if (resetError != null) { %>
                <div class="alert alert-danger mt-3"><%= resetError %></div>
            <% } %>    
            
        </div>

        <!-- Right: Welcome Panel -->
        <div class="col-md-6 right-panel">
            <h1 class="mb-3">📚 MEINLIB</h1>
            <p>Belum punya akun?</p>
            <a href="register.jsp" class="btn btn-outline-light">Daftar Sekarang</a>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

