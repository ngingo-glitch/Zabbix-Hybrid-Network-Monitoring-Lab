#!/bin/bash
# Hybrid Cloud Monitoring Connectivity Test Script

echo "=== Zabbix Hybrid Cloud Monitoring Test ==="
echo "Testing connectivity across hybrid infrastructure..."
echo

# Configuration
ZABBIX_SERVER="<ZABBIX_SERVER_IP>"
LOCAL_CLIENT="<CLIENT_IP>"
AWS_INSTANCE="<AWS_INSTANCE_IP>"

# Test local network monitoring
echo "1. Testing Local Network Monitoring..."
if command -v zabbix_get >/dev/null 2>&1; then
    echo "   Testing local client connectivity..."
    if zabbix_get -s "$LOCAL_CLIENT" -k agent.ping >/dev/null 2>&1; then
        echo "   ✅ Local client connectivity: SUCCESS"
    else
        echo "   ❌ Local client connectivity: FAILED"
    fi
else
    echo "   ⚠️  zabbix_get not found, skipping connectivity tests"
fi

# Test VPN tunnel
echo
echo "2. Testing VPN Tunnel..."
if ping -c 1 "$AWS_INSTANCE" >/dev/null 2>&1; then
    echo "   ✅ VPN tunnel connectivity: SUCCESS"
    
    # Test AWS instance monitoring
    echo "   Testing AWS instance monitoring..."
    if command -v zabbix_get >/dev/null 2>&1; then
        if zabbix_get -s "$AWS_INSTANCE" -k agent.ping >/dev/null 2>&1; then
            echo "   ✅ AWS instance monitoring: SUCCESS"
        else
            echo "   ❌ AWS instance monitoring: FAILED"
        fi
    fi
else
    echo "   ❌ VPN tunnel connectivity: FAILED"
fi

# Test VPN interface
echo
echo "3. Testing VPN Interface..."
if ip a show ip_vti0 >/dev/null 2>&1; then
    echo "   ✅ VPN interface (ip_vti0): UP"
else
    echo "   ❌ VPN interface (ip_vti0): DOWN"
fi

echo
echo "=== Test Complete ==="
