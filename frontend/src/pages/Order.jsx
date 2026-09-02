import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { useNavigate, useParams } from 'react-router-dom';

function Order() {

    const [recieverData, setRecieverData] = useState({
        username: '',
        email: '',
        address: '',
        phone: '',
        pincode: '',
        paymentMode: ''
    });

    const [bill, setBill] = useState({
        totalAmount: 0,
        gst: 0,
        totalBill: 0
    });

    const [singleProduct, setSingleProduct] = useState(null); // For Buy Now

    function handleChange(e) {
        e.preventDefault();
        const { name, value } = e.target;
        setRecieverData((prevData) => ({
            ...prevData,
            [name]: value,
        }));
    }

    const navigator = useNavigate();
    const { orderId, productId } = useParams();

    function clearCart() {
        const token = localStorage.getItem('userToken');
        axios
            .delete(`http://localhost:5000/cart`, {
                headers: {
                    Authorization: token,
                }
            })
            .then((response) => {
                console.log("Cart Cleared");
                navigator('/');
            })
            .catch((err) => {
                console.log(err.response.data);
            })
    }

    // Get user and order/product data
    function getData() {
        const token = localStorage.getItem('userToken');
        axios
            .get('http://localhost:5000/user/getOne', {
                headers: {
                    Authorization: token,
                }
            })
            .then((response) => {
                setRecieverData(response.data);
            })
            .catch((error) => {
                console.log(error.response?.data);
            });

        if (productId) {
            // Buy Now: fetch product info
            axios
                .get(`http://localhost:5000/products/${productId}`)
                .then((response) => {
                    const product = response.data.productDetails; // <-- FIXED
                    setSingleProduct(product);
                    setBill({
                        totalAmount: product.price,
                        gst: product.price * 0.18,
                        totalBill: product.price * 1.18
                    });
                })
                .catch((error) => {
                    console.log(error.response?.data);
                });
        } else if (orderId) {
            // Cart order
            axios
                .get(`http://localhost:5000/orders/${orderId}`, {
                    headers: {
                        Authorization: token,
                    }
                })
                .then((response) => {
                    setBill({
                        totalAmount: response.data.totalAmount,
                        gst: response.data.gst,
                        totalBill: response.data.totalBill
                    });
                })
                .catch((error) => {
                    console.log(error.response?.data);
                });
        }
    }

    // Place order
    function handleOrder(e) {
        e.preventDefault();
        const token = localStorage.getItem('userToken');

        // Validate payment mode
        if (!recieverData.paymentMode) {
            alert("Please select a payment mode before placing the order.");
            return;
        }

        if (productId) {
            // Buy Now: create order for single product
            const orderData = {
                items: [{
                    productId: singleProduct._id,
                    quantity: 1,
                    price: singleProduct.price,
                    name: singleProduct.p_name,
                }],
                totalAmount: bill.totalAmount,
                gst: bill.gst,
                totalBill: bill.totalBill,
                ...recieverData
            };
            axios
                .post('http://localhost:5000/orders', orderData, {
                    headers: { Authorization: token }
                })
                .then((response) => {
                    if (response.status === 201) {
                        alert("Order Placed");
                        navigator(`/order/${response.data._id}`);
                    }
                })
                .catch((error) => {
                    console.log(error.response?.data);
                });
        } else {
            // Cart order
            recieverData.orderId = orderId;
            axios
                .put('http://localhost:5000/orders/update', recieverData)
                .then((response) => {
                    if (response.status === 200) {
                        alert("Order Placed");
                        clearCart();
                        navigator('/');
                    }
                })
                .catch((error) => {
                    console.log(error.response?.data);
                });
        }
    }

    // Cancel order (only for cart orders)
    function handleCancel(e) {
        e.preventDefault();
        if (!orderId) {
            // If cancelling a Buy Now order, redirect to products page
            navigator('/products');
            return;
        }
        axios
            .delete(`http://localhost:5000/orders/${orderId}`)
            .then((response) => {
                console.log(response.data);
                navigator('/cart');
            })
            .catch((error) => {
                console.log(error.response?.data);
            });
    }

    useEffect(() => {
        getData();
        // eslint-disable-next-line
    }, []);

    return (
        <>
            <div className="container-fluid p-4">
                <div className="row flex-jcenter gap-3">
                    <div className="col-md-5 bg-light p-3">
                        <h3 className="text-center fw-normal">Reciever Details</h3>
                        <hr />
                        <div className="mb-3">
                            <label className='form-label' htmlFor="username">Recipient</label>
                            <input
                                className='form-control'
                                type="text"
                                id="username"
                                name="username"
                                value={recieverData.username}
                                onChange={handleChange}
                            />
                        </div>
                        <div className="mb-3">
                            <label className='form-label' htmlFor="email">Email</label>
                            <input
                                className='form-control'
                                type="email"
                                id="email"
                                name="email"
                                onChange={handleChange}
                                value={recieverData.email}
                            />
                        </div>
                        <div className="mb-3">
                            <label className='form-label' htmlFor="phone">Phone</label>
                            <input
                                className='form-control'
                                type="number"
                                id="phone"
                                name="phone"
                                onChange={handleChange}
                                value={recieverData.phone}
                            />
                        </div>
                        <div className="mb-3">
                            <label htmlFor="address" className="form-label">Address</label>
                            <textarea
                                name="address"
                                id="address"
                                rows={5}
                                className='form-control'
                                value={recieverData.address}
                                onChange={handleChange}
                            ></textarea>
                        </div>
                        <div className="mb-3">
                            <label htmlFor="pincode" className="form-label">Pincode</label>
                            <input
                                type="number"
                                name="pincode"
                                id="pincode"
                                value={recieverData.pincode}
                                onChange={handleChange}
                                className="form-control"
                            />
                        </div>
                    </div>
                    <div className="col-md-5 bg-light p-3">
                        <h3 className="text-center fw-normal">Payment Details</h3>
                        <hr />
                        {/* Show product details if Buy Now */}
                        {singleProduct && (
                            <div className="mb-3">
                                <h5>Product: {singleProduct.p_name}</h5>
                                <img src={`http://localhost:5000${singleProduct.img[0]}`} alt={singleProduct.p_name} style={{ maxWidth: '100px' }} />
                            </div>
                        )}
                        <p className="fs-5"><b>Total Amount :</b> ₹{bill.totalAmount.toFixed(2)}</p>
                        <p className="fs-5"><b>GST (18%):</b> ₹ {bill.gst.toFixed(2)}</p>
                        <hr />
                        <p className="fs-5"><b>Total Bill :</b> ₹{bill.totalBill.toFixed(2)}</p>
                        <div className="mb-3">
                            <label className='form-label' htmlFor="paymentMode">Payment Mode</label>
                            <select
                                className="form-select"
                                id='paymentMode'
                                name='paymentMode'
                                onChange={handleChange}
                                required
                            >
                                <option value="">Select Payment Mode</option>
                                <option value="Cash on Delivery">Cash on Delivery</option>
                                <option value="UPI">UPI</option>
                                <option value="Card">Card</option>
                            </select>
                        </div>
                        <hr />
                        <div className="d-flex justify-content-end gap-3">
                            {!productId && (
                                <button className="btn btn-danger" onClick={handleCancel}>Cancel Order</button>
                            )}
                            <button className="btn btn-primary" onClick={handleOrder}>Place Order Now</button>
                        </div>
                    </div>
                </div>
            </div>
        </>
    )
}

export default Order
