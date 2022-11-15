
In order to extend the operator, add this new function named `newDeployment` that will create a deployment for your website to run.

This function encapsulates the instructions for how to create a customized deployment for your website.

Add the following code to the end of the file `~/src/controllers/website_controller.go`:

```bash
sudo wget -O ${HOME}/src/controllers/website_controller.go "https://raw.githubusercontent.com/chadmcrowell/k8s/main/operators/website_controller.go"
```

```go
// Create a deployment with the correct field values. By creating this in a function,
// it can be reused by all lifecycle functions (create, update, delete).
func newDeployment(name, namespace, imageTag string) *appsv1.Deployment {
  replicas := int32(2)

  return &appsv1.Deployment{
    ObjectMeta: metav1.ObjectMeta{
      Name:      name,
      Namespace: namespace,
      Labels:    setResourceLabels(name),
    },
    Spec: appsv1.DeploymentSpec{
      Replicas: &replicas,
      Selector: &metav1.LabelSelector{MatchLabels: setResourceLabels(name)},
      Template: corev1.PodTemplateSpec{
        ObjectMeta: metav1.ObjectMeta{Labels: setResourceLabels(name)},
        Spec: corev1.PodSpec{
          Containers: []corev1.Container{
            {
              Name: "nginx",
              // This is a publicly available container.  Note the use of
              //`imageTag` as defined by the original resource request spec.
              Image: fmt.Sprintf("abangser/todo-local-storage:%s", imageTag),
              Ports: []corev1.ContainerPort{{
                ContainerPort: 80,
              }},
            },
          },
        },
      },
    },
  }
}
```

💾 Once this change is complete. Remember to save the file with `ctrl+s` (or `⌘ + s` on a mac).

It is all well and good to tell the operator to create a deployment, but is it allowed? In Kubernetes there is strict role based access control (RBAC) that limits what actions people and applications can take.

With this new change, we now need allow the operator to work with deployments. Kubebuilder provides a mechanism to do this through powerful comments, much like those used in the CRD fields.

Look near the top of the `website_controller.go` file for comment lines that start with `//+kubebuilder:rbac` (around line 38). Each line describes a single RBAC permission.

To provide access to work with deployments, you need to add the following permission line:

```go
//+kubebuilder:rbac:groups=apps,resources=deployments,verbs=get;list;watch;create;update;patch;delete
```{{copy}}

💾 Once this change is complete. Remember to save the file with `ctrl+s` (or `⌘ + s` on a mac).

Kubebuilder translates this change into necessary service accounts when you build the deployment.

> 💡 Note that this is a broad permission since it allows all verbs. These can be limited when tighter security is necessary.

