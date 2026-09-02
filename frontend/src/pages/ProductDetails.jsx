import React, { useEffect, useState } from 'react'
import { useNavigate, useParams, Link } from 'react-router-dom';
import axios from 'axios';

function ProductDetails() {

    //get product id from url through useParams
    const { id } = useParams();

    const navigator = useNavigate();

    //variable to manage product information
    const [product, setProduct] = useState({});

    //function to get all the product data
    function getProductData() {
        axios
            .get(`http://localhost:5000/products/${id}`)
            .then((response) => {
                setProduct(response.data.productDetails);
            })
            .catch((error) => {
                console.log(error);
            })
    }

    // function to handle adding to cart 
    function handleAddCart(e) {
        console.log('Product ID:', e.target.dataset.id);
        if (!localStorage.getItem('userToken')) {
            navigator('/login');
        } else {
            const token = localStorage.getItem('userToken');
            axios
                .post('http://localhost:5000/cart/add', {
                    p_id: e.target.dataset.id,
                    qty: 1
                }, {
                    headers: {
                        Authorization: token
                    }
                })
                .then((response) => {
                    window.alert("Item added to cart")
                })
                .catch((error) => {
                    alert(error.response.data.message);
                })
        }
    }

    //get product data for display on page render
    useEffect(() => {
        getProductData();
    }, [])

    return (
        <>
            <div className="container-fluid p-3">
                <div className="row flex-acenter">

                    {!product ? (
                        <h1 className="fw-normal">Ooops! Something went Wrong.</h1>
                    ) : (
                        <>
                            <div className="col-md-6 text-center">
                                <img
                                    src={`http://localhost:5000${product.img && product.img[0] ? product.img[0] : (product.img || '')}`}
                                    alt={product.p_name || 'Product'}
                                    className="img-fluid rounded shadow-sm"
                                    style={{ maxHeight: '400px', objectFit: 'contain' }}
                                />
                            </div>
                            <div className="col-md-6">
                                <p className="fs-4">Product : {product.p_name}</p>
                                <p className="fs-4">Description : {product.desc}</p>
                                <p className="fs-4">Price : ₹{product.price}</p>
                                <p className="fs-4">Stock : {product.stock}</p>
                                <button className="btn btn-warning me-2" data-id={product._id} onClick={handleAddCart}>Add to cart</button>
                                <Link to={`/order/buynow/${product._id}`} className="btn btn-primary">
                                    Buy Now
                                </Link>
                            </div>
                        </>
                    )}
                </div>
            </div>
        </>
    )
}

export default ProductDetails
