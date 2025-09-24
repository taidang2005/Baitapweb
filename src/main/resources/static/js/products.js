/**
 * Products Management JavaScript with GraphQL AJAX Integration
 * Implements all CRUD operations and special features
 */

// GraphQL endpoint
const GRAPHQL_ENDPOINT = '/graphql';

// Current state
let currentProducts = [];
let currentCategories = [];

// DOM Ready
document.addEventListener('DOMContentLoaded', function() {
    loadCategories();
    loadProducts();
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
 * Load all categories for filters and dropdowns
 */
async function loadCategories() {
    const query = `
        query {
            categories {
                id
                name
                description
            }
        }
    `;

    try {
        const data = await graphqlQuery(query);
        currentCategories = data.categories || [];
        populateCategorySelects();
    } catch (error) {
        console.error('Failed to load categories:', error);
    }
}

/**
 * Load products with different sorting options
 */
async function loadProducts(sortType = 'price_asc', categoryId = null, searchTerm = null) {
    let query = '';
    let variables = {};

    switch (sortType) {
        case 'price_asc':
            // YÊU CẦU CHÍNH: Products ordered by price (low to high)
            query = `
                query {
                    productsOrderByPrice {
                        productId
                        productName
                        description
                        unitPrice
                        quantity
                        discount
                        images
                        status
                        createDate
                        categoryId
                        finalPrice
                        category {
                            id
                            name
                        }
                    }
                }
            `;
            break;
            
        case 'category_filter':
            // YÊU CẦU CHÍNH: Products by category
            query = `
                query GetProductsByCategory($categoryId: ID!) {
                    productsByCategory(categoryId: $categoryId) {
                        productId
                        productName
                        description
                        unitPrice
                        quantity
                        discount
                        images
                        status
                        createDate
                        categoryId
                        finalPrice
                        category {
                            id
                            name
                        }
                    }
                }
            `;
            variables = { categoryId: categoryId };
            break;
            
        case 'search':
            query = `
                query SearchProducts($name: String) {
                    searchProductsByName(name: $name) {
                        productId
                        productName
                        description
                        unitPrice
                        quantity
                        discount
                        images
                        status
                        createDate
                        categoryId
                        finalPrice
                        category {
                            id
                            name
                        }
                    }
                }
            `;
            variables = { name: searchTerm };
            break;
            
        case 'newest':
            query = `
                query {
                    newestProducts {
                        productId
                        productName
                        description
                        unitPrice
                        quantity
                        discount
                        images
                        status
                        createDate
                        categoryId
                        finalPrice
                        category {
                            id
                            name
                        }
                    }
                }
            `;
            break;
            
        default:
            query = `
                query {
                    products {
                        productId
                        productName
                        description
                        unitPrice
                        quantity
                        discount
                        images
                        status
                        createDate
                        categoryId
                        finalPrice
                        category {
                            id
                            name
                        }
                    }
                }
            `;
    }

    try {
        const data = await graphqlQuery(query, variables);
        
        // Get products from different query results
        let products = data.productsOrderByPrice || 
                      data.productsByCategory || 
                      data.searchProductsByName || 
                      data.newestProducts || 
                      data.products || 
                      [];

        // Apply additional sorting if needed
        if (sortType === 'price_desc') {
            products = products.sort((a, b) => b.unitPrice - a.unitPrice);
        } else if (sortType === 'name_asc') {
            products = products.sort((a, b) => a.productName.localeCompare(b.productName));
        }

        currentProducts = products;
        renderProducts(products);
    } catch (error) {
        console.error('Failed to load products:', error);
    }
}

/**
 * Render products in the grid
 */
function renderProducts(products) {
    const container = document.getElementById('productsContainer');
    
    if (!products || products.length === 0) {
        container.innerHTML = `
            <div class="col-12 text-center py-5">
                <div class="text-muted">
                    <i class="fas fa-inbox fa-3x mb-3"></i>
                    <h4>No products found</h4>
                    <p>Try adjusting your search criteria or add some products.</p>
                </div>
            </div>
        `;
        return;
    }

    container.innerHTML = products.map(product => {
        const hasDiscount = product.discount > 0;
        const finalPrice = product.finalPrice || product.unitPrice;
        const stockStatus = product.quantity <= 0 ? 'out-of-stock' : 
                           product.quantity <= 10 ? 'low-stock' : 'in-stock';
        
        return `
            <div class="col-md-6 col-lg-4 col-xl-3">
                <div class="card product-card h-100 position-relative">
                    ${hasDiscount ? `<span class="badge bg-danger discount-badge">${product.discount}% OFF</span>` : ''}
                    
                    <div class="card-img-top d-flex align-items-center justify-content-center bg-light" style="height: 200px;">
                        ${product.images ? 
                            `<img src="${product.images}" alt="${product.productName}" style="max-height: 180px; max-width: 100%; object-fit: cover;">` :
                            `<i class="fas fa-image fa-3x text-muted"></i>`
                        }
                    </div>
                    
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title text-truncate" title="${product.productName}">${product.productName}</h5>
                        <p class="card-text text-muted small mb-2">
                            <i class="fas fa-tag"></i> ${product.category ? product.category.name : 'Uncategorized'}
                        </p>
                        
                        ${product.description ? `<p class="card-text small text-muted">${product.description.substring(0, 80)}${product.description.length > 80 ? '...' : ''}</p>` : ''}
                        
                        <div class="mt-auto">
                            <div class="price-tag mb-2">
                                ${hasDiscount ? 
                                    `<span class="text-success">$${finalPrice.toFixed(2)}</span> 
                                     <span class="original-price small">$${product.unitPrice.toFixed(2)}</span>` :
                                    `<span class="text-primary">$${product.unitPrice.toFixed(2)}</span>`
                                }
                            </div>
                            
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <small class="text-muted">
                                    <i class="fas fa-cubes"></i> Stock: ${product.quantity}
                                </small>
                                <span class="badge ${stockStatus === 'out-of-stock' ? 'bg-danger' : 
                                                   stockStatus === 'low-stock' ? 'bg-warning' : 'bg-success'}">
                                    ${stockStatus === 'out-of-stock' ? 'Out of Stock' : 
                                      stockStatus === 'low-stock' ? 'Low Stock' : 'In Stock'}
                                </span>
                            </div>
                            
                            <div class="btn-group w-100" role="group">
                                <button type="button" class="btn btn-sm btn-outline-primary" onclick="editProduct(${product.productId})" title="Edit">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-danger" onclick="deleteProduct(${product.productId}, '${product.productName.replace(/'/g, "\\'")}')">
                                    <i class="fas fa-trash"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-info" onclick="toggleProductStatus(${product.productId})" title="${product.status ? 'Deactivate' : 'Activate'}">
                                    <i class="fas ${product.status ? 'fa-eye-slash' : 'fa-eye'}"></i>
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
 * Filter products based on user selection
 */
function filterProducts() {
    const categoryId = document.getElementById('categoryFilter').value;
    const sortOrder = document.getElementById('sortOrder').value;
    const searchTerm = document.getElementById('searchInput').value.trim();

    if (searchTerm) {
        loadProducts('search', null, searchTerm);
    } else if (categoryId) {
        loadProducts('category_filter', categoryId);
    } else {
        loadProducts(sortOrder);
    }
}

/**
 * Create new product
 */
async function createProduct() {
    const form = document.getElementById('addProductForm');
    const formData = new FormData(form);
    
    const mutation = `
        mutation CreateProduct($input: ProductInput!) {
            createProduct(input: $input) {
                productId
                productName
                unitPrice
                quantity
                description
                discount
                images
                categoryId
            }
        }
    `;

    const variables = {
        input: {
            productName: formData.get('productName'),
            description: formData.get('description'),
            unitPrice: parseFloat(formData.get('unitPrice')),
            quantity: parseInt(formData.get('quantity')),
            discount: formData.get('discount') ? parseFloat(formData.get('discount')) : null,
            images: formData.get('images'),
            categoryId: formData.get('categoryId'),
            userId: 1 // Default user ID - in real app, get from session
        }
    };

    try {
        await graphqlQuery(mutation, variables);
        showAlert('Product created successfully!', 'success');
        bootstrap.Modal.getInstance(document.getElementById('addProductModal')).hide();
        form.reset();
        loadProducts(); // Refresh products list
    } catch (error) {
        showAlert('Failed to create product: ' + error.message, 'danger');
    }
}

/**
 * Edit product - populate modal with existing data
 */
async function editProduct(productId) {
    const product = currentProducts.find(p => p.productId == productId);
    if (!product) {
        showAlert('Product not found', 'danger');
        return;
    }

    const form = document.getElementById('editProductForm');
    const formElements = form.elements;
    
    formElements['productId'].value = product.productId;
    formElements['productName'].value = product.productName;
    formElements['description'].value = product.description || '';
    formElements['unitPrice'].value = product.unitPrice;
    formElements['quantity'].value = product.quantity;
    formElements['discount'].value = product.discount || '';
    formElements['images'].value = product.images || '';
    formElements['categoryId'].value = product.categoryId;

    new bootstrap.Modal(document.getElementById('editProductModal')).show();
}

/**
 * Update existing product
 */
async function updateProduct() {
    const form = document.getElementById('editProductForm');
    const formData = new FormData(form);
    
    const mutation = `
        mutation UpdateProduct($id: ID!, $input: ProductUpdateInput!) {
            updateProduct(id: $id, input: $input) {
                productId
                productName
                unitPrice
                quantity
                description
                discount
                images
                categoryId
            }
        }
    `;

    const variables = {
        id: formData.get('productId'),
        input: {
            productName: formData.get('productName'),
            description: formData.get('description'),
            unitPrice: parseFloat(formData.get('unitPrice')),
            quantity: parseInt(formData.get('quantity')),
            discount: formData.get('discount') ? parseFloat(formData.get('discount')) : null,
            images: formData.get('images'),
            categoryId: formData.get('categoryId')
        }
    };

    try {
        await graphqlQuery(mutation, variables);
        showAlert('Product updated successfully!', 'success');
        bootstrap.Modal.getInstance(document.getElementById('editProductModal')).hide();
        loadProducts(); // Refresh products list
    } catch (error) {
        showAlert('Failed to update product: ' + error.message, 'danger');
    }
}

/**
 * Delete product
 */
async function deleteProduct(productId, productName) {
    if (!confirm(`Are you sure you want to delete "${productName}"?`)) {
        return;
    }

    const mutation = `
        mutation DeleteProduct($id: ID!) {
            deleteProduct(id: $id)
        }
    `;

    try {
        await graphqlQuery(mutation, { id: productId });
        showAlert('Product deleted successfully!', 'success');
        loadProducts(); // Refresh products list
    } catch (error) {
        showAlert('Failed to delete product: ' + error.message, 'danger');
    }
}

/**
 * Toggle product status (active/inactive)
 */
async function toggleProductStatus(productId) {
    const mutation = `
        mutation ToggleProductStatus($id: ID!) {
            toggleProductStatus(id: $id) {
                productId
                status
            }
        }
    `;

    try {
        await graphqlQuery(mutation, { id: productId });
        showAlert('Product status updated successfully!', 'success');
        loadProducts(); // Refresh products list
    } catch (error) {
        showAlert('Failed to update product status: ' + error.message, 'danger');
    }
}

/**
 * Populate category select dropdowns
 */
function populateCategorySelects() {
    const selects = ['categoryFilter', 'addProductForm', 'editProductForm'];
    
    selects.forEach(selectId => {
        let select;
        if (selectId.includes('Form')) {
            select = document.querySelector(`#${selectId} select[name="categoryId"]`);
        } else {
            select = document.getElementById(selectId);
        }
        
        if (select) {
            const currentValue = select.value;
            const options = select.innerHTML;
            
            // Keep existing options and add categories
            if (selectId === 'categoryFilter') {
                select.innerHTML = '<option value="">All Categories</option>';
            } else {
                select.innerHTML = '<option value="">Select Category</option>';
            }
            
            currentCategories.forEach(category => {
                const option = document.createElement('option');
                option.value = category.id;
                option.textContent = category.name;
                select.appendChild(option);
            });
            
            select.value = currentValue;
        }
    });
}

/**
 * Show/hide loading indicator
 */
function showLoading(show) {
    const loadingIndicator = document.getElementById('loadingIndicator');
    const productsContainer = document.getElementById('productsContainer');
    
    if (show) {
        loadingIndicator.style.display = 'block';
        productsContainer.style.display = 'none';
    } else {
        loadingIndicator.style.display = 'none';
        productsContainer.style.display = 'block';
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
document.getElementById('sortOrder').addEventListener('change', function() {
    const categoryId = document.getElementById('categoryFilter').value;
    const searchTerm = document.getElementById('searchInput').value.trim();
    
    if (searchTerm) {
        loadProducts('search', null, searchTerm);
    } else if (categoryId) {
        loadProducts('category_filter', categoryId);
    } else {
        loadProducts(this.value);
    }
});

document.getElementById('categoryFilter').addEventListener('change', function() {
    const searchTerm = document.getElementById('searchInput').value.trim();
    
    if (this.value) {
        loadProducts('category_filter', this.value);
    } else if (searchTerm) {
        loadProducts('search', null, searchTerm);
    } else {
        loadProducts(document.getElementById('sortOrder').value);
    }
});

document.getElementById('searchInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        filterProducts();
    }
});