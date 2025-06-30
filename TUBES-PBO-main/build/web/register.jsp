<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Daftar - MEINLIB</title>
    <!-- Bootstrap CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .register-container { margin-top: 100px; }
        .left-panel { background-color: #fff; padding: 40px; border-radius: 10px 0 0 10px; }
        .right-panel { background-color: #111; color: #fff; padding: 40px; border-radius: 0 10px 10px 0; display: flex; flex-direction: column; align-items: center; justify-content: center; }
    </style>
</head>
<body>

<div class="container register-container">
    <div class="row shadow">
        <!-- Kiri: Form -->
        <div class="col-md-6 left-panel">
            <h3 class="text-center mb-4">Daftar Akun Pembaca</h3>
            <form action="RegisterServlet" method="post">
                <div class="mb-3">
                    <label>Nama Depan</label>
                    <input type="text" name="namaDepan" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Nama Belakang</label>
                    <input type="text" name="namaBelakang" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Nomor Telepon</label>
                    <input type="text" name="noTelp" class="form-control">
                </div>
                <div class="mb-3">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Kata Sandi</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                <div class="d-grid">
                    <button type="submit" class="btn btn-dark">Daftar</button>
                </div>
            </form>

            <% String error = request.getParameter("error");
               if (error != null) {
            %>
                <div class="alert alert-danger mt-3"><%= error %></div>
            <% } %>
        </div>

        <!-- Kanan -->
        <div class="col-md-6 right-panel">
            <h1>📚 MEINLIB</h1>
            <p>Sudah punya akun?</p>
            <a href="login.jsp" class="btn btn-outline-light">Masuk Sekarang</a>
        </div>
    </div>
</div>

</body>
</html>
