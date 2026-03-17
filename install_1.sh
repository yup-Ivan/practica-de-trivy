#!/bin/bash

# +--------------------+
#  INSTALACIÓN TRIVY (Kali / Debian / Ubuntu modernos)
# +--------------------+

set -e
export DEBIAN_FRONTEND=noninteractive

echo "Actualizando paquetes..."
sudo apt-get update -y

echo "Instalando dependencias..."
sudo apt-get install -y wget apt-transport-https curl gnupg

# Obtener nombre de la distribución (bullseye, bookworm, kali-rolling…)
distro="$(lsb_release -sc)"

echo "Añadiendo clave GPG de Trivy..."
curl -fsSL https://aquasecurity.github.io/trivy-repo/deb/public.key \
    | sudo gpg --dearmor -o /usr/share/keyrings/trivy.gpg

echo "Añadiendo repositorio de Trivy..."
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $distro main" \
    | sudo tee /etc/apt/sources.list.d/trivy.list

echo "Instalando Trivy..."
sudo apt-get update -y
sudo apt-get install -y trivy

# +--------------------+
#   Container-diff
# +--------------------+

echo "Instalando container-diff..."
sudo wget -O /usr/local/bin/container-diff \
    https://storage.googleapis.com/container-diff/v0.16.0/container-diff-linux-amd64
sudo chmod +x /usr/local/bin/container-diff

# +--------------------+
#   Docker
# +--------------------+

if [[ "$GITHUB_ACTIONS" == "true" ]]; then
    echo "Ejecutando en GitHub Actions — Docker ya está instalado."
else
    echo "Instalando Docker..."
    sudo apt-get install -y docker.io
    sudo usermod -aG docker $USER
fi

echo "----------------------------------------------------------------"
echo "Instalación finalizada correctamente"
echo "Trivy instalado en: /usr/bin/trivy"
echo "container-diff en: /usr/local/bin/container-diff"
echo "----------------------------------------------------------------"