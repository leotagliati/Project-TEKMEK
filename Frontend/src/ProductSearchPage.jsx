import React, { useEffect, useState } from 'react'
import ProductCard from './components/ProductCard'
import client from './utils/searchClient.js'
import { InputText } from 'primereact/inputtext'
import { Checkbox } from "primereact/checkbox"
import {
    layoutSizes,
    connectivities,
    keycapsTypes,
    productTypes
} from './utils/searchFilters.js'

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
                <aside className='bg-dark-subtle col-3 p-3' style={{ height: '100vh' }}>
                    <h3>Filter Results</h3>

                    {/* Filtro: Layout Sizes */}
                    <div className="mb-4">
                        <h5>Layout Size</h5>
                        <div className="d-flex row row-gap-2 px-2">
                            {layoutSizes.map((size) => (
                            <div key={size} className="">
                                <Checkbox
                                    inputId={size}
                                    onChange={() => handleLayoutChange(size)}
                                    checked={selectedLayoutSizes.includes(size)}
                                />
                                <label htmlFor={size} className="form-check-label ms-2">
                                    {size}
                                </label>
                            </div>
                        ))}</div>

                    </div>
                </aside>

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
