#!/bin/bash

sudo ip addr flush $1
sudo service networking restart


