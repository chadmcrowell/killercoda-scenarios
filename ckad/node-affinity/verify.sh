#!/bin/bash

kubectl get po --field-selector spec.nodeName=controlplane -l 'app=az1-pod'