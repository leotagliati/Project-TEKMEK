import { useParams } from 'react-router-dom';
import { useEffect, useState } from 'react';
import client from './utils/searchClient.js'


export function ProductPage() {
  const { id } = useParams();
  const [product, setProductData] = useState(null);


  useEffect(() => {
    client.get(`/product/${id}`)
      .then((response) => {
        setProductData(response.data);
      })
      .catch((error) => {
        console.error('Erro ao buscar produto:', error);
      });
  }, [id]);

  if (!product) {
    return <div className="p-5">Produto nao encontrado...</div>;
  }
  const mockImages = {
    front: 'https://placehold.co/80x80?text=Frente',
    back: 'https://placehold.co/80x80?text=Verso',
    left: 'https://placehold.co/80x80?text=Esquerda',
    right: 'https://placehold.co/80x80?text=Direita',
  }

  return (
    <>
      <div className=" container my-4 ">
        <div className="d-flex flex-column flex-lg-row border border-2 border-black p-3 gap-3">
          {/* Coluna das imagens */}
          <div className="d-flex border flex-grow-1 border-2 border-black p-2 flex-column gap-3">
            {/* Imagem principal */}
            <div className="d-flex justify-content-center flex-grow-1  mb-3" style={{ maxHeight: '500px' }}>
              <img
                src={'https://placehold.co/500x500'}
                alt="productphoto"
                className="img-fluid w-100 h-100 border border-2 border-black p-2"
              />
            </div>

            {/* Linha de imagens menores */}
            <div className="border border-2 border-black p-2 overflow-auto">
              <div className="d-flex  flex-row flex-nowrap gap-3">
                {Object.entries(product.images || mockImages).map(([key, url]) => (
                  <div
                    key={key}
                    style={{
                      aspectRatio: '1 / 1',
                      width: '100%',
                      maxWidth: '80px',
                      minWidth: '80px',
                      flex: '0 0 auto',
                    }}
                  >
                    <img
                      className="img-fluid border border-2 border-black rounded"
                      // src={url}
                      src={mockImages[key]}
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
          <div className="border border-2 border-black p-3">
            <h1>{product.name}</h1>
            <p>{product.description}</p>
            <h4 className="text-success">R$ {product.price}</h4>

            {/* Escolha dos componentes */}
            <div>
              {Object.entries(product.misc || {}).map(([key, options]) => (
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
