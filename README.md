# crossplane-local-example


This repository provides a lightweight Kubernetes and Crossplane setup for the purpose of playing around with the tech.

Installed are:

1. A Kubernetes cluster via *kind*
2. The Crossplane core components
3. The Crossplane Github provider
4. An XRD resource to create example resources with a provided Github account

## Setup

### Prerequisites

Install kind, options for different OSs are [described here](https://kind.sigs.k8s.io/docs/user/quick-start/#installation).
For Linux, best use brew.

`brew install kind`

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

Switch back to the main folder.

`cd ..`

Apply the XRDs.

`kubectl apply -f xrds/contribution/`

Finally, apply the claim.

`kubectl apply -f customRepo.yaml`

## Content of the example

The composite example consist of the resources **repository**, **branch** and **branch-protection rule**.
While they are not used directly, they can be found in the `managed-resources` folder.

The XRD `CustomRepo` combines them into one object, that exposes just the repository name and passes it down to the described managed resources.
The definition and composition can be found in their respective yaml files.
