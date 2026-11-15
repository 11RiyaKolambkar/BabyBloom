import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

function Login({ refresh }) {
    // Separate state for Login
    const [loginEmail, setLoginEmail] = useState('');
    const [loginPassword, setLoginPassword] = useState('');
    const [logError, setLogError] = useState('');

    // Separate state for Register
    const [regUsername, setRegUsername] = useState('');
    const [regEmail, setRegEmail] = useState('');
    const [regPhone, setRegPhone] = useState('');
    const [regPassword, setRegPassword] = useState('');
    const [regConfPassword, setRegConfPassword] = useState('');
    const [regError, setRegError] = useState('');
    const [regSuccess, setRegSuccess] = useState('');

    // Active tab: 'login' or 'register'
    const [activeTab, setActiveTab] = useState('login');

    const navigator = useNavigate();

    function handleRegister(e) {
        e.preventDefault();
        setRegError('');
        setRegSuccess('');

        if (!regUsername || !regEmail || !regPhone || !regPassword) {
            setRegError("Please fill in all required fields");
            return;
        }

        if (regPassword !== regConfPassword) {
            setRegError("Passwords do not match");
            return;
        }

        const formData = {
            username: regUsername.trim(),
            email: regEmail.trim().toLowerCase(),
            phone: Number(regPhone),
            password: regPassword
        };

        axios
            .post("http://localhost:5000/user/register", formData)
            .then((res) => {
                setRegError('');
                setRegSuccess('Registration successful! Redirecting...');
                localStorage.setItem('userToken', res.data.token);
                if (formData.email === 'admin@gmail.com') {
                    localStorage.setItem('role', "admin");
                    navigator('/admin');
                } else {
                    navigator('/');
                }
                refresh();
            })
            .catch((err) => {
                setRegSuccess('');
                setRegError(err.response?.data?.Error || err.response?.data?.message || 'Registration failed');
            });
    }

    function handleLogin(e) {
        e.preventDefault();
        setLogError('');

        if (!loginEmail || !loginPassword) {
            setLogError("Please enter both email and password");
            return;
        }

        const formData = {
            email: loginEmail.trim().toLowerCase(),
            password: loginPassword
        };

        axios
            .post("http://localhost:5000/user/login", formData)
            .then((res) => {
                setLogError('');
                localStorage.setItem('userToken', res.data.token);
                if (formData.email === 'admin@gmail.com') {
                    localStorage.setItem('role', "admin");
                    navigator('/admin');
                } else {
                    navigator('/');
                }
                refresh();
            })
            .catch((err) => {
                setLogError(err.response?.data?.Error || err.response?.data?.message || 'Invalid credentials');
            });
    }

    return (
        <div className="container mt-5 mb-5">
            {activeTab === 'login' ? (
                <div className="container p-5 bg-primary rounded shadow-sm" style={{ maxWidth: "480px" }}>
                    <h2 className="text-center fw-bold">Login</h2>
                    <hr />
                    {logError && (
                        <div className="alert alert-danger py-2" role="alert">
                            {logError}
                        </div>
                    )}
                    <form onSubmit={handleLogin}>
                        <div className="mb-3">
                            <label className="form-label" htmlFor="login-email">Email</label>
                            <input
                                className="form-control"
                                type="email"
                                id="login-email"
                                value={loginEmail}
                                onChange={(e) => {
                                    setLoginEmail(e.target.value);
                                    setLogError('');
                                }}
                                required
                            />
                        </div>
                        <div className="mb-3">
                            <label className="form-label" htmlFor="login-password">Password</label>
                            <input
                                className="form-control"
                                type="password"
                                id="login-password"
                                value={loginPassword}
                                onChange={(e) => {
                                    setLoginPassword(e.target.value);
                                    setLogError('');
                                }}
                                required
                            />
                        </div>
                        <div className="d-flex justify-content-end mb-3">
                            <button type="submit" className="btn btn-primary px-4 fw-bold">Login</button>
                        </div>
                    </form>
                    <hr />
                    <div className="d-flex align-items-center justify-content-between">
                        <p className="m-0">Don't have an account?</p>
                        <button
                            type="button"
                            className="btn btn-success"
                            onClick={() => {
                                setActiveTab('register');
                                setLogError('');
                                setRegError('');
                            }}
                        >
                            Register
                        </button>
                    </div>
                </div>
            ) : (
                <div className="container p-5 bg-primary rounded shadow-sm" style={{ maxWidth: "480px" }}>
                    <h2 className="text-center fw-bold">Register</h2>
                    <hr />
                    {regError && (
                        <div className="alert alert-danger py-2" role="alert">
                            {regError}
                        </div>
                    )}
                    {regSuccess && (
                        <div className="alert alert-success py-2" role="alert">
                            {regSuccess}
                        </div>
                    )}
                    <form onSubmit={handleRegister}>
                        <div className="mb-3">
                            <label className="form-label" htmlFor="reg-username">Username</label>
                            <input
                                className="form-control"
                                type="text"
                                id="reg-username"
                                value={regUsername}
                                onChange={(e) => {
                                    setRegUsername(e.target.value);
                                    setRegError('');
                                }}
                                required
                            />
                        </div>
                        <div className="mb-3">
                            <label className="form-label" htmlFor="reg-email">Email</label>
                            <input
                                className="form-control"
                                type="email"
                                id="reg-email"
                                value={regEmail}
                                onChange={(e) => {
                                    setRegEmail(e.target.value);
                                    setRegError('');
                                }}
                                required
                            />
                        </div>
                        <div className="mb-3">
                            <label className="form-label" htmlFor="reg-phone">Phone</label>
                            <input
                                className="form-control"
                                type="number"
                                id="reg-phone"
                                value={regPhone}
                                onChange={(e) => {
                                    setRegPhone(e.target.value);
                                    setRegError('');
                                }}
                                required
                            />
                        </div>
                        <div className="mb-3">
                            <label className="form-label" htmlFor="reg-password">New Password</label>
                            <input
                                className="form-control"
                                type="password"
                                id="reg-password"
                                value={regPassword}
                                onChange={(e) => {
                                    setRegPassword(e.target.value);
                                    setRegError('');
                                }}
                                required
                            />
                        </div>
                        <div className="mb-3">
                            <label className="form-label" htmlFor="reg-confpassword">Confirm Password</label>
                            <input
                                className="form-control"
                                type="password"
                                id="reg-confpassword"
                                value={regConfPassword}
                                onChange={(e) => {
                                    setRegConfPassword(e.target.value);
                                    setRegError('');
                                }}
                                required
                            />
                        </div>
                        <div className="d-flex justify-content-end mb-3">
                            <button type="submit" className="btn btn-success px-4 fw-bold">Register</button>
                        </div>
                    </form>
                    <hr />
                    <div className="d-flex align-items-center justify-content-between">
                        <p className="m-0">Already have an account?</p>
                        <button
                            type="button"
                            className="btn btn-primary"
                            onClick={() => {
                                setActiveTab('login');
                                setLogError('');
                                setRegError('');
                            }}
                        >
                            Login
                        </button>
                    </div>
                </div>
            )}
        </div>
    );
}

export default Login;
