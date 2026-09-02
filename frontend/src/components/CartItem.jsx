// CartItem.jsx
import React, { useState } from 'react';
import QuantityControl from './QuantityControl';

function CartItem({ item, onQuantityChange, onRemove }) {
    const [quantity, setQuantity] = useState(item.qty || 1);

    // Function to handle change in quantity
    const handleQuantityChange = (newQuantity) => {
        setQuantity(newQuantity);
        onQuantityChange(item._id, newQuantity);
    };

    // Function to handle remove button click
    const handleRemove = () => {
        if (onRemove) {
            onRemove(item._id);
        }
    };

    // Use direct fields from item as your backend returns them flat
    return (
        <div className='container-fluid flex-acenter gap-4 p-3'>
            <div className="col-md-6">
                <img
                    src={`http://localhost:5000${item.img && item.img[0] ? item.img[0] : ''}`}
                    alt={item.p_name}
                    className="img-fluid"
                />
            </div>
            <div className="col-md-6">
                <p>Product : {item.p_name}</p>
                <p>Price: ₹{item.price}</p>
                <QuantityControl initialQuantity={quantity} onQuantityChange={handleQuantityChange} />
                <p>Total: ₹{item.price * quantity}</p>
                <button 
                    className="btn btn-danger mt-2"
                    onClick={handleRemove}
                >
                    Remove
                </button>
                {/* Removed the Order button as requested */}
            </div>
        </div>
    );
}

export default CartItem;

