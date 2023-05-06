#!/bin/bash

history >> /tmp/history.txt

cat /tmp/history.txt | grep -i 'kubeadm upgrade plan'