#!/bin/bash
# Prep script for Killercoda lab

# Simulate a failing kubelet on node01
ssh node01 "sudo systemctl stop kubelet"
