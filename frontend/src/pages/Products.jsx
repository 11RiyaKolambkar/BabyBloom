import React, { useState, useEffect } from 'react';
import { Link, useNavigate, useLocation } from 'react-router-dom';
import axios from 'axios';

function Products() {
    const [products, setProducts] = useState([]);
    const [searchTerm, setSearchTerm] = useState('');
    const [selectedCategory, setSelectedCategory] = useState('All');
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
        axios
            .get('http://localhost:5000/products')
            .then((response) => {
                setProducts(response.data.products);
            })
            .catch((err) => {
                console.log(err);
            });
    };

    // Handle add to cart
    const handleAddCart = (e) => {
        if (!localStorage.getItem('userToken')) {
            navigate('/login');
        } else {
            const token = localStorage.getItem('userToken');
            axios
                .post(
                    'http://localhost:5000/cart/add',
                    {
                        p_id: e.target.dataset.id,
                        qty: 1,
                    },
                    {
                        headers: {
                            Authorization: token,
                        },
                    }
                )
                .then((response) => {
                    window.alert('Item added to cart');
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
    const categories = Array.from(new Set(products.map(p => p.category)));

    // Filter products by selected category and search term
    const filteredProducts = products.filter(product =>
        (selectedCategory === 'All' || product.category === selectedCategory) &&
        (product.p_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
         product.desc.toLowerCase().includes(searchTerm.toLowerCase()))
    );

    // Product section component
    const renderSection = (title, items) => (
        <div className="container-fluid bg-light p-4 shadow mt-4">
            <h3 className="text-center">{title}</h3>
            <hr />
            <div className="row flex-jcenter">
                {items.length === 0 ? (
                    <h1 className="fw-normal">Ooops! Something went wrong.</h1>
                ) : (
                    items.map((product) => (
                        <div className="col-md-3 flex-center" key={product._id}>
                            <div className="card">
                                <img
                                    src={`http://localhost:5000${product.img[0]}`}
                                    className="card-img-top"
                                    alt={product.p_name}
                                />
                                <div className="card-body">
                                    <h5 className="card-title">{product.p_name}</h5>
                                    {/* Show category here */}
                                    <p className="card-text mb-1">
                                        <b>Category:</b> {product.category}
                                    </p>
                                    <p className="card-text">{product.desc}</p>
                                    <div className="d-flex gap-3">
                                        <Link to={`/products/${product._id}`} className="btn btn-primary">
                                            Details
                                        </Link>
                                        <button
                                            className="btn btn-warning"
                                            data-id={product._id}
                                            onClick={handleAddCart}
                                        >
                                            Add to Cart
                                        </button>
                                        {/* Removed the Order button as requested */}
                                    </div>
                                </div>
                            </div>
                        </div>
                    ))
                )}
            </div>
        </div>
    );

    return (
        <>
            {/* Search Bar */}
            <div className="container mt-4 mb-3">
                <input
                    type="text"
                    className="form-control"
                    placeholder="Search products..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                />
            </div>
            <div className="container-fluid">
                <div className="row">
                    {/* Sidebar for categories */}
                    <div className="col-md-2 mb-4">
                        <div className="list-group">
                            <button
                                className={`list-group-item list-group-item-action${selectedCategory === 'All' ? ' active' : ''}`}
                                onClick={() => setSelectedCategory('All')}
                            >
                                All
                            </button>
                            {categories.map(category => (
                                <Link
                                    to={category === 'All' ? '/products' : `/products?category=${encodeURIComponent(category)}`}
                                    className={`list-group-item list-group-item-action${selectedCategory === category ? ' active' : ''}`}
                                    key={category}
                                >
                                    {category}
                                </Link>
                            ))}
                        </div>
                    </div>
                    {/* Products */}
                    <div className="col-md-10">
                        {renderSection('Products', filteredProducts)}
                    </div>
                </div>
            </div>
        </>
    );
}

export default Products;
