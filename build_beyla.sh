#!/bin/bash

# clone beyla from github
if [ -d beyla ]; then
  echo "already clone beyla from github"
else
  git clone https://github.com/marz32one/beyla.git
fi

# Set the Go version (leave empty to get the latest version)
GO_VERSION="1.25.5"

# Set the download URL for the Go installer
URL="https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz"

# Check if Go is already installed
if [ -d /usr/local/go ]; then
  echo "Go is already installed. Skipping installation."
else
  # Download the Go installer
  echo "Downloading Go installer..."
  curl -LO "$URL"

  # Extract the Go installer
  echo "Extracting Go installer..."
  sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"

  # Set the Go environment variables
  echo "Setting Go environment variables..."
  sudo update-alternatives --install /usr/bin/go go /usr/local/go/bin/go 1
  sudo update-alternatives --install /usr/bin/godoc godoc /usr/local/go/bin/godoc 1
fi

# Verify that Go is installed correctly
echo "Verifying Go installation..."
go version

# build beyla
cd beyla
git checkout dev
make vendor-obi
# skip buildup arm64 platform
docker buildx build --build-arg GEN_IMG="ghcr.io/open-telemetry/obi-generator:latest" --platform linux/amd64 -t "docker.io/grafana/beyla:dev" .
