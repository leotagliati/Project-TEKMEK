import React, { useEffect, useState } from 'react'
import ProductCard from './components/ProductCard'
import client from './utils/searchClient'
export const ProductSearchPage = () => {
    const [produtos, setProdutos] = useState([])

    useEffect(() => {
        client.get('/products')
            .then((response) => {
                setProdutos(response.data)
            })
            .catch((error) => {
                console.error('Erro ao buscar produtos:', error)
            })
    }, [])

    return (
        <>
            <div>ProductSearchPage</div>
            <div className='d-flex'>
                {/* Side bar com filtros */}
                <div className='bg-dark-subtle col-3' style={{ height: '100vh' }}>
                    <h3>Filter Results</h3>
                </div>

                {/* Conteúdo principal com lista de produtos */}
                <div className='bg-light col-9' style={{ height: '100vh', overflowY: 'auto' }}>
                    <div className='row'>
                        {produtos.map((product) => (
                            <ProductCard
                                key={product.id}
                                title={product.name}
                                description={product.description}
                                price={product.price}
                                image={product.imageUrl}
                                link={`/products/${product.id}`}
                            />
                        ))}
                    </div>
                </div>
            </div>
        </>
    )
}
