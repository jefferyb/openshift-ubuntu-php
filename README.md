# jefferyb/openshift-ubuntu-php

Apache with latest PHP on Ubuntu using OpenShift specific guidelines, built to run on Openshift/Kubernetes/Docker environment.

## Using Openshift CLI

```bash
# Deploy
$ oc new-app --name=ubuntu jefferyb/openshift-ubuntu-php
```

## Using Kubernetes CLI

```bash
# Deploy
$ kubectl run ubuntu --image=jefferyb/openshift-ubuntu-php
```

## Using Docker

```bash
# Deploy
$ docker run -itd --name ubuntu jefferyb/openshift-ubuntu-php
```
