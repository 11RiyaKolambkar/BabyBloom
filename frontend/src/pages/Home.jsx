import React from 'react'
import { Link, useNavigate } from 'react-router-dom';

function Home() {
    const navigator = useNavigate();

    return (
        <>
            {/* Category Bar */}
            <div className="container-fluid bg-white py-3" style={{ display: 'flex', justifyContent: 'center', gap: '2rem' }}>
                <Link to="/products?category=Baby Care" className="btn btn-outline-primary">Baby Care</Link>
                <Link to="/products?category=Toys" className="btn btn-outline-primary">Toys</Link>
                <Link to="/products?category=Boys Fashion" className="btn btn-outline-primary">Boys Fashion</Link>
                <Link to="/products?category=Girls Fashion" className="btn btn-outline-primary">Girls Fashion</Link>
                <Link to="/products" className="btn btn-outline-primary">All Products</Link>
            </div>

            <div
                id="carouselExampleAutoplaying"
                className="carousel slide position-relative"
                data-bs-ride="carousel"
                style={{ minHeight: '400px' }}
            >
                <div className="carousel-inner">
                    <div className="carousel-item active">
                        <img src="/img/banner.jpg" className="d-block w-100" alt="banner" />
                    </div>
                    <div className="carousel-item">
                        <img src="/img/banner2.jpg" className="d-block w-100" alt="banner" />
                    </div>
                    <div className="carousel-item">
                        <img src="/img/banner3.jpg" className="d-block w-100" alt="banner" />
                    </div>
                </div>
                {/* Visible Shop Now Button Overlay */}
                <Link
                    to="/products"
                    style={{
                        position: 'absolute',
                        bottom: '6%',
                        right: '13.5%',
                        transform: 'translate(-50%, -50%)',
                        zIndex: 2,
                        padding: '16px 48px',
                        fontSize: '1.5rem',
                        background: '#42a5f5',
                        color: '#fff',
                        borderRadius: '8px',
                        border: 'none',
                        textDecoration: 'none',
                        cursor: 'pointer',
                        boxShadow: '0 2px 8px rgba(0,0,0,0.2)'
                    }}
                >
                    Shop Now
                </Link>
            </div>
        </>
    )
}

export default Home;
