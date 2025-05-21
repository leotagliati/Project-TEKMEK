import React, { useEffect, useState } from 'react'
import ProductCard from './components/ProductCard'
import client from './utils/searchClient.js'
import { InputText } from 'primereact/inputtext'
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
            <div className='d-flex row row-gap-3 justify-content-center bg-light p-3'>
                <h1 className='bg-primary text-center'>Product Search</h1>
                <div className="col-5 p-inputgroup flex-1">
                    <span className="p-inputgroup-addon">
                        <i className="pi pi-search"></i>
                    </span>
                    <InputText placeholder="Search" />
                </div>
            </div>
            <div className='d-flex'>
                {/* Side bar com filtros */}
                <div className='bg-dark-subtle col-3 p-2' style={{ height: '100vh' }}>
                    <h3>Filter Results</h3>
                </div>

                {/* Conteúdo principal com lista de produtos */}
                <div className='bg-light col-9 p-4' style={{ height: '100vh', overflowY: 'auto' }}>
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
