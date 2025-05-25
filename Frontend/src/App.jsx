import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import { LoginPage } from './LoginPage.jsx'
import { ProductPage } from './ProductPage.jsx';

function App() {
  const [count, setCount] = useState(0)


  // Para aquele que resolveu fazer a sua task, ignora objetos criados nessa classe pq a maioria esta aqui para testar funcionalidade de uma pagina que precisa de referencia para ser criada
  // So ir na root, comentar todos dentro de StrictMode e montar sua task
  const mockProduct = {
    name: 'Teclado Mecânico RGB',
    description: 'Teclado mecânico com switches azuis, iluminação RGB e layout ABNT2.',
    price: 349.90,
    images: [
      'url-do-produto-frontal.jpg',
      'url-do-produto-lateral.jpg',
      'url-do-produto-traseira.jpg',
      'url-do-produto-iluminado.jpg'
    ],
    misc: {
      color: ['Carbon-Shell', 'White-Shell'],
      type: ['fully-assembled', 'barebone'],
      switches: ['Gateron Jupiter Banana', 'Gateron Jupiter Brown']
    }
  }
  return (
    <>
      <ProductPage product={mockProduct} />
    </>
  )
}

export default App
