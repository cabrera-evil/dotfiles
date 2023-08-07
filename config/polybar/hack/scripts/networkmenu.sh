#!/usr/bin/env bash

# Define absolute path to the Rofi theme directory
dir="$HOME/.config/polybar/hack/scripts/rofi"
rofi_command="rofi -no-config -theme $dir/networkmenu.rasi"

# Function to get available Wi-Fi networks
get_available_wifi_networks() {
    nmcli -t -f ssid dev wifi list | grep -v '^--$'
}

# Get current network information
current_network_info="Current Network: $(nmcli -t -f active,ssid,device dev wifi | grep '^yes' | cut -d':' -f2,3)"

# Check if Wi-Fi and Bluetooth are enabled/disabled
wifi_status=$(nmcli -t -f wifi general | cut -d':' -f2)
bluetooth_status=$(bluetoothctl show | grep Powered | cut -d' ' -f2)

# Options
disable_wifi=" Disable WiFi"
enable_wifi=" Enable WiFi"
disable_bluetooth=" Disable Bluetooth"
enable_bluetooth=" Enable Bluetooth"
network_settings=" Network Settings"
bluetooth_settings=" Bluetooth Settings"
scan_wifi=" Scan WiFi Networks"
scan_bluetooth=" Scan Bluetooth Devices"

# Variable passed to Rofi
options=""

if [[ "$wifi_status" == "enabled" ]]; then
    options="$options\n$disable_wifi"
else
    options="$options\n$enable_wifi"
fi

if [[ "$bluetooth_status" == "enabled" ]]; then
    options="$options\n$disable_bluetooth"
else
    options="$options\n$enable_bluetooth"
fi

options="$options\n$network_settings\n$bluetooth_settings\n$scan_wifi\n$scan_bluetooth"

chosen="$(echo -e "$options" | tail -n +2 | $rofi_command -p "$current_network_info" -dmenu -selected-row 0)"
case $chosen in
$disable_wifi)
    nmcli radio wifi off
    ;;
$enable_wifi)
    nmcli radio wifi on
    ;;
$disable_bluetooth)
    bluetoothctl power off
    ;;
$enable_bluetooth)
    bluetoothctl power on
    ;;
$network_settings)
    nm-connection-editor
    ;;
$bluetooth_settings)
    blueman-manager
    ;;
$scan_wifi)
    networks=$(get_available_wifi_networks)
    chosen_network=$(echo "$networks" | $rofi_command -p "Available Networks" -dmenu -selected-row 0)
    if [ -n "$chosen_network" ]; then
        nmcli device wifi connect "$chosen_network"
    fi
    ;;
$scan_bluetooth)
    bluetoothctl scan on
    ;;
esac
