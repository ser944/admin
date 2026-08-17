#!/bin/bash
set -e

echo "===== Atualizando sistema ====="
dnf update -y

echo "===== Instalando ambiente gráfico (Xfce leve) ====="
dnf install -y @xfce-desktop-environment xorg-x11-server-Xvfb

echo "===== Instalando VNC e noVNC ====="
dnf install -y tigervnc-server tigervnc-server-module
dnf install -y git python3-websockify

# Baixa noVNC para acesso via navegador
git clone https://github.com/novnc/noVNC /opt/noVNC
git clone https://github.com/novnc/websockify /opt/websockify

echo "===== Configurando VNC ====="
# Define senha fixa
mkdir -p /root/.vnc
echo "fedora123" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# Arquivo de inicialização do Xfce
cat > /root/.vnc/xstartup << 'INNER'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
startxfce4 &
INNER
chmod +x /root/.vnc/xstartup

echo "===== Iniciando servidor VNC ====="
vncserver -localhost no :1 -geometry 1280x720 -depth 24

echo "===== Iniciando noVNC (acesso web) ====="
/opt/websockify/websockify --web /opt/noVNC 6080 localhost:5901 &

echo "===== SETUP CONCLUÍDO! ====="
echo "Acesse via navegador: porta 6080"
echo "Senha VNC: fedora123"
