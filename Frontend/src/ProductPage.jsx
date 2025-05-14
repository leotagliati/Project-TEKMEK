export function ProductPage({ product }) {
  return (
    <>
      <div className="container my-4">
        <div className="d-flex flex-column flex-lg-row border border-2 border-black p-3 gap-4">
          {/* Coluna das imagens */}
          <div className="col-12 col-md-6 border border-2 border-black p-2 d-flex flex-column">
            {/* Imagem principal */}
            <div className="d-flex justify-content-center flex-grow-1  mb-3" style={{ minHeight: '300px' }}>
              <img
                src={product.images[0]}
                alt="productphoto"
                className="img-fluid w-100 h-100 border border-2 border-black p-2"
                style={{ objectFit: 'contain' }}
              />
            </div>

            {/* Linha de imagens menores */}
            <div className="border border-2 border-black p-2 overflow-auto">
              <div className="d-flex flex-row flex-nowrap gap-3">
                {Object.entries(product.images).map(([key, url]) => (
                  <div
                    key={key}
                    style={{
                      aspectRatio: '1 / 1',
                      width: '100%',
                      maxWidth: '120px',
                      minWidth: '80px',
                      flex: '0 0 auto',
                    }}
                  >
                    <img
                      className="img-fluid border border-2 border-black rounded"
                      // src={url}
                      src="https://placehold.co/80x80"
                      alt={`Imagem do ângulo ${key}`}
                      style={{
                        width: '100%',
                        height: '100%',
                        objectFit: 'cover',
                      }}
                    />
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* Coluna de informações */}
          <div className="col-12 col-md-6 border border-2 border-black p-3">
            <h1>{product.name}</h1>
            <p>{product.description}</p>
            <h4 className="text-success">R$ {product.price}</h4>

            {/* Escolha dos componentes */}
            <div>
              {Object.entries(product.misc).map(([key, options]) => (
                <div key={key} className="mb-3">
                  <strong>{key.toUpperCase()}</strong>
                  <div className="d-flex gap-3 mt-2 flex-wrap">
                    {options.map((option) => (
                      <button key={option} className="btn btn-outline-secondary">
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

        {/* Avaliações */}
        <div className="mt-4">
          <h4 className="mb-3">Avaliações</h4>
          {/* Aqui entra seu código de reviews */}
        </div>
      </div>
    </>
  );
}
