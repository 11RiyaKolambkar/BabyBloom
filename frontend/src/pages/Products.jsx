import React, { useState, useEffect } from 'react';
import { Link, useNavigate, useLocation } from 'react-router-dom';
import axios from 'axios';

function Products() {
    const [products, setProducts] = useState([]);
    const [searchTerm, setSearchTerm] = useState('');
    const [selectedCategory, setSelectedCategory] = useState('All');
    const [loading, setLoading] = useState(true);
    const navigate = useNavigate();
    const location = useLocation();

    // Read category from query string
    useEffect(() => {
        const params = new URLSearchParams(location.search);
        const categoryParam = params.get('category');
        if (categoryParam) {
            setSelectedCategory(categoryParam);
        } else {
            setSelectedCategory('All');
        }
    }, [location.search]);

    // Fetch products from backend
    const getProducts = () => {
        setLoading(true);
        axios
            .get('http://localhost:5000/products')
            .then((response) => {
                setProducts(response.data.products || []);
                setLoading(false);
            })
            .catch((err) => {
                console.log(err);
                setLoading(false);
            });
    };

    // Handle add to cart
    const handleAddCart = (e) => {
        const productId = e.currentTarget.dataset.id;
        if (!localStorage.getItem('userToken')) {
            navigate('/login');
        } else {
            const token = localStorage.getItem('userToken');
            axios
                .post(
                    'http://localhost:5000/cart/add',
                    {
                        p_id: productId,
                        qty: 1,
                    },
                    {
                        headers: {
                            Authorization: token,
                        },
                    }
                )
                .then(() => {
                    window.alert('Item added to cart!');
                })
                .catch((error) => {
                    alert(error.response?.data?.message || 'Failed to add item to cart');
                });
        }
    };

    useEffect(() => {
        getProducts();
    }, []);

    // Get unique categories from products
    const categories = ['All', ...Array.from(new Set(products.map(p => p.category).filter(Boolean)))];

    // Filter products by selected category and search term
    const filteredProducts = products.filter(product => {
        const matchesCategory = selectedCategory === 'All' || product.category === selectedCategory;
        const matchesSearch =
            (product.p_name && product.p_name.toLowerCase().includes(searchTerm.toLowerCase())) ||
            (product.desc && product.desc.toLowerCase().includes(searchTerm.toLowerCase())) ||
            (product.category && product.category.toLowerCase().includes(searchTerm.toLowerCase()));
        return matchesCategory && matchesSearch;
    });

    const handleCategoryClick = (category) => {
        setSelectedCategory(category);
        if (category === 'All') {
            navigate('/products');
        } else {
            navigate(`/products?category=${encodeURIComponent(category)}`);
        }
    };

    return (
        <div className="container-fluid py-4 px-md-5 bg-light min-vh-100">
            {/* Search and Header Section */}
            <div className="row mb-4 align-items-center">
                <div className="col-md-6 mb-3 mb-md-0">
                    <h2 className="fw-bold mb-1" style={{ color: '#0f172a' }}>
                        {selectedCategory === 'All' ? 'All Baby Products' : selectedCategory}
                    </h2>
                    <p className="text-muted mb-0">
                        {loading ? 'Loading catalog...' : `Showing ${filteredProducts.length} items`}
                    </p>
                </div>
                <div className="col-md-6">
                    <div className="input-group shadow-sm">
                        <span className="input-group-text bg-white border-end-0">
                            🔍
                        </span>
                        <input
                            type="text"
                            className="form-control border-start-0 ps-0"
                            placeholder="Search products by name, description, or category..."
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                        />
                        {searchTerm && (
                            <button
                                className="btn btn-outline-secondary"
                                type="button"
                                onClick={() => setSearchTerm('')}
                            >
                                ✕
                            </button>
                        )}
                    </div>
                </div>
            </div>

            {/* Category Filter Pills (Top Bar) */}
            <div className="category-nav-scroll mb-4 bg-white p-3 rounded-4 shadow-sm">
                {categories.map((cat) => (
                    <button
                        key={cat}
                        type="button"
                        className={`category-pill-btn ${selectedCategory === cat ? 'active' : ''}`}
                        onClick={() => handleCategoryClick(cat)}
                    >
                        {cat}
                    </button>
                ))}
            </div>

            {/* Main Products Grid Area */}
            <div className="row">
                {/* Sidebar Categories (Desktop) */}
                <div className="col-lg-3 col-xl-2 mb-4 d-none d-lg-block">
                    <div className="card border-0 shadow-sm rounded-4 sticky-top" style={{ top: '20px' }}>
                        <div className="card-header bg-white border-0 pt-3 pb-2">
                            <h6 className="fw-bold text-uppercase text-muted mb-0" style={{ fontSize: '0.8rem', letterSpacing: '0.5px' }}>
                                Categories
                            </h6>
                        </div>
                        <div className="list-group list-group-flush p-2">
                            {categories.map((cat) => {
                                const count = cat === 'All' ? products.length : products.filter(p => p.category === cat).length;
                                return (
                                    <button
                                        key={cat}
                                        type="button"
                                        className={`list-group-item list-group-item-action d-flex justify-content-between align-items-center rounded-3 mb-1 border-0 ${
                                            selectedCategory === cat ? 'bg-primary text-dark fw-bold' : ''
                                        }`}
                                        onClick={() => handleCategoryClick(cat)}
                                    >
                                        <span>{cat}</span>
                                        <span className={`badge rounded-pill ${selectedCategory === cat ? 'bg-dark text-white' : 'bg-light text-dark'}`}>
                                            {count}
                                        </span>
                                    </button>
                                );
                            })}
                        </div>
                    </div>
                </div>

                {/* Products Grid */}
                <div className="col-lg-9 col-xl-10">
                    {loading ? (
                        <div className="text-center py-5">
                            <div className="spinner-border text-primary" role="status"></div>
                            <p className="mt-3 text-muted">Loading baby products...</p>
                        </div>
                    ) : filteredProducts.length === 0 ? (
                        <div className="bg-white rounded-4 p-5 text-center shadow-sm">
                            <div style={{ fontSize: '3rem' }}>🛍️</div>
                            <h4 className="fw-bold mt-3">No products found</h4>
                            <p className="text-muted">
                                No products match your filter criteria. Try searching for something else or browse all products.
                            </p>
                            <button
                                className="btn btn-primary mt-2 px-4"
                                onClick={() => {
                                    setSelectedCategory('All');
                                    setSearchTerm('');
                                    navigate('/products');
                                }}
                            >
                                Reset Filters
                            </button>
                        </div>
                    ) : (
                        <div className="row row-cols-1 row-cols-sm-2 row-cols-md-2 row-cols-lg-3 row-cols-xl-3 g-4">
                            {filteredProducts.map((product) => {
                                const imgPath = product.img && product.img[0] ? product.img[0] : '';
                                const imgSrc = imgPath.startsWith('http') ? imgPath : `http://localhost:5000${imgPath}`;

                                return (
                                    <div className="col" key={product._id}>
                                        <div className="product-card">
                                            {/* Image Box */}
                                            <div className="product-img-wrapper">
                                                <img
                                                    src={imgSrc}
                                                    className="product-img"
                                                    alt={product.p_name}
                                                    onError={(e) => {
                                                        e.target.onerror = null;
                                                        e.target.src = '/img/banner.jpg';
                                                    }}
                                                />
                                            </div>

                                            {/* Card Body */}
                                            <div className="product-card-body">
                                                <span className="product-category-tag">
                                                    {product.category || 'BabyBloom'}
                                                </span>

                                                <h5 className="product-title" title={product.p_name}>
                                                    {product.p_name}
                                                </h5>

                                                <p className="product-desc" title={product.desc}>
                                                    {product.desc}
                                                </p>

                                                <div className="product-meta-row">
                                                    <span className="product-price">
                                                        ₹{product.price}
                                                    </span>
                                                    <span className={`product-stock-badge ${product.stock > 0 ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'}`}>
                                                        {product.stock > 0 ? `In Stock (${product.stock})` : 'Out of Stock'}
                                                    </span>
                                                </div>

                                                <div className="product-actions">
                                                    <Link
                                                        to={`/products/${product._id}`}
                                                        className="btn btn-outline-primary"
                                                    >
                                                        Details
                                                    </Link>
                                                    <button
                                                        className="btn btn-warning"
                                                        data-id={product._id}
                                                        onClick={handleAddCart}
                                                        disabled={product.stock <= 0}
                                                    >
                                                        Add to Cart
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}

export default Products;
