#!/bin/bash

# OpenClaw Token Optimization Verification Script
# Run this after implementing optimizations to verify everything is working

echo "🔍 OpenClaw Token Optimization Verification"
echo "============================================"
echo ""

# Check Ollama
echo "1. Checking Ollama installation..."
if command -v ollama &> /dev/null; then
    echo "   ✅ Ollama is installed"
    
    # Check if Ollama is running
    if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        echo "   ✅ Ollama is running"
        
        # Check for required models
        if ollama list | grep -q "llama3.2:3b"; then
            echo "   ✅ llama3.2:3b model is available"
        else
            echo "   ❌ llama3.2:3b not found. Run: ollama pull llama3.2:3b"
        fi
    else
        echo "   ❌ Ollama is not running. Run: ollama serve"
    fi
else
    echo "   ❌ Ollama not installed. Run: brew install ollama"
fi

echo ""

# Check OpenClaw
echo "2. Checking OpenClaw configuration..."
if command -v openclaw &> /dev/null; then
    echo "   ✅ OpenClaw is installed"
    
    # Check status
    STATUS=$(openclaw status 2>&1)
    
    if echo "$STATUS" | grep -q "haiku"; then
        echo "   ✅ Default model is set to Haiku (cheap)"
    else
        echo "   ⚠️  Default model may not be Haiku. Check: openclaw status"
    fi
    
    if echo "$STATUS" | grep -q "ollama"; then
        echo "   ✅ Ollama is configured"
    else
        echo "   ⚠️  Ollama may not be configured. Check config."
    fi
else
    echo "   ❌ OpenClaw not found in PATH"
fi

echo ""

# Check workspace files
echo "3. Checking workspace file sizes..."
WORKSPACE="${HOME}/clawd"

check_file_size() {
    local file=$1
    local max_kb=$2
    local name=$3
    
    if [ -f "$file" ]; then
        size=$(wc -c < "$file")
        size_kb=$((size / 1024))
        if [ $size_kb -le $max_kb ]; then
            echo "   ✅ $name: ${size_kb}KB (max: ${max_kb}KB)"
        else
            echo "   ⚠️  $name: ${size_kb}KB exceeds ${max_kb}KB limit"
        fi
    else
        echo "   ⏭️  $name: not found (skipping)"
    fi
}

check_file_size "$WORKSPACE/SOUL.md" 2 "SOUL.md"
check_file_size "$WORKSPACE/USER.md" 1 "USER.md"
check_file_size "$WORKSPACE/IDENTITY.md" 1 "IDENTITY.md"
check_file_size "$WORKSPACE/TOOLS.md" 2 "TOOLS.md"
check_file_size "$WORKSPACE/HEARTBEAT.md" 1 "HEARTBEAT.md"

echo ""
echo "============================================"
echo "Verification complete!"
echo ""
echo "If you see any ❌ or ⚠️, follow the IMPLEMENTATION.md guide to fix."
