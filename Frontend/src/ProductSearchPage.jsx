import React, { useEffect, useState } from 'react'
import ProductCard from './components/ProductCard'
import client from './utils/searchClient.js'
import { InputText } from 'primereact/inputtext'
import ProductFilters from './components/ProductFilters.jsx'

export const ProductSearchPage = () => {
    const [produtos, setProdutos] = useState([])
    const [filters, setFilters] = useState({})


    useEffect(() => {
        client.post('/search',
            { filters }
        )
            .then((response) => {
                setProdutos(response.data)
            })
            .catch((error) => {
                console.error('Erro ao buscar produtos:', error)
            })
    }, [filters])

    const handleFiltersChange = (newFilters) => {
        setFilters(newFilters)
    }

    return (
        <>
            {/* Header e Barra de Pesquisa */}
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
                {/* Sidebar de Filtros */}
                <ProductFilters onChange={handleFiltersChange} />

                {/* Lista de Produtos */}
                <main className='bg-light col-9 p-4' style={{ height: '100vh', overflowY: 'auto' }}>
                    <div className='row'>
                        {produtos.map((product) => (
                            <ProductCard
                                key={product.id}
                                title={product.name}
                                description={product.description}
                                price={product.price}
                                image={product.image_url}
                            />
                        ))}
                    </div>
                </main>
            </div>
        </>
    )
}
