import React, { useEffect, useState } from 'react'
import ProductCard from './components/ProductCard'
import client from './utils/searchClient.js'
import { InputText } from 'primereact/inputtext'
import ProductFilters from './components/ProductFilters.jsx'

export const ProductSearchPage = ({ termo }) => {
    const [produtos, setProdutos] = useState([])
    const [selectedLayoutSizes, setSelectedLayoutSizes] = useState([])

    useEffect(() => {
        client.get('/search', {
            params: {
                query: termo
            }
        })
            .then((response) => {
                setProdutos(response.data)
            })
            .catch((error) => {
                console.error('Erro ao buscar produtos:', error)
            })
    }, [termo])

    const handleLayoutChange = (size) => {
        setSelectedLayoutSizes((prev) =>
            prev.includes(size)
                ? prev.filter((s) => s !== size) // desmarca
                : [...prev, size] // marca
        )
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

            {/* Filtros + Resultados */}
            <div className='d-flex'>
                {/* Sidebar de Filtros */}
                <ProductFilters
                    selectedLayoutSizes={selectedLayoutSizes}
                    onLayoutChange={handleLayoutChange}
                />

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
                                link={`/products/${product.id}`}
                            />
                        ))}
                    </div>
                </main>
            </div>
        </>
    )
}
