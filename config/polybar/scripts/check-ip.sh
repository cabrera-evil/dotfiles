#!/bin/bash

get_private_ip() {
    local private_ip
    private_ip=$(ip route get 8.8.8.8 | awk '{print $7}')
    echo "$private_ip"
}

private_ip=$(get_private_ip)

if [ -n "$private_ip" ]; then
    echo $private_ip
else
    echo "Error: Could not determine private IP address"
fi
