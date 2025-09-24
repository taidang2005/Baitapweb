<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categories - GraphQL Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .category-card {
            transition: transform 0.3s ease;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .category-card:hover {
            transform: translateY(-2px);
        }
        .loading {
            display: none;
            text-align: center;
            padding: 2rem;
        }
        .category-icon {
            font-size: 2rem;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="/web/"><i class="fas fa-shopping-cart"></i> GraphQL Store</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/web/"><i class="fas fa-home"></i> Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/web/products"><i class="fas fa-box"></i> Products</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="/web/categories"><i class="fas fa-tags"></i> Categories</a>
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

    <!-- Page Header -->
    <div class="bg-light py-4">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h1><i class="fas fa-tags text-success"></i> Category Management</h1>
                    <p class="text-muted mb-0">Organize products with smart categories</p>
                </div>
                <div class="col-md-6 text-end">
                    <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                        <i class="fas fa-plus"></i> Add Category
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Filter Section -->
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <input type="text" class="form-control" id="searchInput" placeholder="Search categories...">
                            </div>
                            <div class="col-md-3">
                                <select class="form-select" id="filterType">
                                    <option value="all">All Categories</option>
                                    <option value="with_products">With Products</option>
                                    <option value="without_products">Empty Categories</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-outline-success w-100" onclick="filterCategories()">
                                    <i class="fas fa-search"></i> Search
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Categories Section -->
    <div class="container mt-4 mb-5">
        <div class="loading" id="loadingIndicator">
            <div class="spinner-border text-success" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-3">Loading categories...</p>
        </div>
        
        <div id="categoriesContainer" class="row g-4">
            <!-- Categories will be dynamically loaded here -->
        </div>
    </div>

    <!-- Add Category Modal -->
    <div class="modal fade" id="addCategoryModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-plus"></i> Add New Category</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addCategoryForm">
                        <div class="mb-3">
                            <label class="form-label">Category Name *</label>
                            <input type="text" class="form-control" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" name="description" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Icon (Font Awesome class)</label>
                            <input type="text" class="form-control" name="icon" placeholder="e.g. fas fa-laptop">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">User ID *</label>
                            <input type="number" class="form-control" name="userId" value="1" required>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-success" onclick="createCategory()">
                        <i class="fas fa-save"></i> Save Category
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Category Modal -->
    <div class="modal fade" id="editCategoryModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-edit"></i> Edit Category</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="editCategoryForm">
                        <input type="hidden" name="categoryId">
                        <div class="mb-3">
                            <label class="form-label">Category Name *</label>
                            <input type="text" class="form-control" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" name="description" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Icon (Font Awesome class)</label>
                            <input type="text" class="form-control" name="icon" placeholder="e.g. fas fa-laptop">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-success" onclick="updateCategory()">
                        <i class="fas fa-save"></i> Update Category
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        /**
         * Categories Management JavaScript with GraphQL AJAX Integration
         */

        // GraphQL endpoint
        const GRAPHQL_ENDPOINT = '/graphql';

        // Current state
        let currentCategories = [];

        // DOM Ready
        document.addEventListener('DOMContentLoaded', function() {
            loadCategories();
        });

        /**
         * GraphQL Query Helper Function
         */
        async function graphqlQuery(query, variables = {}) {
            try {
                showLoading(true);
                const response = await fetch(GRAPHQL_ENDPOINT, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        query: query,
                        variables: variables
                    })
                });

                const result = await response.json();
                
                if (result.errors) {
                    console.error('GraphQL errors:', result.errors);
                    throw new Error(result.errors[0].message);
                }
                
                return result.data;
            } catch (error) {
                console.error('GraphQL query error:', error);
                showAlert('Error: ' + error.message, 'danger');
                throw error;
            } finally {
                showLoading(false);
            }
        }

        /**
         * Load categories
         */
        async function loadCategories() {
            const query = `
                query {
                    categories {
                        id
                        name
                        description
                        icon
                        userId
                        createdAt
                        updatedAt
                        productCount
                    }
                }
            `;

            try {
                const data = await graphqlQuery(query);
                currentCategories = data.categories || [];
                renderCategories(currentCategories);
            } catch (error) {
                console.error('Failed to load categories:', error);
            }
        }

        /**
         * Render categories in the grid
         */
        function renderCategories(categories) {
            const container = document.getElementById('categoriesContainer');
            
            if (!categories || categories.length === 0) {
                container.innerHTML = `
                    <div class="col-12 text-center py-5">
                        <div class="text-muted">
                            <i class="fas fa-tags fa-3x mb-3"></i>
                            <h4>No categories found</h4>
                            <p>Start by creating your first category to organize products.</p>
                        </div>
                    </div>
                `;
                return;
            }

            const formatDate = (value) => {
                try {
                    if (!value) return 'N/A';
                    const d = new Date(value);
                    return isNaN(d.getTime()) ? 'N/A' : d.toLocaleDateString();
                } catch (_) { return 'N/A'; }
            };

            container.innerHTML = categories.map(category => {
                const iconClass = category.icon || 'fas fa-tag';
                const productCount = category.productCount || 0;
                const createdAtText = formatDate(category.createdAt);
                
                return `
                    <div class="col-md-6 col-lg-4 col-xl-3">
                        <div class="card category-card h-100">
                            <div class="card-body text-center">
                                <div class="category-icon text-success">
                                    <i class="${iconClass}"></i>
                                </div>
                                <h5 class="card-title">${category.name}</h5>
                                <p class="card-text text-muted small mb-3">
                                    ${category.description || 'No description provided'}
                                </p>
                                
                                <div class="mb-3">
                                    <span class="badge bg-success">
                                        <i class="fas fa-box"></i> ${productCount} Products
                                    </span>
                                </div>
                                
                                <div class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted">
                                        Created: ${createdAtText}
                                    </small>
                                </div>
                                
                                <div class="mt-3">
                                    <div class="btn-group w-100" role="group">
                                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="editCategory(${category.id})" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-info" onclick="viewProducts(${category.id})" title="View Products">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-danger" onclick="deleteCategory(${category.id}, '${category.name.replace(/'/g, "\\'")}')">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                `;
            }).join('');
        }

        /**
         * Filter categories
         */
        function filterCategories() {
            const searchTerm = document.getElementById('searchInput').value.trim();
            const filterType = document.getElementById('filterType').value;

            let filteredCategories = currentCategories;

            // Apply search filter
            if (searchTerm) {
                filteredCategories = filteredCategories.filter(category =>
                    category.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                    (category.description && category.description.toLowerCase().includes(searchTerm.toLowerCase()))
                );
            }

            // Apply type filter
            if (filterType === 'with_products') {
                filteredCategories = filteredCategories.filter(category => category.productCount > 0);
            } else if (filterType === 'without_products') {
                filteredCategories = filteredCategories.filter(category => category.productCount === 0);
            }

            renderCategories(filteredCategories);
        }

        /**
         * Create new category
         */
        async function createCategory() {
            const form = document.getElementById('addCategoryForm');
            const formData = new FormData(form);
            
            const mutation = `
                mutation CreateCategory($input: CategoryInput!) {
                    createCategory(input: $input) {
                        id
                        name
                        description
                        icon
                        userId
                    }
                }
            `;

            const variables = {
                input: {
                    name: formData.get('name'),
                    description: formData.get('description'),
                    userId: parseInt(formData.get('userId')),
                    icon: formData.get('icon')
                }
            };

            try {
                await graphqlQuery(mutation, variables);
                showAlert('Category created successfully!', 'success');
                bootstrap.Modal.getInstance(document.getElementById('addCategoryModal')).hide();
                form.reset();
                loadCategories(); // Refresh categories list
            } catch (error) {
                showAlert('Failed to create category: ' + error.message, 'danger');
            }
        }

        /**
         * Edit category - populate modal with existing data
         */
        async function editCategory(categoryId) {
            const category = currentCategories.find(c => c.id == categoryId);
            if (!category) {
                showAlert('Category not found', 'danger');
                return;
            }

            const form = document.getElementById('editCategoryForm');
            const formElements = form.elements;
            
            formElements['categoryId'].value = category.id;
            formElements['name'].value = category.name;
            formElements['description'].value = category.description || '';
            formElements['icon'].value = category.icon || '';

            new bootstrap.Modal(document.getElementById('editCategoryModal')).show();
        }

        /**
         * Update existing category
         */
        async function updateCategory() {
            const form = document.getElementById('editCategoryForm');
            const formData = new FormData(form);
            
            const mutation = `
                mutation UpdateCategory($id: ID!, $input: CategoryUpdateInput!) {
                    updateCategory(id: $id, input: $input) {
                        id
                        name
                        description
                        icon
                    }
                }
            `;

            const variables = {
                id: formData.get('categoryId'),
                input: {
                    name: formData.get('name'),
                    description: formData.get('description'),
                    icon: formData.get('icon')
                }
            };

            try {
                await graphqlQuery(mutation, variables);
                showAlert('Category updated successfully!', 'success');
                bootstrap.Modal.getInstance(document.getElementById('editCategoryModal')).hide();
                loadCategories(); // Refresh categories list
            } catch (error) {
                showAlert('Failed to update category: ' + error.message, 'danger');
            }
        }

        /**
         * Delete category
         */
        async function deleteCategory(categoryId, categoryName) {
            if (!confirm(`Are you sure you want to delete "${categoryName}"?`)) {
                return;
            }

            const mutation = `
                mutation DeleteCategory($id: ID!) {
                    deleteCategory(id: $id)
                }
            `;

            try {
                await graphqlQuery(mutation, { id: categoryId });
                showAlert('Category deleted successfully!', 'success');
                loadCategories(); // Refresh categories list
            } catch (error) {
                showAlert('Failed to delete category: ' + error.message, 'danger');
            }
        }

        /**
         * View products in category
         */
        function viewProducts(categoryId) {
            window.open(`/web/products?category=${categoryId}`, '_blank');
        }

        /**
         * Show/hide loading indicator
         */
        function showLoading(show) {
            const loadingIndicator = document.getElementById('loadingIndicator');
            const categoriesContainer = document.getElementById('categoriesContainer');
            
            if (show) {
                loadingIndicator.style.display = 'block';
                categoriesContainer.style.display = 'none';
            } else {
                loadingIndicator.style.display = 'none';
                categoriesContainer.style.display = 'block';
            }
        }

        /**
         * Show alert message
         */
        function showAlert(message, type = 'info') {
            // Remove existing alerts
            const existingAlerts = document.querySelectorAll('.alert-dismissible');
            existingAlerts.forEach(alert => alert.remove());
            
            const alertDiv = document.createElement('div');
            alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
            alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
            alertDiv.innerHTML = `
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            
            document.body.appendChild(alertDiv);
            
            // Auto-dismiss after 5 seconds
            setTimeout(() => {
                if (alertDiv.parentNode) {
                    alertDiv.remove();
                }
            }, 5000);
        }

        // Event Listeners
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                filterCategories();
            }
        });

        document.getElementById('filterType').addEventListener('change', function() {
            filterCategories();
        });
    </script>
</body>
</html>