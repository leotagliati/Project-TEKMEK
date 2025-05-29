import React from 'react'
import { Button } from 'primereact/button'
import { useNavigate } from 'react-router-dom'


export default function ProductCard({ id, title, description, price, imageUrl }) {
    const navigate = useNavigate()
    const handleClick = () => {
        navigate(`/product/${title}`)
    }

    return (

        <div className='col-3' onClick={handleClick} style={{ cursor: 'pointer' }}>
            <div className='card h-100 d-flex flex-column' style={{ minHeight: '100%', maxWidth: '400px' }}>
                <img
                    src='https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?q=80&w=1480&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
                    className='card-img-top'
                    alt='ProductImage'
                    style={{ objectFit: 'cover', height: '200px' }} // altura padronizada da imagem
                />
                <div className='card-body d-flex flex-column justify-content-between'>
                    <div>
                        <h5 className='card-title'>{title}</h5>
                        <p className='card-text'>R$ {price}</p>
                    </div>
                </div>
            </div>
        </div>
    )
}
