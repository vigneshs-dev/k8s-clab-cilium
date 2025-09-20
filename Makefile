KUBECONFIG := $(HOME)/.kube/config

default: kind clab node-status

all: kind clab node-status cilium wait-for-cilium status peering-policy ippool 

kind:
	$(info Building Kind cluster.........)
	kind create cluster --config cluster.yaml

clab:
	$(info Building containerlab network routers....)
	sudo containerlab deploy -t topo.yaml

node-status:
	$(info Checking node status....) 
	kubectl get node -owide

cilium:
	$(info Installing Cilium........)
	cilium install --version=1.18.1 \
	  --helm-set ipam.mode=kubernetes \
	  --helm-set tunnel-protocol=vxlan \
	  --helm-set ipv4NativeRoutingCIDR="10.0.0.0/8" \
	  --helm-set bgpControlPlane.enabled=true \
	  --helm-set k8s.requireIPv4PodCIDR=true

wait-for-cilium:
	cilium status --wait

peering-policy:
	kubectl apply -f cilium-bgp-peering-policies.yaml
ippool:
	kubectl apply -f public-pool.yaml

status:
	kubectl get pods -n kube-system

conn-test:
	$(info Starting Cilium connectivity test....)
	cilium connectivity test

clean: clean-kind clean-clab

clean-kind:
	kind delete clusters clab-bgp

clean-clab:
	sudo containerlab destroy -t topo.yaml