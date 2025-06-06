
import { Button } from 'primereact/button'
import { InputText } from 'primereact/inputtext'
import { Password } from 'primereact/password'
import React, { useState } from 'react'
import axios from 'axios'
import { useNavigate } from 'react-router-dom'

export const LoginPage = () => {
    const [username, setUsername] = useState('')
    const [password, setPassword] = useState('')
    const [token, setToken] = useState('')
    const navigate = useNavigate()

    const handleSignUp = async () => {
        try {
            const response = await axios.post('http://localhost:5315/register', {
                username,
                password,
                token
            });
            console.log('User registered:', response.data);
        } catch (error) {
            console.error('Register error:', error.message);
            if (error.response && error.response.status === 400) {
                alert('Por favor, preencha os campos corretamente.')
            } else if (error.response.status == 401) {
                alert('Login e/ou senha inválidos.')
            }
            else {
                alert('Erro ao registrar.')
            }
        }
    }
    const handleSignIn = async () => {
        try {
            const response = await axios.post('http://localhost:5315/login', {
                username,
                password,
            
            });
            console.log('User logged:', response.data);

            const { accountId } = response.data;

            const isAdmin = response.data.isAdmin;
            localStorage.setItem("username", response.data.username)
            localStorage.setItem("idlogin", accountId)
            if (isAdmin) {
                navigate(`/admin/${accountId}`)
            }
            else{
                navigate(`/home/account/${accountId}`)
            }

        } catch (error) {
            console.error('Logging error:', error.message);
            if (error.response && error.response.status === 400) {
                alert('Por favor, preencha os campos corretamente.')
            } else if (error.response.status == 401) {
                alert('Login e/ou senha inválidos.')
            }
            else {
                alert('Erro ao loggar.')
            }
        }
    }

    return (
        <div className="container-fluid vh-100">
            <div className="row h-100">
                <div className="bg-primary col p-0">
                    <img
                        src=""
                        alt="UNDEFINED_Login_Illustration"
                        className="img-fluid h-100 w-100 object-fit-cover"
                    />
                </div>
                <div className="col-md-7 d-flex flex-column justify-content-center align-items-center bg-light">
                    <h2 className="mb-4">Bem-vindo de volta</h2>
                    <p>Por favor, entre com suas credenciais para continuar.</p>
                    <div className='d-flex flex-column justify-content-center gap-3 pb-4'>
                        <InputText placeholder='Username' onChange={(e) => setUsername(e.target.value)} />
                        <Password placeholder='Password' onChange={(e) => setPassword(e.target.value)} />
                        <p className='text-secondary small m-0 gap-0 pb-0 "'>Somente complete se for registrar novo admin</p>
                        <Password placeholder='Token' onChange={(e) => setToken(e.target.value)} />
                    </div>
                    <div className='d-flex flex-column-2 gap-2 mb-4'>
                        <Button label='Registre aqui' text onClick={handleSignUp}></Button>
                        <Button label='Esqueci a senha' text></Button>
                    </div>

                    <Button label="Sign In" rounded onClick={handleSignIn} />
                </div>
            </div>
        </div>
    )
}
