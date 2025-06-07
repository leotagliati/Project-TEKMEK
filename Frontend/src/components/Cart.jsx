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
    <div className="container my-4">
      <h2 className="text-center mb-4">Carrinho de Compras</h2>

      {items.length === 0 ? (
        <p className="text-center">Seu carrinho está vazio.</p>
      ) : (
        items.map(item => (
          <div key={item.id} className="card mb-4 shadow-sm">
            <div className="card-body">
              <h5 className="mb-2">{item.name}</h5>
              <p className="mb-2">Preço unitário: R$ {item.price.toFixed(2)}</p>

              {/* Quantidade */}
              <div className="d-flex align-items-center gap-2 mb-3">
                <Button label="−" onClick={() => handleQuantityChange(item.id, -1)} />
                <span className="fw-bold">Quantidade: {item.quantity}</span>
                <Button label="+" onClick={() => handleQuantityChange(item.id, +1)} />
              </div>

              {/* Garantia */}
              <div style={{ maxWidth: '250px' }} className="mb-3">
                <Dropdown
                  value={item.warranty}
                  options={warrantyOptions}
                  onChange={(e) => handleWarrantyChange(item.id, e.value)}
                  placeholder="Selecionar garantia"
                  optionLabel="label"
                  className="w-100"
                />
              </div>

              {/* Botão remover */}
              <div>
                <Button
                  label="Remover"
                  className="p-button-danger w-100 w-md-auto"
                  onClick={() => handleRemove(item.id)}
                />
              </div>
            </div>
          </div>
        ))
      )}

      {/* Total e Finalizar */}
      <div className="row mt-4">
        <div className="col-12 col-md-6 offset-md-3 text-center">
          <h4 className="mb-3">Total: R$ {total.toFixed(2)}</h4>
          <Button
            label="Finalizar Compra"
            className="p-button-success w-100 w-md-auto"
            onClick={finalizarCompra}
            disabled={items.length === 0}
          />
        </div>
      </div>
    </div>
  );
}
