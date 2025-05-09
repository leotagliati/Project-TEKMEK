import React from 'react'

export const LoginPage = () => {
    return (
        <div className="container-fluid vh-100">
            <div className="row h-100">
                <div className="col-md-6 p-0">
                    <img
                        src="https://via.placeholder.com/800x800"
                        alt="Login Illustration"
                        className="img-fluid h-100 w-100 object-fit-cover"
                    />
                </div>

                <div className="col-md-6 d-flex flex-column justify-content-center align-items-center bg-light">
                    <h2 className="mb-4">Bem-vindo de volta</h2>
                    <p>Por favor, entre com suas credenciais para continuar.</p>
                </div>
            </div>
        </div>
    )
}
