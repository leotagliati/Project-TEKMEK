export function ProductPage({ product }) {
  return (
    <>
      <div className="d-flex border border-2 border-black p-3">
        {/* Coluna da imagem */}
        <div className="d-flex row col-4 border border-2 border-black p-2 justify-content-center">
          <img
            src={product.image}
            alt="productphoto"
            className="img-fluid border border-2 border-black p-2"
          />
          {/* Linha de imagens em outras posicoes*/}
          <div className="border border-2 border-black p-2">
            ----LINHA DE ANGULOS----
          </div>
        </div>


        {/* Coluna de informaces */}
        <div className="col ms-3 border border-2 border-black p-3">
          <h1>{product.name}</h1>
          <p>{product.description}</p>
          <h4 className="text-success">R$ {product.price}</h4>

          {/* Escolha dos componentes*/}
          <div>
            {Object.entries(product.misc).map(([key, options]) => (
              <div key={key} style={{ marginBottom: '1rem' }}>
                <strong>{key.toUpperCase()}</strong>
                <div style={{ display: 'flex', gap: '1rem', marginTop: '0.5rem' }}>
                  {options.map((option) => (
                    <button key={option} style={{ padding: '0.5rem 1rem' }}>
                      {option}
                    </button>
                  ))}
                </div>
              </div>
            ))}
          </div>

          <button className="btn btn-primary mt-3">Adicionar ao carrinho</button>
        </div>
      </div>

      {/* Coluna de Avaliacao */}
      <div className="col  border border-2 border-black p-3">
        -----AVALIACOES-----
      </div>
    </>
  );
}