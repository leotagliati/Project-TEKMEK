import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import { LoginPage } from './LoginPage.jsx'
import { ProductPage } from './ProductPage.jsx';
import { ProductSearchPage } from './ProductSearchPage.jsx';
import AdminSheet from './AdminSheet.jsx'

function App() {
  const [count, setCount] = useState(0)


  // Para aquele que resolveu fazer a sua task, ignora objetos criados nessa classe pq a maioria esta aqui para testar funcionalidade de uma pagina que precisa de referencia para ser criada
  // So ir na root, comentar todos dentro de StrictMode e montar sua task

  return (
    <>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route path="/product/:title" element={<ProductPage />} />
          <Route path="/home" element={<ProductSearchPage />} />
          <Route path="/home/account/:idlogin" element={<ProductSearchPage />} />
          <Route path="/" element={<Navigate to="/home" replace />} />
          <Route path="/admin/account/:idlogin" element={<AdminSheet></AdminSheet>} />

        </Routes>

      </BrowserRouter>
    </>
  )
}

export default App
