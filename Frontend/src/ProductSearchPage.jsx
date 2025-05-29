import React, { useEffect, useState } from 'react'
import ProductCard from './components/ProductCard'
import client from './utils/searchClient.js'
import { InputText } from 'primereact/inputtext'
import ProductFilters from './components/ProductFilters.jsx'
import { Link } from 'react-router-dom'

export const ProductSearchPage = () => {
    const [produtos, setProdutos] = useState([])
    const [filters, setFilters] = useState({})
    const [searchTerm, setSearchTerm] = useState('')


    useEffect(() => {
        client.post('/search',
            { searchTerm, filters }
        )
            .then((response) => {
                setProdutos(response.data)
            })
            .catch((error) => {
                console.error('Erro ao buscar produtos:', error)
            })
    }, [searchTerm, filters])

    const handleFiltersChange = (newFilters) => {
        setFilters(newFilters)
    }
    const handleSearchChange = (event) => {
        setSearchTerm(event.target.value)
    }
    const handleCartClick = () => {
        console.log('Exibir carrinho')
    }

    return (
        <>
            {/* Header e Barra de Pesquisa */}
            <div>
                <header className="navbar navbar-expand-lg navbar-light bg-light shadow-sm px-4 py-2">
                    <Link to="/" className="d-flex align-items-center text-decoration-none text-dark">
                        <img src="logo.png" alt="Logo" style={{ height: '50px' }} />
                        <h2 className="ms-2">Tekmek</h2>
                    </Link>

                    <div className=" flex-grow-1 d-flex justify-content-center">
                        <div className="p-input-icon-left " style={{ width: '100%', maxWidth: '600px' }}>
                            <i className="px-2 pi pi-search" />
                            <InputText placeholder="Search"
                                className="px-5 w-100"
                                onChange={handleSearchChange} />
                        </div>
                    </div>
                    <div className="d-flex align-items-center gap-3 ms-4">
                        <Link to="/login" className="text-dark" title="Login">
                            <i className="pi pi-user" style={{ fontSize: '1.3rem' }} />
                        </Link>

                        {/* Aqui eu chamaria a funcao que exibe o cart.jsx */}
                        <div onClick={handleCartClick} className="text-dark" style={{ cursor: 'pointer' }} title="Carrinho">
                            <i className="pi pi-shopping-cart" style={{ fontSize: '1.3rem' }} />
                        </div>
                    </div>
                </header>
            </div>
            <div className='mt-4 d-flex'>
                {/* Sidebar de Filtros */}
                <ProductFilters onChange={handleFiltersChange} />

                {/* Lista de Produtos */}
                <main className='bg-light col-9 p-4' style={{ height: '100vh', overflowY: 'auto' }}>
                    <div className='row'>
                        {
                            produtos.length > 0 ? (
                                produtos.map((product) => (
                                    <ProductCard
                                        key={product.id}
                                        id={product.id}
                                        title={product.name}
                                        description={product.description}
                                        price={product.price}
                                        image={product.image_url}
                                    />
                                ))
                            ) : (
                                <div className='col-12 text-center'>
                                    <h3>Nenhum produto encontrado</h3>
                                </div>
                            )

                        }

                    </div>
                </main>
            </div>
        </>
    )
}
