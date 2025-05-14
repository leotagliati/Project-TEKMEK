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
            linha de fotos
          </div>
        </div>


        {/* Coluna de informações */}
        <div className="col ms-3 border border-2 border-black p-3">
          <h1>{product.name}</h1>
          <p>{product.description}</p>
          <h4 className="text-success">R$ {product.price}</h4>
          <div>
            ----ESCOLHA DOS TIPOS----

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