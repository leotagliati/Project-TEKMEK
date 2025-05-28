#!/bin/bash

echo "=============================="
echo " Instalando dependências...  "
echo "=============================="

# Backend
echo "-> Backend: barramento-de-eventos"
cd Backend/barramento-de-eventos && npm install

echo "-> Backend: build-keyboard-service"
cd ../build-keyboard-service && npm install

echo "-> Backend: delivery-service"
cd ../delivery-service && npm install

echo "-> Backend: admin-product-manager"
cd ../admin-product-manager && npm install

# Voltar para a raiz
cd ../../

# Frontend
echo "-> Frontend"
cd Frontend && npm install

echo "=============================="
echo " Instalação completa com sucesso! ✅"
echo "=============================="
