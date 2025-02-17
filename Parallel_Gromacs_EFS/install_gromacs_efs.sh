#!/bin/bash
set -e

# Update system
sudo apt update
sudo apt upgrade
sudo apt install cmake -y
cmake -version
sudo apt install build-essential

#changing directory
cd gromacs-2022.3
mkdir build
cd build
# Install GROMACS
cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSION_DOWNLOAD=ON -DGMX_MPI=on
make
make check
sudo make install

# Activating GROMACS
source /usr/local/gromacs/bin/GMXRC

echo "GROMACS installation complete!"
#installing NFS
sudo apt install nfs-common -y 
sudo systemctl start nfs-utils
sudo systemctl status nfs-utils

# Mount EFS (will be automatically mounted via ParallelCluster)
sudo mkdir -p /shared/efs
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-0a0c571c98dcb5e93.efs.us-east-1.amazonaws.com:/ /shared/efs
