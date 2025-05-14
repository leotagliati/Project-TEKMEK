export function ProductPage({ product }) {
  return (
    <>
      <div className="d-flex border border-2 border-black p-3">
        {/* Coluna da imagem */}
        <div className="d-flex row col-4 border border-2 border-black p-2 justify-content-center">
          <img
            src={product.images[0]}
            alt="productphoto"
            className="img-fluid border border-2 border-black p-2"
          />
          {/* Linha de imagens em outras posicoes*/}
          <div className="border border-2 border-black p-2">
            <div
              className="d-flex flex-row flex-nowrap gap-3 justify-content-start p-2"
            >
              {Object.entries(product.images).map(([key, url]) => (
                <div key={key} >
                  <img
                    src={url}
                    alt={`Imagem do ângulo ${key}`}
                    style={{
                      width: '100%',
                      height: '100%',
                      objectFit: 'cover',
                      borderRadius: '8px',
                      border: '2px solid black',
                    }}
                  />
                </div>
              ))}
            </div>
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
      <div className="mt-4">
        <h4 className="mb-3">Avaliações</h4>
        
      </div>
    </>
  )
}