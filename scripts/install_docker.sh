#!/bin/bash
curl -fsSL https://get.docker.com | bash
systemctl enable docker
systemctl start docker
