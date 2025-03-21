#!/bin/bash
set -e  # Exit on any error

LAMBDA_NAME=$(basename "$PWD")

echo "🚀 Building $LAMBDA_NAME..."

# Move to the correct directory
cd "$(dirname "$0")"

# Verify requirements.txt exists
if [[ ! -f "requirements.txt" ]]; then
    echo "❌ ERROR: requirements.txt not found in $(pwd)"
    exit 1
fi

# Remove old package.zip if exists
rm -f package.zip  

# Install dependencies
pip install --upgrade -r requirements.txt -t .

# Create zip package
zip -r package.zip . -x "deploy.sh" "*.pyc" "__pycache__/*"

# Verify package.zip exists
if [[ ! -f "package.zip" ]]; then
    echo "❌ ERROR: package.zip was not created!"
    exit 1
fi

echo "✅ Build completed for $LAMBDA_NAME, package.zip created."
