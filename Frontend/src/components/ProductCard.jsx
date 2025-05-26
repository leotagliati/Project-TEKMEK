import React from 'react'
import { Button } from 'primereact/button'

export default function ProductCard({ title, description, price, imageUrl }) {
    return (
        <div className='col-3'>
            <div className='card'>
                <img src={imageUrl} className='card-img-top' alt='ProductImage' />
                <div className='card-body'>
                    <h5 className='card-title'>{title}</h5>
                    <p className='card-text'>{description}</p>
                    <p className='card-text'>R$ {price}</p>
                    <Button label='Add to Cart' className='p-button-outlined' />
                </div>
            </div>
        </div>
    )
}
