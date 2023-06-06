# crossplane-local-example

This repository provides a lightweight Kubernetes and Crossplane setup for the purpose of playing around with the tech.

Installed are:

1. A Kubernetes cluster via *kind*
2. The Crossplane core components
3. The Crossplane Github provider
4. An XRD resource to create example resources with a provided Github account

## Content of the example

The composite example consist of the resources **repository**, **branch** and **branch-protection rule**.
While they are not used directly, they can be found in the `managed-resources` folder.

The XRD `CustomRepo` combines them into one object, that exposes just the repository name and passes it down to the described managed resources.
The definition and composition can be found in their respective yaml files.

## Setup

### Prerequisites

Install `kind`, options for different OSs are [described here](https://kind.sigs.k8s.io/docs/user/quick-start/#installation).
For Linux, best use brew.

`brew install kind`

Install `kubectl` to connect to the newly created local cluster. Different options are [described here](https://kubernetes.io/docs/tasks/tools/#kubectl).
For Linux, best use brew.

`brew install kubernetes-cli`

Install `helm` in the same fashion. Options for different OSs are [described here](https://helm.sh/docs/intro/install/).
For Linux, best use brew.

`brew install helm`

If not done yet, create a Github account.
[Now follow the linked tutorial](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) and create an access token 
that allows for the **creation of new repositories**, **branches** and **branch-protection rules**.

Open the following file: `providers/github/provider-secret.yaml`.

Substitute the following phrases from the secret credentials: 

1. GITHUB_TOKEN for your newly created token
2. GITHUB_OWNER for your username

**In case this is a fork or clone, do not push your credentials!**

Bash solutions like `envsubst` have not been used to keep this example as OS independent as possible.

### Installation

Switch into the setup-scripts folder.

`cd setup-scripts`

Execute setupCluster.sh to create the kind-cluster and set the proper Kubernetes context.

`./setupCluster.sh`

Execute setupProvider.sh to install the Github-provider and its access credentials.

`./setupProvider.sh`

Execute setupArgoCD.sh to install ArgoCD and set up the apps.

`./setupArgoCD.sh`

Finally, execute connectArgoCD.sh to prompt the local admin password and port forward ArgoCD to localhost:8080.

`./connectArgoCD.sh`

### Check and sync the resources in ArgoCD

Call [http://localhost:8080](http://localhost:8080) and use the following credentials for the initial login:  

```
user: admin  
password: the password prompted by the connectArgoCD.sh script  
```

The XRD resources should be automatically synced, as soon as the app is created. After checking if the `xrds` app is healthy, enter the `github-example` and sync it, to create the desired claim.

### Check the resources in the terminal

After installing and syncing everything properly, take a look at what you created in the terminal.

First the installed provider.

`kubectl describe providers provider-github`

In the status, you can deduce that it is healthy and ready to use.

Also assess that the XRD has been created and is available.

`kubectl describe composition customrepo`  
`kubectl describe compositeresourcedefinition xcustomrepos.github.kasnockndave.dev`

Check the applied claim.

`kubectl describe -n default customRepo crossplane-demo-repository`

Notice how this claim is explicitly **namespaced**. 
Now **role-based access rules** can be introduced to give persons and groups that are not platform administrators proper permissions to this namespace.

Lastly, check the cluster-wide managed resources that have been created when the composition was instantiated.

`kubectl get repository`  
`kubectl get branch`  
`kubectl get branchprotection`

If all the resources are healthy and synced, open your Github account page.
Under **Repositories** a new one should pop up.
After opening the repo, under **branches** and **settings** the resources represented in Kubernetes should appear.

## Troubleshooting

Executing the bash scripts might fail if the tools necessary have not been set up properly.
Please take a look at the **Prerequisites** section to set them up.

In case nothing is happening in your Github account, check if the claim is healthy.

`kubectl describe -n default customRepo crossplane-demo-repository`

If the status / event messages shows you an error, take a closer look at the managed resource that is the origin of the error.
Let's assume the repository resource is the reason.

Get the resource name, then describe it.

`kubectl get repository`  
`kubectl describe repository {insert-uniquely-generated-resource-name}`

Finally the output will show you why applying it to Github is failing. 
Most likely it's going to have to do with the **access token permissions**.
Please take a look at the **Prerequisites** page and try out different permissions, especially if you decide to extend the example.
