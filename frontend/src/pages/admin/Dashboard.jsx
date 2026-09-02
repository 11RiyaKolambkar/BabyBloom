import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import axios from 'axios';

function Dashboard() {
    const [stats, setStats] = useState({
        totalProducts: 0,
        totalOrders: 0,
        totalUsers: 0,
        totalRevenue: 0,
    });
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchDashboardData = async () => {
            try {
                const [productsRes, ordersRes, usersRes] = await Promise.allSettled([
                    axios.get('http://localhost:5000/products'),
                    axios.get('http://localhost:5000/orders'),
                    axios.get('http://localhost:5000/user'),
                ]);

                const products = productsRes.status === 'fulfilled' ? (productsRes.value.data.products || []) : [];
                const orders = ordersRes.status === 'fulfilled' ? (Array.isArray(ordersRes.value.data) ? ordersRes.value.data : []) : [];
                const users = usersRes.status === 'fulfilled' ? (usersRes.value.data.users || []) : [];

                const revenue = orders.reduce((acc, order) => acc + (order.totalBill || 0), 0);

                setStats({
                    totalProducts: products.length,
                    totalOrders: orders.length,
                    totalUsers: users.length,
                    totalRevenue: revenue,
                });
            } catch (err) {
                console.error("Dashboard data error:", err);
            } finally {
                setLoading(false);
            }
        };

        fetchDashboardData();
    }, []);

    return (
        <div className="container-fluid p-4">
            <h2 className="text-center mb-4">Admin Dashboard</h2>
            <hr />

            {loading ? (
                <p className="text-center">Loading dashboard statistics...</p>
            ) : (
                <div className="row g-4">
                    <div className="col-md-3">
                        <div className="card text-white bg-primary h-100 shadow-sm">
                            <div className="card-body text-center">
                                <h5 className="card-title">Total Products</h5>
                                <p className="card-text display-6 fw-bold">{stats.totalProducts}</p>
                                <Link to="/admin/products" className="btn btn-light btn-sm mt-2">Manage Products</Link>
                            </div>
                        </div>
                    </div>

                    <div className="col-md-3">
                        <div className="card text-white bg-success h-100 shadow-sm">
                            <div className="card-body text-center">
                                <h5 className="card-title">Total Orders</h5>
                                <p className="card-text display-6 fw-bold">{stats.totalOrders}</p>
                                <Link to="/admin/orders" className="btn btn-light btn-sm mt-2">View Orders</Link>
                            </div>
                        </div>
                    </div>

                    <div className="col-md-3">
                        <div className="card text-white bg-info h-100 shadow-sm">
                            <div className="card-body text-center">
                                <h5 className="card-title">Total Users</h5>
                                <p className="card-text display-6 fw-bold">{stats.totalUsers}</p>
                                <Link to="/admin/users" className="btn btn-light btn-sm mt-2">View Users</Link>
                            </div>
                        </div>
                    </div>

                    <div className="col-md-3">
                        <div className="card text-white bg-warning h-100 shadow-sm">
                            <div className="card-body text-center">
                                <h5 className="card-title">Total Revenue</h5>
                                <p className="card-text display-6 fw-bold">₹{stats.totalRevenue.toFixed(2)}</p>
                                <span className="badge bg-dark mt-2">Gross Sales</span>
                            </div>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}

export default Dashboard;
