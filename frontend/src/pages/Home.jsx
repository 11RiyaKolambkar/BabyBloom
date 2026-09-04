import React, { useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import axios from 'axios';

function Home() {
    const [featuredProducts, setFeaturedProducts] = useState([]);
    const navigate = useNavigate();

    const categories = [
        { name: "Baby Care", icon: "🧴" },
        { name: "Toys & Learning", icon: "🧸" },
        { name: "Boys Fashion", icon: "👕" },
        { name: "Girls Fashion", icon: "👗" },
        { name: "Feeding & Nursing", icon: "🍼" },
        { name: "Diapering & Hygiene", icon: "🧷" },
        { name: "Bedding & Nursery", icon: "🛏️" },
        { name: "Baby Gear & Travel", icon: "🚼" }
    ];

    useEffect(() => {
        axios
            .get('http://localhost:5000/products')
            .then((res) => {
                const prods = res.data.products || [];
                setFeaturedProducts(prods.slice(0, 8)); // Top 8 featured items
            })
            .catch((err) => {
                console.log(err);
            });
    }, []);

    const handleAddCart = (productId) => {
        if (!localStorage.getItem('userToken')) {
            navigate('/login');
        } else {
            const token = localStorage.getItem('userToken');
            axios
                .post(
                    'http://localhost:5000/cart/add',
                    { p_id: productId, qty: 1 },
                    { headers: { Authorization: token } }
                )
                .then(() => {
                    window.alert('Item added to cart!');
                })
                .catch((error) => {
                    alert(error.response?.data?.message || 'Failed to add item to cart');
                });
        }
    };

    return (
        <div className="bg-light pb-5">
            {/* Multi-Category Bar */}
            <div className="container-fluid bg-white border-bottom shadow-sm py-2">
                <div className="category-nav-scroll">
                    <Link to="/products" className="category-pill-btn">
                        ✨ All Products
                    </Link>
                    {categories.map((cat) => (
                        <Link
                            key={cat.name}
                            to={`/products?category=${encodeURIComponent(cat.name)}`}
                            className="category-pill-btn"
                        >
                            <span className="me-1">{cat.icon}</span> {cat.name}
                        </Link>
                    ))}
                </div>
            </div>

            {/* Carousel Banner */}
            <div
                id="carouselExampleAutoplaying"
                className="carousel slide position-relative shadow-sm"
                data-bs-ride="carousel"
                style={{ minHeight: '400px' }}
            >
                <div className="carousel-inner">
                    <div className="carousel-item active">
                        <img src="/img/banner.jpg" className="d-block w-100" alt="BabyBloom Banner 1" style={{ maxHeight: '480px', objectFit: 'cover' }} />
                    </div>
                    <div className="carousel-item">
                        <img src="/img/banner2.jpg" className="d-block w-100" alt="BabyBloom Banner 2" style={{ maxHeight: '480px', objectFit: 'cover' }} />
                    </div>
                    <div className="carousel-item">
                        <img src="/img/banner3.jpg" className="d-block w-100" alt="BabyBloom Banner 3" style={{ maxHeight: '480px', objectFit: 'cover' }} />
                    </div>
                </div>
                {/* Shop Now Overlay Button */}
                <Link
                    to="/products"
                    className="btn btn-primary btn-lg shadow-lg position-absolute"
                    style={{
                        bottom: '10%',
                        right: '10%',
                        zIndex: 2,
                        padding: '14px 36px',
                        fontSize: '1.25rem',
                        fontWeight: '700',
                        borderRadius: '30px'
                    }}
                >
                    Shop Now ➔
                </Link>
            </div>

            {/* Trust & Value Proposition Badges */}
            <div className="container py-4">
                <div className="row g-3 text-center">
                    <div className="col-6 col-md-3">
                        <div className="bg-white p-3 rounded-4 shadow-sm h-100">
                            <div style={{ fontSize: '2rem' }}>🌿</div>
                            <h6 className="fw-bold mb-1 mt-2">100% Baby Safe</h6>
                            <p className="text-muted small mb-0">Non-toxic & certified materials</p>
                        </div>
                    </div>
                    <div className="col-6 col-md-3">
                        <div className="bg-white p-3 rounded-4 shadow-sm h-100">
                            <div style={{ fontSize: '2rem' }}>🚚</div>
                            <h6 className="fw-bold mb-1 mt-2">Fast Delivery</h6>
                            <p className="text-muted small mb-0">Dispatched within 24 hours</p>
                        </div>
                    </div>
                    <div className="col-6 col-md-3">
                        <div className="bg-white p-3 rounded-4 shadow-sm h-100">
                            <div style={{ fontSize: '2rem' }}>⭐</div>
                            <h6 className="fw-bold mb-1 mt-2">Premium Quality</h6>
                            <p className="text-muted small mb-0">Dermatologist tested</p>
                        </div>
                    </div>
                    <div className="col-6 col-md-3">
                        <div className="bg-white p-3 rounded-4 shadow-sm h-100">
                            <div style={{ fontSize: '2rem' }}>🔄</div>
                            <h6 className="fw-bold mb-1 mt-2">Easy Returns</h6>
                            <p className="text-muted small mb-0">Hassle-free 7 days return</p>
                        </div>
                    </div>
                </div>
            </div>

            {/* Featured Products Section */}
            <div className="container py-4">
                <div className="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h3 className="fw-bold mb-1" style={{ color: '#0f172a' }}>Featured & Trending</h3>
                        <p className="text-muted mb-0">Top picked essentials loved by parents</p>
                    </div>
                    <Link to="/products" className="btn btn-outline-primary rounded-pill px-3">
                        View All (23+) ➔
                    </Link>
                </div>

                <div className="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
                    {featuredProducts.map((product) => {
                        const imgPath = product.img && product.img[0] ? product.img[0] : '';
                        const imgSrc = imgPath.startsWith('http') ? imgPath : `http://localhost:5000${imgPath}`;

                        return (
                            <div className="col" key={product._id}>
                                <div className="product-card">
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
                                            <span className="product-price">₹{product.price}</span>
                                            <span className="product-stock-badge bg-success-subtle text-success">
                                                In Stock
                                            </span>
                                        </div>
                                        <div className="product-actions">
                                            <Link to={`/products/${product._id}`} className="btn btn-outline-primary">
                                                Details
                                            </Link>
                                            <button
                                                className="btn btn-warning"
                                                onClick={() => handleAddCart(product._id)}
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
            </div>
        </div>
    );
}

export default Home;

