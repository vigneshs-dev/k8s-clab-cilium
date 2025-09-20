#!/usr/bin/env bash

# Set error handling
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${YELLOW}[STATUS]${NC} $1"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Function to print error messages
print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Function to check if a command exists
check_command() {
    if ! command -v $1 &> /dev/null; then
        print_error "$1 command not found. Please install it first."
    fi
}

# Function to check if Kind cluster exists
check_kind_cluster() {
    if kind get clusters | grep -q "^clab-bgp$"; then
        return 0  # Cluster exists
    else
        return 1  # Cluster doesn't exist
    fi
}

# Function to check if Containerlab topology exists
check_containerlab() {
    if sudo containerlab inspect -t topo.yaml &>/dev/null; then
        return 0  # Topology exists
    else
        return 1  # Topology doesn't exist
    fi
}

# Function to verify cluster is accessible
verify_cluster_access() {
    if kubectl cluster-info &>/dev/null; then
        print_success "Kubernetes cluster is accessible"
        return 0
    else
        print_error "Cannot access Kubernetes cluster"
        return 1
    fi
}

# Check required commands
check_command kind
check_command kubectl
check_command cilium
check_command containerlab

# 1. Create Kind cluster
if check_kind_cluster; then
    print_status "Kind cluster already exists, skipping creation..."
else
    print_status "Creating Kind cluster..."
    if ! kind create cluster --name clab-bgp --config cluster.yaml; then
        print_error "Failed to create Kind cluster"
    fi
    print_success "Kind cluster created successfully"
fi

# 2. Deploy Containerlab topology
if check_containerlab; then
    print_status "Containerlab topology already exists, skipping deployment..."
else
    print_status "Deploying Containerlab network routers..."
    if ! sudo containerlab deploy -t topo.yaml --reconfigure; then
        print_error "Failed to deploy Containerlab topology"
    fi
    print_success "Containerlab topology deployed successfully"
fi

# 3. Check node status
print_status "Checking node status..."
verify_cluster_access

# Just verify nodes exist, don't wait for Ready state yet
if ! kubectl get nodes &>/dev/null; then
    print_error "No nodes found in the cluster"
fi

# Show current node status (likely NotReady, which is expected)
print_status "Current node status (NotReady is expected at this stage):"
kubectl get nodes -owide

# 4. Install Cilium if not already installed
if ! kubectl get pods -n kube-system -l k8s-app=cilium &>/dev/null; then
    print_status "Installing Cilium..."
    cilium install --version=1.18.1 \
    --helm-set ipam.mode=kubernetes \
    --helm-set tunnel-protocol=vxlan \
    --helm-set ipv4NativeRoutingCIDR="10.0.0.0/8" \
    --helm-set bgpControlPlane.enabled=true \
    --helm-set k8s.requireIPv4PodCIDR=true || print_error "Failed to install Cilium"
    print_success "Cilium installed successfully"
else
    print_status "Cilium is already installed"
fi

# 5. Wait for Cilium to be ready
print_status "Waiting for Cilium to be ready..."
if ! cilium status --wait; then
    print_error "Cilium not ready after timeout"
fi
print_success "Cilium is ready"

# Additional check for Cilium pods
print_status "Verifying Cilium pods..."
kubectl wait --for=condition=Ready pods -l k8s-app=cilium -n kube-system --timeout=300s || print_error "Cilium pods not ready after 5 minutes"
print_success "Cilium pods are running"

# Now check for node ready status after Cilium is up
print_status "Waiting for nodes to become Ready..."
if ! kubectl wait --for=condition=Ready nodes --all --timeout=300s; then
    print_error "Nodes not ready after 5 minutes"
fi
print_success "All nodes are now Ready"

# 6. Apply BGP peering policies
print_status "Applying Cilium BGP peering policies..."
if ! kubectl apply -f cilium-bgp-peering-policies.yaml; then
    print_error "Failed to apply BGP peering policies"
fi
print_success "BGP peering policies applied successfully"

# Wait for BGP to establish
print_status "Waiting for BGP sessions to establish..."
sleep 10  # Give some time for BGP sessions to establish

# 7. Apply IP pool
print_status "Applying public IP pool..."
if ! kubectl apply -f public-pool.yaml; then
    print_error "Failed to apply public IP pool"
fi
print_success "Public IP pool applied successfully"

print_success "Infrastructure deployment completed successfully!"

# Optional: Display final status
kubectl get pods -n kube-system
cilium status