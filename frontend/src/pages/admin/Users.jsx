import React, { useEffect, useState } from 'react';
import axios from 'axios';

function Users() {
    const [users, setUsers] = useState([]);
    const [loading, setLoading] = useState(true);

    const getUsers = () => {
        axios
            .get('http://localhost:5000/user')
            .then((res) => {
                setUsers(res.data.users || []);
                setLoading(false);
            })
            .catch((err) => {
                console.log(err);
                setLoading(false);
            });
    };

    const handleDeleteUser = (id) => {
        if (window.confirm("Are you sure you want to delete this user?")) {
            axios
                .delete(`http://localhost:5000/user/${id}`)
                .then(() => {
                    getUsers();
                })
                .catch((err) => {
                    console.log(err);
                });
        }
    };

    useEffect(() => {
        getUsers();
    }, []);

    return (
        <div className="container-fluid p-4">
            <h2 className="text-center mb-4">Registered Users</h2>
            {loading ? (
                <p className="text-center">Loading users...</p>
            ) : (
                <div className="table-responsive">
                    <table className="table table-striped table-hover align-middle">
                        <thead className="table-dark">
                            <tr>
                                <th>#</th>
                                <th>Username</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Address</th>
                                <th>Pincode</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            {users.length === 0 ? (
                                <tr>
                                    <td colSpan="7" className="text-center">No users found</td>
                                </tr>
                            ) : (
                                users.map((u, index) => (
                                    <tr key={u._id}>
                                        <td>{index + 1}</td>
                                        <td>{u.username}</td>
                                        <td>{u.email}</td>
                                        <td>{u.phone}</td>
                                        <td>{u.address || '-'}</td>
                                        <td>{u.pincode || '-'}</td>
                                        <td>
                                            {u.email === 'admin@gmail.com' ? (
                                                <span className="badge bg-primary">Admin</span>
                                            ) : (
                                                <button
                                                    className="btn btn-sm btn-danger"
                                                    onClick={() => handleDeleteUser(u._id)}
                                                >
                                                    Delete
                                                </button>
                                            )}
                                        </td>
                                    </tr>
                                ))
                            )}
                        </tbody>
                    </table>
                </div>
            )}
        </div>
    );
}

export default Users;
