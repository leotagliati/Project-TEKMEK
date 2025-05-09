
import { Button } from 'primereact/button'
import { FloatLabel } from 'primereact/floatlabel';
import { InputText } from 'primereact/inputtext';
import { Password } from 'primereact/password';
import React from 'react'

export const LoginPage = () => {
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
                        <InputText placeholder='Username' />
                        <Password placeholder='Password' />

                    </div>
                    <div className='d-flex flex-column-2 gap-2 mb-4'>
                        <Button label='Registre aqui' text></Button>
                        <Button label='Esqueci a senha' text></Button>
                    </div>

                    <Button label="Sign In" rounded />
                </div>
            </div>
        </div>
    )
}
