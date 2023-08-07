#!/bin/bash

is_valid_ip() {
    local ip="$1"
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

get_public_ip() {
    local public_ip
    public_ip=$(curl -s ifconfig.me)
    echo "$public_ip"
}

public_ip=$(get_public_ip)

if is_valid_ip "$public_ip"; then
    echo "Public: $public_ip"
else
    echo "Error: Public IP not found or invalid"
fi
