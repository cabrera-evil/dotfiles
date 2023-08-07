#!/bin/bash

is_valid_ip() {
    local ip="$1"
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

get_private_ip() {
    local private_ip
    private_ip=$(ip route get 8.8.8.8 | awk '{print $7}')
    echo "$private_ip"
}

private_ip=$(get_private_ip)

if is_valid_ip "$private_ip"; then
    echo "Private: $private_ip"
else
    echo "Error: Private IP not found or invalid"
fi
