#!/bin/bash

# 1. Instalar o Grupo Base de Wayland e Hyprland
echo "[*] Instalando Hyprland e drivers..."
sudo dnf install -y hyprland waybar rofi-wayland kitty fish atuin \
    swaybg pipewire wireplumber xdg-desktop-portal-hyprland \
    polkit-gnome qt6-qtwayland qt5-qtwayland

# 2. Ferramentas de Pentest e Rede
echo "[*] Instalando ferramentas de Pentest..."
sudo dnf install -y nmap wireshark tcpdump john hashcat socat openvpn

# 3. Configuração do Shell (Fish + Atuin)
sudo chsh -s /usr/bin/fish $USER
mkdir -p ~/.config/fish
cat <<EOF > ~/.config/fish/config.fish
if status is-interactive
    atuin init fish | source
end
alias htb-vpn='sudo openvpn --config'
EOF

# 4. Criar Configuração Mínima do Hyprland
mkdir -p ~/.config/hypr
cat <<EOF > ~/.config/hypr/hyprland.conf
monitor=,preferred,auto,1
exec-once = waybar & swaybg -m fill -i /usr/share/backgrounds/f39/default/f39-0-light.png

input {
    kb_layout = br
}

\$mainMod = SUPER

bind = \$mainMod, Return, exec, kitty
bind = \$mainMod SHIFT, Q, killactive,
bind = \$mainMod, D, exec, rofi -show drun
bind = \$mainMod SHIFT, E, exit,

# Tiling (Dwindle)
gestures { workspace_swipe = on }
EOF

# 5. Configurar a Waybar para mostrar a VPN (tun0)
mkdir -p ~/.config/waybar
cat <<EOF > ~/.config/waybar/config
{
    "layer": "top",
    "modules-left": ["hyprland/workspaces"],
    "modules-right": ["network", "cpu", "memory", "clock"],
    "network": {
        "interface": "tun0",
        "format": "VPN: {ipaddr}",
        "format-disconnected": "VPN: OFF"
    }
}
EOF

echo "[+] Instalação concluída. Digite 'Hyprland' para iniciar."
