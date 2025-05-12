import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import App from './App.jsx'
import { LoginPage } from './LoginPage.jsx'
import 'bootstrap/dist/css/bootstrap.min.css';
import 'primereact/resources/themes/lara-light-blue/theme.css';
import 'primereact/resources/primereact.min.css';

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <LoginPage/>
  </StrictMode>,
)
