import React, { useState, useEffect } from 'react';
import { Button } from 'primereact/button';
import { useParams } from 'react-router-dom';
import client from './utils/searchAdmin.js';
import { v4 as uuidv4 } from 'uuid';  // Instale uuid com: npm install uuid

const layoutOptions = ['-', '40%', '60%', '65%', '70%', '75%', '100%'];
const connectivityOptions = ['-', 'USB', 'Bluetooth'];
const productTypeOptions = ['-', 'Keyboard', 'Switch', 'Keycap'];
const keycapsTypeOptions = ['-', 'ABS', 'PBT'];

const emptyProduct = {
    id: null,
    name: '',
    description: '',
    price: '',
    image_url: '',
    layout_size: layoutOptions[0],
    connectivity: connectivityOptions[0],
    product_type: productTypeOptions[0],
    keycaps_type: keycapsTypeOptions[0],
    isNew: true,
};

export default function AdminSheet() {
    const [products, setProducts] = useState([{ ...emptyProduct, id: uuidv4() }]);  // id único inicial
    const { idlogin } = useParams();

    useEffect(() => {
        client.get(`/products`)
            .then((response) => {
                if (response.data && response.data.length > 0) {
                    // Adiciona id e isNew = false para produtos do backend
                    const prods = response.data.map(p => ({
                        ...p,
                        id: p.id || uuidv4(), // usa id do backend ou gera um
                        isNew: false,
                    }));
                    setProducts(prods);
                } else {
                    setProducts([{ ...emptyProduct, id: uuidv4() }]);
                }
            })
            .catch((error) => {
                console.error('Erro ao buscar produtos:', error);
                setProducts([{ ...emptyProduct, id: uuidv4() }]);
            });
    }, []);

    const handleInputChange = (index, field, value) => {
        const newProducts = [...products];
        newProducts[index][field] = field === 'price' ? value.replace(/[^\d.]/g, '') : value;
        setProducts(newProducts);
    };

    const addProduct = () => {
        setProducts([...products, { ...emptyProduct, id: uuidv4() }]);  // gera id único para produto novo
    };

    const saveProducts = async () => {
        const newProducts = products.filter(p => p.isNew);

        const invalid = newProducts.some(
            p => !p.name || !p.price || p.product_type === '-'
        );

        if (invalid) {
            alert('Preencha todos os campos obrigatórios antes de salvar.');
            return;
        }

        if (newProducts.length === 0) {
            alert('Nenhum produto novo para salvar!');
            return;
        }

        try {
            for (const product of newProducts) {
                await client.post('/products', product);
            }

            alert('Produtos novos salvos com sucesso!');

            const response = await client.get('/products');
            const prods = response.data.map(p => ({
                ...p,
                id: p.id || uuidv4(),
                isNew: false,
            }));
            setProducts(prods);

        } catch (error) {
            console.error(error);
            alert('Erro ao salvar produtos.');
        }
    };

    const removeProduct = async (index) => {
        const productToRemove = products[index];

        if (productToRemove.id && !productToRemove.isNew) {
            try {
                await client.delete(`/products/${productToRemove.id}`);
                const newProducts = products.filter((_, i) => i !== index);
                setProducts(newProducts);
                alert('Produto removido com sucesso.');
            } catch (error) {
                console.error(error);
                alert('Erro ao remover produto.');
            }
        } else {
            const newProducts = products.filter((_, i) => i !== index);
            setProducts(newProducts);
        }
    };

    return (
        <div className="p-4">
            <div className="flex justify-content-between align-items-center mb-3">
                <h3 className="m-0">Tabela de Produtos</h3>
                <Button label="Adicionar Produto" icon="pi pi-plus" onClick={addProduct} />
            </div>
            <table className="table-auto w-full border-collapse border border-gray-300">
                <thead>
                    <tr className="bg-gray-200">
                        <th className="border border-gray-300 p-2">Nome</th>
                        <th className="border border-gray-300 p-2">Descrição</th>
                        <th className="border border-gray-300 p-2">Preço</th>
                        <th className="border border-gray-300 p-2">URL Imagem</th>
                        <th className="border border-gray-300 p-2">Layout</th>
                        <th className="border border-gray-300 p-2">Conectividade</th>
                        <th className="border border-gray-300 p-2">Tipo Produto</th>
                        <th className="border border-gray-300 p-2">Tipo Keycaps</th>
                        <th className="border border-gray-300 p-2">Ações</th>
                    </tr>
                </thead>
                <tbody>
                    {products.map((product) => (
                        <tr key={product.id} className="even:bg-gray-50">
                            <td className="border border-gray-300 p-2">
                                <input
                                    type="text"
                                    value={product.name}
                                    onChange={(e) => {
                                        const idx = products.findIndex(p => p.id === product.id);
                                        handleInputChange(idx, 'name', e.target.value);
                                    }}
                                    className="w-full p-1 border rounded"
                                />
                            </td>
                            <td className="border border-gray-300 p-2">
                                <input
                                    type="text"
                                    value={product.description}
                                    onChange={(e) => {
                                        const idx = products.findIndex(p => p.id === product.id);
                                        handleInputChange(idx, 'description', e.target.value);
                                    }}
                                    className="w-full p-1 border rounded"
                                />
                            </td>
                            <td className="border border-gray-300 p-2">
                                <input
                                    type="number"
                                    step="0.01"
                                    value={product.price}
                                    onChange={(e) => {
                                        const idx = products.findIndex(p => p.id === product.id);
                                        handleInputChange(idx, 'price', e.target.value);
                                    }}
                                    className="w-full p-1 border rounded"
                                />
                            </td>
                            <td className="border border-gray-300 p-2">
                                <input
                                    type="text"
                                    value={product.image_url}
                                    onChange={(e) => {
                                        const idx = products.findIndex(p => p.id === product.id);
                                        handleInputChange(idx, 'image_url', e.target.value);
                                    }}
                                    className="w-full p-1 border rounded"
                                />
                            </td>
                            <td className="border border-gray-300 p-2">
                                <select
                                    value={product.layout_size}
                                    onChange={(e) => {
                                        const idx = products.findIndex(p => p.id === product.id);
                                        handleInputChange(idx, 'layout_size', e.target.value);
                                    }}
                                    className="w-full p-1 border rounded"
                                >
                                    <option value="-" disabled hidden>Selecione</option>
                                    {layoutOptions.slice(1).map((opt) => (
                                        <option key={opt} value={opt}>{opt}</option>
                                    ))}
                                </select>
                            </td>
                            <td className="border border-gray-300 p-2">
                                <select
                                    value={product.connectivity}
                                    onChange={(e) => {
                                        const idx = products.findIndex(p => p.id === product.id);
                                        handleInputChange(idx, 'connectivity', e.target.value);
                                    }}
                                    className="w-full p-1 border rounded"
                                >
                                    <option value="-" disabled hidden>Selecione</option>
                                    {connectivityOptions.slice(1).map((opt) => (
                                        <option key={opt} value={opt}>{opt}</option>
                                    ))}
                                </select>
                            </td>
                            <td className="border border-gray-300 p-2">
                                <select
                                    value={product.product_type}
                                    onChange={(e) => {
                                        const idx = products.findIndex(p => p.id === product.id);
                                        handleInputChange(idx, 'product_type', e.target.value);
                                    }}
                                    className="w-full p-1 border rounded"
                                >
                                    <option value="-" disabled hidden>Selecione</option>
                                    {productTypeOptions.slice(1).map((opt) => (
                                        <option key={opt} value={opt}>{opt}</option>
                                    ))}
                                </select>
                            </td>
                            <td className="border border-gray-300 p-2">
                                <select
                                    value={product.keycaps_type}
                                    onChange={(e) => {
                                        const idx = products.findIndex(p => p.id === product.id);
                                        handleInputChange(idx, 'keycaps_type', e.target.value);
                                    }}
                                    className="w-full p-1 border rounded"
                                >
                                    <option value="-" disabled hidden>Selecione</option>
                                    {keycapsTypeOptions.slice(1).map((opt) => (
                                        <option key={opt} value={opt}>{opt}</option>
                                    ))}
                                </select>
                            </td>
                            <td className="border border-gray-300 p-2 text-center">
                                <Button
                                    icon="pi pi-trash"
                                    className="p-button-rounded p-button-danger p-button-sm"
                                    onClick={() => {
                                        const idx = products.findIndex(p => p.id === product.id);
                                        removeProduct(idx);
                                    }}
                                />
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>

            <div className="flex justify-content-end">
                <Button
                    label="Salvar"
                    icon="pi pi-save"
                    severity="success"
                    className="mt-3"
                    onClick={saveProducts}
                />
            </div>
        </div>
    );
}
