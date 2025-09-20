
# Kubernetes + Containerlab Cilium BGP Lab

This repository provides a reproducible lab environment for experimenting with Cilium BGP peering, using Kubernetes (Kind), Containerlab, and Cilium.

## Prerequisites

Ensure the following tools are installed:
- [Docker](https://docs.docker.com/engine/install/)
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
- [Containerlab](https://containerlab.dev/install/)
- [Cilium CLI](https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/#install-the-cilium-cli)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Quick Start

Clone this repository and run the following command to set up the lab:

```sh
make
```

This will:
- Create a Kind Kubernetes cluster (`make kind`)
- Deploy the Containerlab topology (`make clab`)
- Check node status (`make node-status`)

To run the full setup, including Cilium installation and BGP configuration:

```sh
make all
```

## Makefile Commands

- `make kind` — Create the Kind cluster using `cluster.yaml`.
- `make clab` — Deploy the Containerlab topology from `topo.yaml`.
- `make node-status` — Show Kubernetes node status.
- `make cilium` — Install Cilium with BGP and VXLAN enabled.
- `make wait-for-cilium` — Wait for Cilium to be ready.
- `make peering-policy` — Apply Cilium BGP peering policies (`cilium-bgp-peering-policies.yaml`).
- `make ippool` — Apply the public IP pool (`public-pool.yaml`).
- `make status` — Show system pod status.
- `make conn-test` — Run Cilium connectivity test.
- `make clean` — Remove both Kind and Containerlab environments.
- `make clean-kind` — Delete the Kind cluster.
- `make clean-clab` — Destroy the Containerlab topology.

## Clean Up

To remove all lab resources:

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

