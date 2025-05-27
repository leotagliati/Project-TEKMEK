import React from 'react'
import { Button } from 'primereact/button'

export default function ProductCard({ title, description, price, imageUrl }) {
    return (
        <div className='col-3'>
            <div className='card'>
                {/* <img src={imageUrl} className='card-img-top' alt='ProductImage' /> */}
                <img src='https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?q=80&w=1480&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D' className='card-img-top' alt='ProductImage' />
                <div className='card-body'>
                    <h5 className='card-title'>{title}</h5>
                    <p className='card-text'>R$ {price}</p>
                    <Button label='Add to Cart' className='p-button-outlined' />
                </div>
            </div>
        </div>
    )
}
