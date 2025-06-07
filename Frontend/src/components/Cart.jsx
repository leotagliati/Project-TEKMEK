// src/components/Cart.jsx
import React, { useState } from 'react';
import { Button } from 'primereact/button';
import { Dropdown } from 'primereact/dropdown';

export default function Cart() {
  const [items, setItems] = useState([
    { id: 1, name: 'Produto A', price: 100, quantity: 1, warranty: null },
    { id: 2, name: 'Produto B', price: 200, quantity: 1, warranty: null },
  ]);

  const handleRemove = (id) => {
    setItems(items.filter(item => item.id !== id));
  };

  const handleQuantityChange = (id, delta) => {
    setItems(items.map(item =>
      item.id === id
        ? { ...item, quantity: Math.max(1, item.quantity + delta) }
        : item
    ));
  };

  const handleWarrantyChange = (id, warranty) => {
    setItems(items.map(item =>
      item.id === id
        ? { ...item, warranty }
        : item
    ));
  };

  const finalizarCompra = () => {
    alert('Compra finalizada! Obrigado pela preferência.');
  };

  const warrantyOptions = [
    { label: 'Sem garantia', value: null },
    { label: '1 ano - R$ 30', value: '1ano' },
    { label: '2 anos - R$ 50', value: '2anos' },
  ];

  const total = items.reduce((acc, item) =>
    acc +
    item.price * item.quantity +
    (item.warranty === '1ano' ? 30 : item.warranty === '2anos' ? 50 : 0),
    0
  );

  return (
    <div className="container mt-4">
      <h2>Carrinho de Compras</h2>

      {items.length === 0 ? (
        <p>Seu carrinho está vazio.</p>
      ) : (
        items.map(item => (
          <div key={item.id} className="card mb-3 p-3">
            <div className="d-flex justify-content-between align-items-center">
              <div>
                <h5>{item.name}</h5>
                <p>Preço unitário: R$ {item.price.toFixed(2)}</p>

                <div className="d-flex align-items-center gap-2">
                  <Button label="-" onClick={() => handleQuantityChange(item.id, -1)} />
                  <span>Quantidade: {item.quantity}</span>
                  <Button label="+" onClick={() => handleQuantityChange(item.id, +1)} />
                </div>

                <div className="mt-2" style={{ maxWidth: '200px' }}>
                  <Dropdown
                    value={item.warranty}
                    options={warrantyOptions}
                    onChange={(e) => handleWarrantyChange(item.id, e.value)}
                    placeholder="Selecionar garantia"
                    optionLabel="label"
                  />
                </div>
              </div>

              <div>
                <Button
                  label="Remover"
                  className="p-button-danger"
                  onClick={() => handleRemove(item.id)}
                />
              </div>
            </div>
          </div>
        ))
      )}

      <h4>Total: R$ {total.toFixed(2)}</h4>
      <Button
        label="Finalizar Compra"
        className="p-button-success"
        onClick={finalizarCompra}
        disabled={items.length === 0}
      />
    </div>
  );
}
