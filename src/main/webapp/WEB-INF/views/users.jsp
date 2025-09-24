<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Users - GraphQL Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .user-card {
            transition: transform 0.3s ease;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .user-card:hover {
            transform: translateY(-2px);
        }
        .loading {
            display: none;
            text-align: center;
            padding: 2rem;
        }
        .user-avatar {
            width: 80px;
            height: 80px;
            object-fit: cover;
        }
        .role-badge {
            font-size: 0.75rem;
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
                        <a class="nav-link" href="/web/categories"><i class="fas fa-tags"></i> Categories</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="/web/users"><i class="fas fa-users"></i> Users</a>
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
                    <h1><i class="fas fa-users text-info"></i> User Management</h1>
                    <p class="text-muted mb-0">Manage system users and their access levels</p>
                </div>
                <div class="col-md-6 text-end">
                    <button class="btn btn-info" data-bs-toggle="modal" data-bs-target="#addUserModal">
                        <i class="fas fa-user-plus"></i> Add User
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
                            <div class="col-md-4">
                                <input type="text" class="form-control" id="searchInput" placeholder="Search users...">
                            </div>
                            <div class="col-md-3">
                                <select class="form-select" id="roleFilter">
                                    <option value="">All Roles</option>
                                    <option value="1">Admin (Role 1)</option>
                                    <option value="2">Manager (Role 2)</option>
                                    <option value="3">User (Role 3)</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <select class="form-select" id="sortOrder">
                                    <option value="username">Username A-Z</option>
                                    <option value="newest">Newest First</option>
                                    <option value="oldest">Oldest First</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button class="btn btn-outline-info w-100" onclick="filterUsers()">
                                    <i class="fas fa-search"></i> Search
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Users Section -->
    <div class="container mt-4 mb-5">
        <div class="loading" id="loadingIndicator">
            <div class="spinner-border text-info" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-3">Loading users...</p>
        </div>
        
        <div id="usersContainer" class="row g-4">
            <!-- Users will be dynamically loaded here -->
        </div>
    </div>

    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-user-plus"></i> Add New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addUserForm">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Username *</label>
                                <input type="text" class="form-control" name="username" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email *</label>
                                <input type="email" class="form-control" name="email" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Password *</label>
                                <input type="password" class="form-control" name="password" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Role *</label>
                                <select class="form-select" name="roleId" required>
                                    <option value="">Select Role</option>
                                    <option value="1">Admin</option>
                                    <option value="2">Manager</option>
                                    <option value="3">User</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Full Name</label>
                                <input type="text" class="form-control" name="fullName">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Phone</label>
                                <input type="tel" class="form-control" name="phone">
                            </div>
                            <div class="col-12">
                                <label class="form-label">Avatar URL</label>
                                <input type="url" class="form-control" name="avatar">
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-info" onclick="createUser()">
                        <i class="fas fa-save"></i> Save User
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-user-edit"></i> Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="editUserForm">
                        <input type="hidden" name="userId">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Username *</label>
                                <input type="text" class="form-control" name="username" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email *</label>
                                <input type="email" class="form-control" name="email" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Password (leave blank to keep current)</label>
                                <input type="password" class="form-control" name="password">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Role *</label>
                                <select class="form-select" name="roleId" required>
                                    <option value="">Select Role</option>
                                    <option value="1">Admin</option>
                                    <option value="2">Manager</option>
                                    <option value="3">User</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Full Name</label>
                                <input type="text" class="form-control" name="fullName">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Phone</label>
                                <input type="tel" class="form-control" name="phone">
                            </div>
                            <div class="col-12">
                                <label class="form-label">Avatar URL</label>
                                <input type="url" class="form-control" name="avatar">
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-info" onclick="updateUser()">
                        <i class="fas fa-save"></i> Update User
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        /**
         * Users Management JavaScript with GraphQL AJAX Integration
         */

        // GraphQL endpoint
        const GRAPHQL_ENDPOINT = '/graphql';

        // Current state
        let currentUsers = [];

        // DOM Ready
        document.addEventListener('DOMContentLoaded', function() {
            loadUsers();
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
         * Load users
         */
        async function loadUsers() {
            const query = `
                query {
                    users {
                        id
                        username
                        email
                        fullName
                        phone
                        avatar
                        roleId
                        createdAt
                        updatedAt
                    }
                }
            `;

            try {
                const data = await graphqlQuery(query);
                currentUsers = data.users || [];
                renderUsers(currentUsers);
            } catch (error) {
                console.error('Failed to load users:', error);
            }
        }

        /**
         * Render users in the grid
         */
        function renderUsers(users) {
            const container = document.getElementById('usersContainer');
            
            if (!users || users.length === 0) {
                container.innerHTML = `
                    <div class="col-12 text-center py-5">
                        <div class="text-muted">
                            <i class="fas fa-users fa-3x mb-3"></i>
                            <h4>No users found</h4>
                            <p>Start by creating your first user account.</p>
                        </div>
                    </div>
                `;
                return;
            }

            container.innerHTML = users.map(user => {
                const roleName = getRoleName(user.roleId);
                const roleColor = getRoleColor(user.roleId);
                
                return `
                    <div class="col-md-6 col-lg-4">
                        <div class="card user-card h-100">
                            <div class="card-body text-center">
                                <div class="mb-3">
                                    ${user.avatar ? 
                                        `<img src="${user.avatar}" alt="${user.username}" class="rounded-circle user-avatar">` :
                                        `<div class="bg-secondary rounded-circle user-avatar d-flex align-items-center justify-content-center mx-auto">
                                            <i class="fas fa-user fa-2x text-white"></i>
                                        </div>`
                                    }
                                </div>
                                
                                <h5 class="card-title">${user.fullName || user.username}</h5>
                                <p class="text-muted mb-2">@${user.username}</p>
                                
                                <div class="mb-3">
                                    <span class="badge ${roleColor} role-badge">
                                        <i class="fas fa-user-tag"></i> ${roleName}
                                    </span>
                                </div>
                                
                                <div class="text-start small text-muted mb-3">
                                    <div class="mb-1">
                                        <i class="fas fa-envelope"></i> ${user.email}
                                    </div>
                                    ${user.phone ? `
                                        <div class="mb-1">
                                            <i class="fas fa-phone"></i> ${user.phone}
                                        </div>
                                    ` : ''}
                                    <div>
                                        <i class="fas fa-calendar"></i> Joined: ${new Date(user.createdAt).toLocaleDateString()}
                                    </div>
                                </div>
                                
                                <div class="btn-group w-100" role="group">
                                    <button type="button" class="btn btn-sm btn-outline-primary" onclick="editUser(${user.id})" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-success" onclick="viewUserProducts(${user.id})" title="View Products">
                                        <i class="fas fa-box"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="deleteUser(${user.id}, '${user.username.replace(/'/g, "\\'")}')">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                `;
            }).join('');
        }

        /**
         * Get role name by ID
         */
        function getRoleName(roleId) {
            const roles = {
                1: 'Admin',
                2: 'Manager', 
                3: 'User'
            };
            return roles[roleId] || 'Unknown';
        }

        /**
         * Get role color by ID
         */
        function getRoleColor(roleId) {
            const colors = {
                1: 'bg-danger',
                2: 'bg-warning',
                3: 'bg-info'
            };
            return colors[roleId] || 'bg-secondary';
        }

        /**
         * Filter users
         */
        function filterUsers() {
            const searchTerm = document.getElementById('searchInput').value.trim().toLowerCase();
            const roleFilter = document.getElementById('roleFilter').value;
            const sortOrder = document.getElementById('sortOrder').value;

            let filteredUsers = [...currentUsers];

            // Apply search filter
            if (searchTerm) {
                filteredUsers = filteredUsers.filter(user =>
                    user.username.toLowerCase().includes(searchTerm) ||
                    user.email.toLowerCase().includes(searchTerm) ||
                    (user.fullName && user.fullName.toLowerCase().includes(searchTerm))
                );
            }

            // Apply role filter
            if (roleFilter) {
                filteredUsers = filteredUsers.filter(user => user.roleId == roleFilter);
            }

            // Apply sorting
            if (sortOrder === 'username') {
                filteredUsers.sort((a, b) => a.username.localeCompare(b.username));
            } else if (sortOrder === 'newest') {
                filteredUsers.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
            } else if (sortOrder === 'oldest') {
                filteredUsers.sort((a, b) => new Date(a.createdAt) - new Date(b.createdAt));
            }

            renderUsers(filteredUsers);
        }

        /**
         * Create new user
         */
        async function createUser() {
            const form = document.getElementById('addUserForm');
            const formData = new FormData(form);
            
            const mutation = `
                mutation CreateUser($input: UserInput!) {
                    createUser(input: $input) {
                        id
                        username
                        email
                        fullName
                        roleId
                    }
                }
            `;

            const variables = {
                input: {
                    username: formData.get('username'),
                    password: formData.get('password'),
                    email: formData.get('email'),
                    fullName: formData.get('fullName'),
                    phone: formData.get('phone'),
                    avatar: formData.get('avatar'),
                    roleId: parseInt(formData.get('roleId'))
                }
            };

            try {
                await graphqlQuery(mutation, variables);
                showAlert('User created successfully!', 'success');
                bootstrap.Modal.getInstance(document.getElementById('addUserModal')).hide();
                form.reset();
                loadUsers(); // Refresh users list
            } catch (error) {
                showAlert('Failed to create user: ' + error.message, 'danger');
            }
        }

        /**
         * Edit user - populate modal with existing data
         */
        async function editUser(userId) {
            const user = currentUsers.find(u => u.id == userId);
            if (!user) {
                showAlert('User not found', 'danger');
                return;
            }

            const form = document.getElementById('editUserForm');
            const formElements = form.elements;
            
            formElements['userId'].value = user.id;
            formElements['username'].value = user.username;
            formElements['email'].value = user.email;
            formElements['fullName'].value = user.fullName || '';
            formElements['phone'].value = user.phone || '';
            formElements['avatar'].value = user.avatar || '';
            formElements['roleId'].value = user.roleId;
            formElements['password'].value = ''; // Always empty for security

            new bootstrap.Modal(document.getElementById('editUserModal')).show();
        }

        /**
         * Update existing user
         */
        async function updateUser() {
            const form = document.getElementById('editUserForm');
            const formData = new FormData(form);
            
            const mutation = `
                mutation UpdateUser($id: ID!, $input: UserUpdateInput!) {
                    updateUser(id: $id, input: $input) {
                        id
                        username
                        email
                        fullName
                        roleId
                    }
                }
            `;

            const input = {
                username: formData.get('username'),
                email: formData.get('email'),
                fullName: formData.get('fullName'),
                phone: formData.get('phone'),
                avatar: formData.get('avatar'),
                roleId: parseInt(formData.get('roleId'))
            };

            // Only include password if provided
            const password = formData.get('password');
            if (password) {
                input.password = password;
            }

            const variables = {
                id: formData.get('userId'),
                input: input
            };

            try {
                await graphqlQuery(mutation, variables);
                showAlert('User updated successfully!', 'success');
                bootstrap.Modal.getInstance(document.getElementById('editUserModal')).hide();
                loadUsers(); // Refresh users list
            } catch (error) {
                showAlert('Failed to update user: ' + error.message, 'danger');
            }
        }

        /**
         * Delete user
         */
        async function deleteUser(userId, username) {
            if (!confirm(`Are you sure you want to delete user "${username}"?`)) {
                return;
            }

            const mutation = `
                mutation DeleteUser($id: ID!) {
                    deleteUser(id: $id)
                }
            `;

            try {
                await graphqlQuery(mutation, { id: userId });
                showAlert('User deleted successfully!', 'success');
                loadUsers(); // Refresh users list
            } catch (error) {
                showAlert('Failed to delete user: ' + error.message, 'danger');
            }
        }

        /**
         * View user's products
         */
        function viewUserProducts(userId) {
            window.open(`/web/products?user=${userId}`, '_blank');
        }

        /**
         * Show/hide loading indicator
         */
        function showLoading(show) {
            const loadingIndicator = document.getElementById('loadingIndicator');
            const usersContainer = document.getElementById('usersContainer');
            
            if (show) {
                loadingIndicator.style.display = 'block';
                usersContainer.style.display = 'none';
            } else {
                loadingIndicator.style.display = 'none';
                usersContainer.style.display = 'block';
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
                filterUsers();
            }
        });

        document.getElementById('roleFilter').addEventListener('change', function() {
            filterUsers();
        });

        document.getElementById('sortOrder').addEventListener('change', function() {
            filterUsers();
        });
    </script>
</body>
</html>