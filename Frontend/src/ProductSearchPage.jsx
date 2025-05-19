import React, { useEffect, useState } from 'react'
import ProductCard from './components/ProductCard'
import client from './utils/searchClient.js'
export const ProductSearchPage = ({ termo }) => {
    const [produtos, setProdutos] = useState([])

    useEffect(() => {
        client.get('/search', {
            params: {
                query: termo
            }
        })
            .then((response) => {
                // console.log('Resultados encontrados:', response.data)
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
                                title={product.name} // corrigido
                                description={product.description} // corrigido
                                price={product.price}
                                image={product.image_url} // corrigido
                                link={`/products/${product.id}`}
                            />
                        ))}
                    </div>
                </div>
            </div>
        </>
    )
}
