import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import App from './App.jsx'
import { LoginPage } from './LoginPage.jsx'
import 'bootstrap/dist/css/bootstrap.min.css';
import 'primereact/resources/themes/lara-light-blue/theme.css';
import 'primereact/resources/primereact.min.css';
import { ProductPage } from './ProductPage.jsx';

// Para aquele que resolveu fazer a sua task, ignora objetos criados nessa classe pq a maioria esta aqui para testar funcionalidade de uma pagina que precisa de referencia para ser criada
// So ir na root, comentar todos dentro de StrictMode e montar sua task
const mockProduct = {
  name: 'Teclado Mecânico RGB',
  description: 'Teclado mecânico com switches azuis, iluminação RGB e layout ABNT2.',
  price: 349.90,
  image: 'fotodotecladoparceiro'
}

createRoot(document.getElementById('root')).render(
  <StrictMode>
    {/* <LoginPage/> */}
    <ProductPage product={mockProduct} />
  </StrictMode>,
)
