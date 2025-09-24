<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GraphQL Product Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 100px 0;
        }
        .feature-card {
            transition: transform 0.3s ease;
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .feature-card:hover {
            transform: translateY(-5px);
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="#"><i class="fas fa-shopping-cart"></i> GraphQL Store</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="/web/"><i class="fas fa-home"></i> Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/web/products"><i class="fas fa-box"></i> Products</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/web/categories"><i class="fas fa-tags"></i> Categories</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/web/users"><i class="fas fa-users"></i> Users</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/graphiql" target="_blank"><i class="fas fa-code"></i> GraphQL</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section text-center">
        <div class="container">
            <h1 class="display-4 mb-4">GraphQL Product Management</h1>
            <p class="lead mb-4">Modern product management system built with Spring Boot 3 & GraphQL</p>
            <p class="mb-4">Manage products, categories, and users with powerful GraphQL queries and mutations</p>
            <a href="/web/products" class="btn btn-light btn-lg me-3">
                <i class="fas fa-box"></i> View Products
            </a>
            <a href="/graphiql" target="_blank" class="btn btn-outline-light btn-lg">
                <i class="fas fa-code"></i> GraphQL Explorer
            </a>
        </div>
    </section>

    <!-- Features Section -->
    <section class="py-5">
        <div class="container">
            <div class="row text-center mb-5">
                <div class="col-12">
                    <h2 class="display-5 mb-3">System Features</h2>
                    <p class="lead text-muted">Comprehensive management tools for your e-commerce platform</p>
                </div>
            </div>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card feature-card h-100 text-center p-4">
                        <div class="card-body">
                            <i class="fas fa-box fa-3x text-primary mb-3"></i>
                            <h5 class="card-title">Product Management</h5>
                            <p class="card-text">Complete CRUD operations for products with price sorting and category filtering</p>
                            <a href="/web/products" class="btn btn-primary">Manage Products</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card feature-card h-100 text-center p-4">
                        <div class="card-body">
                            <i class="fas fa-tags fa-3x text-success mb-3"></i>
                            <h5 class="card-title">Category Organization</h5>
                            <p class="card-text">Organize products with hierarchical categories and smart filtering</p>
                            <a href="/web/categories" class="btn btn-success">Manage Categories</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card feature-card h-100 text-center p-4">
                        <div class="card-body">
                            <i class="fas fa-users fa-3x text-info mb-3"></i>
                            <h5 class="card-title">User Management</h5>
                            <p class="card-text">Comprehensive user management with role-based access control</p>
                            <a href="/web/users" class="btn btn-info">Manage Users</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- GraphQL Features -->
    <section class="py-5 bg-light">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h3 class="display-6 mb-4">Powered by GraphQL</h3>
                    <div class="row g-3">
                        <div class="col-12">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-sort-amount-down text-primary me-3 fa-2x"></i>
                                <div>
                                    <h6 class="mb-1">Products by Price (Low to High)</h6>
                                    <small class="text-muted">Efficient price-based sorting</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-filter text-success me-3 fa-2x"></i>
                                <div>
                                    <h6 class="mb-1">Products by Category</h6>
                                    <small class="text-muted">Smart category-based filtering</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-edit text-warning me-3 fa-2x"></i>
                                <div>
                                    <h6 class="mb-1">Full CRUD Operations</h6>
                                    <small class="text-muted">Create, Read, Update, Delete with GraphQL</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header bg-dark text-white">
                            <i class="fas fa-code"></i> Sample GraphQL Query
                        </div>
                        <div class="card-body bg-dark text-light">
                            <pre class="mb-0"><code>query {
  productsOrderByPrice {
    productId
    productName
    unitPrice
    finalPrice
    category {
      name
    }
  }
}</code></pre>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-white py-4 text-center">
        <div class="container">
            <p>&copy; 2024 GraphQL Product Management System. Built with Spring Boot 3 & GraphQL.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>