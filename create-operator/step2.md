
So you have a working Golang application built with `kubebuilder`. Now it is time to add some business logic to create an operator.

Imagine you wanted to create a to-do app and want to deploy a number of custom versions of it (based on [this code](https://github.com/hariramjp777/frontend-todo-app) by [Hari Ram](https://dev.to/hariramjp777)).

You have already packaged your website application as a container image and now you want to deploy the first version of it.

You are well versed in how maintenance can create a lot of [toil](https://sre.google/sre-book/eliminating-toil/). You want to make sure that your deployment choices automate as much of the operations as possible.

To reduce toil for this application, you will create a Kubernetes operator. As the first phase of functionality, this operator will:

- **create** a new instance of the todo application as a website in a cluster if the cluster does not already have one
- **update** when the request changes in a known way
- **delete** a website instance upon request

Kubebuilder provides a command that can create both the `Controller` process and a new `Resource` type (CRD).

In this case, let's create a custom type called `Website`. Kubebuilder will automatically configure the operator to know about the type. Create these by running the following command from the `Tab 1` tab:

```bash
kubebuilder create api \
  --kind Website \
  --group killercoda \
  --version v1beta1 \
  --resource true \
  --controller true
```{{exec}}

Congratulations, you have officially generated your first operator!

At this stage, Kubebuilder has wired up two key components for your operator:

1. A Resource in the form of a Custom Resource Definition (CRD) with the kind Website.
2. A Controller that runs each time a Website CRD is create, changed, or deleted.

Next up, you will explore these two components in more detail.