#!/bin/bash

echo "=============================="
echo " Instalando dependências...  "
echo "=============================="

# Backend
echo "-> Backend"
for dir in Backend/*/; do
  if [ -f "$dir/package.json" ]; then
    echo "Instalando dependências em: $dir"
    (cd "$dir" && npm install)
  else
    echo "Ignorando: $dir (sem package.json)"
  fi
done

# Voltar para a raiz
cd ../../

# Frontend
echo "-> Frontend"
cd Frontend && npm install

echo "=============================="
echo " Instalação completa com sucesso! ✅"
echo "=============================="
