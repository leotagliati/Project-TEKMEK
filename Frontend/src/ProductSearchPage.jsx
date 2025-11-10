import React, { useEffect, useState } from 'react'
import ProductCard from './components/ProductCard'
import client from './utils/searchClient.js'
import { InputText } from 'primereact/inputtext'
import ProductFilters from './components/ProductFilters.jsx'
<<<<<<< HEAD
import { Link, useParams } from 'react-router-dom'
import Cart from './components/cart.jsx'

=======
import { Link } from 'react-router-dom'
>>>>>>> ab3efef0e4dffaefacf2aaed0b7a952279394fbc

export const ProductSearchPage = () => {
    const [produtos, setProdutos] = useState([])
    const [filters, setFilters] = useState({})
    const [searchTerm, setSearchTerm] = useState('')
<<<<<<< HEAD
    const [showCart, setShowCart] = useState(false)
    const { idlogin } = useParams()
    const username = localStorage.getItem("username")
=======

>>>>>>> ab3efef0e4dffaefacf2aaed0b7a952279394fbc

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
        setShowCart(prev => !prev)
    }

    return (
        <>
            {/* Header e Barra de Pesquisa */}
            <div>
                <header className="navbar navbar-expand-lg navbar-light bg-light shadow-sm px-4 py-2">
                    <a className="navbar-brand me-4" href="#">TEKMEK</a>

                    <div className="flex-grow-1 d-flex justify-content-center">
<<<<<<< HEAD
                        <div className="p-input-icon-left" style={{ width: '100%', maxWidth: '600px' }}>
=======
                        <div className="p-input-icon-left " style={{ width: '100%', maxWidth: '600px' }}>
>>>>>>> ab3efef0e4dffaefacf2aaed0b7a952279394fbc
                            <i className="px-2 pi pi-search" />
                            <InputText
                                placeholder="Search"
                                className="px-5 w-100"
                                onChange={handleSearchChange}
                            />
                        </div>
                    </div>
                    <div className="d-flex align-items-center gap-3 ms-4">
                        <Link to="/login" className="text-dark" title="Login">
                            <i className="pi pi-user" style={{ fontSize: '1.3rem' }} />
                        </Link>

                        {/* Ícone do carrinho que abre/fecha o overlay */}
                        <div
                            onClick={handleCartClick}
                            className="text-dark"
                            style={{ cursor: 'pointer' }}
                            title="Carrinho"
                        >
                            <i className="pi pi-shopping-cart" style={{ fontSize: '1.3rem' }} />
                        </div>
                    </div>
                </header>
            </div>
<<<<<<< HEAD

            {/* Mensagem personalizada */}
            <div className="text-center mt-4">
                {username && <h4>Seja bem vindo,  {username}!</h4>}
            </div>

            <div className='mt-4 d-flex'>
=======
            <div className='d-flex'>
>>>>>>> ab3efef0e4dffaefacf2aaed0b7a952279394fbc
                {/* Sidebar de Filtros */}
                <ProductFilters onChange={handleFiltersChange} />

                {/* Lista de Produtos */}
                <main className='bg-light col-9 p-4' style={{ height: '100vh', overflowY: 'auto' }}>
<<<<<<< HEAD
                    <div className='row row-gap-4'>
                        {produtos.length > 0 ? (
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
                        )}
=======
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

>>>>>>> ab3efef0e4dffaefacf2aaed0b7a952279394fbc
                    </div>
                </main>
            </div>

            {/* Overlay do Carrinho */}
            {showCart && (
                <>
                    {/* Backdrop semitransparente */}
                    <div
                        onClick={handleCartClick}
                        style={{
                            position: 'fixed',
                            top: 0,
                            left: 0,
                            width: '100vw',
                            height: '100vh',
                            backgroundColor: 'rgba(0,0,0,0.4)',
                            zIndex: 999,
                        }}
                    />

                    {/* Container do carrinho fixo à direita */}
                    <div
                        style={{
                            position: 'fixed',
                            top: 0,
                            right: 0,
                            height: '100vh',
                            width: '350px',
                            backgroundColor: 'white',
                            boxShadow: '-2px 0 8px rgba(0,0,0,0.3)',
                            zIndex: 1000,
                            overflowY: 'auto',
                            padding: '1rem',
                        }}
                    >
                        <button
                            onClick={handleCartClick}
                            style={{ marginBottom: '1rem', cursor: 'pointer' }}
                        >
                            Fechar
                        </button>
                       <Cart/>
                    </div>
                </>
            )}
        </>
    )
}