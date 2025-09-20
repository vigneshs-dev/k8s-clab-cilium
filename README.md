# Kubernetes + Containerlab Cilium BGP Lab

# Kubernetes + Containerlab Cilium BGP Lab

This repository provides a comprehensive lab environment for experimenting with Cilium BGP peering, Kubernetes networking, and microservices deployment. It combines network emulation, Kubernetes cluster management, and sample application deployment for learning and testing purposes.

This repository provides a reproducible lab environment for experimenting with Cilium BGP peering, using Kubernetes (Kind), Containerlab, and Cilium.

## Repository Structure

## Prerequisites

- **topology/**: Contains all files related to the network topology, Kubernetes cluster setup, and Cilium BGP configuration.

  - `Makefile`: Automation for lab setup, teardown, and status checks.Ensure the following tools are installed:

  - `cluster.yaml`: Kind cluster configuration.- [Docker](https://docs.docker.com/engine/install/)

  - `topo.yaml`: Containerlab topology definition.- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)

  - `cilium-bgp-peering-policies.yaml`: Cilium BGP peering policy.- [Containerlab](https://containerlab.dev/install/)

  - `public-pool.yaml`: Cilium IP pool configuration.- [Cilium CLI](https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/#install-the-cilium-cli)

  - `netshoot-ds.yaml`: DaemonSet for network troubleshooting.- [kubectl](https://kubernetes.io/docs/tasks/tools/)

  - `usage_cmds.txt`: Useful command references.

  - **clab-bgp-cplane/**: Inventories and data for network automation (Ansible, Nornir) and Containerlab.## Quick Start



- **bookinfo/**: Sample microservices application for Kubernetes.Clone this repository and run the following command to set up the lab:

  - `README.md`: Instructions for deploying and testing the Bookinfo app.

  - **kustomize/**: Kustomize manifests for deploying Bookinfo.```sh

    - `kustomization.yaml`: Main kustomize file.make

    - **resources/**: Namespace and service definitions for Bookinfo.```



## What You Can Do With This LabThis will:

- Create a Kind Kubernetes cluster (`make kind`)

- **Emulate a BGP-enabled network** using Containerlab and Cilium's BGP control plane features.- Deploy the Containerlab topology (`make clab`)

- **Deploy a Kubernetes cluster** (Kind) and install Cilium as the CNI.- Check node status (`make node-status`)

- **Test BGP peering and IP pool management** in a realistic, reproducible environment.

- **Deploy and explore the Bookinfo microservices app** to test service connectivity, load balancing, and more.To run the full setup, including Cilium installation and BGP configuration:



## Quick Start

1. **Clone this repository**

2. **Follow the instructions in `topology/README.md`** to set up the network and Kubernetes cluster.

3. **Deploy the Bookinfo app** by following `bookinfo/README.md`.## Makefile Commands



## Requirements- `make kind` — Create the Kind cluster using `cluster.yaml`.

- `make clab` — Deploy the Containerlab topology from `topo.yaml`.

- Docker- `make node-status` — Show Kubernetes node status.

- Kind- `make cilium` — Install Cilium with BGP and VXLAN enabled.

- Containerlab- `make wait-for-cilium` — Wait for Cilium to be ready.

- Cilium CLI- `make peering-policy` — Apply Cilium BGP peering policies (`cilium-bgp-peering-policies.yaml`).

- kubectl- `make ippool` — Apply the public IP pool (`public-pool.yaml`).

- `make status` — Show system pod status.

## References- `make conn-test` — Run Cilium connectivity test.

- [Cilium Documentation](https://docs.cilium.io/)- `make clean` — Remove both Kind and Containerlab environments.

- [Containerlab Documentation](https://containerlab.dev/)- `make clean-kind` — Delete the Kind cluster.

- [Kind Documentation](https://kind.sigs.k8s.io/)- `make clean-clab` — Destroy the Containerlab topology.

- [Bookinfo Sample App](https://istio.io/latest/docs/examples/bookinfo)

## Clean Up

---

To remove all lab resources:

Feel free to explore, experiment, and contribute!

```sh
make clean
```

## File Structure

- `cluster.yaml` — Kind cluster configuration
- `topo.yaml` — Containerlab topology
- `cilium-bgp-peering-policies.yaml` — Cilium BGP peering policy
- `public-pool.yaml` — Cilium IP pool
- `Makefile` — Automation for lab setup/teardown

## Notes

- You can run individual steps by invoking the corresponding `make` target.
- The lab is self-contained and can run alongside other labs if your machine has sufficient resources.

## References

- [Cilium BGP Docs](https://docs.cilium.io/en/stable/network/bgp/)
- [Containerlab Docs](https://containerlab.dev/)
- [Kind Docs](https://kind.sigs.k8s.io/)

---

Feel free to open issues or PRs for improvements!

