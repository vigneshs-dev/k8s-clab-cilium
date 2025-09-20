### Overview

The [Bookinfo](https://istio.io/latest/docs/examples/bookinfo) application displays information about a book, similar to a single catalog entry of an online book store. Displayed on the page
is a description of the book, book details (ISBN, number of pages, and so on), and a few book reviews.

The `Bookinfo` application is broken into four separate microservices:

- `productpage` - calls the details and reviews microservices to populate the page.

# Bookinfo Microservices Demo for Kubernetes

The [Bookinfo](https://istio.io/latest/docs/examples/bookinfo) application is a sample microservices app that displays information about a book, similar to a product page in an online bookstore.

## Microservices Overview

Bookinfo is composed of four microservices:

- **productpage**: Calls the details and reviews microservices to populate the page.
- **details**: Provides book information.
- **reviews**: Shows book reviews and calls the ratings microservice.
- **ratings**: Supplies book ranking information for reviews.

For more details, see the [Bookinfo documentation](https://istio.io/latest/docs/examples/bookinfo).

---

## Deploying Bookinfo to Kubernetes

1. **Apply the manifests using Kustomize:**

	```sh
	kubectl apply -k kustomize/
	```

	This will create the `bookinfo` namespace and deploy all required resources.

2. **Verify the deployment:**

	```sh
	kubectl get all -n bookinfo
	```

	You should see pods, services, and deployments for all Bookinfo components.

3. **Access the application:**

	Port-forward the `productpage` service:

	```sh
	kubectl port-forward service/productpage -n bookinfo 9080:9080
	```

	Open your browser and go to [http://localhost:9080](http://localhost:9080) to view the Bookinfo product page.

	![Product Page Welcome](assets/images/product-page-welcome.png)

---

## Cleaning Up

To remove all Bookinfo resources:

```sh
kubectl delete ns bookinfo
```

> **Note:**
> Using `kubectl delete -k kustomize/` may fail if the namespace is deleted before the resources inside it. Deleting the namespace directly is the recommended cleanup method.