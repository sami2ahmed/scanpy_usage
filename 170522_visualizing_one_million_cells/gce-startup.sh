#! /bin/bash

# See https://cloud.google.com/compute/docs/startupscript

sudo apt-get update && sudo apt-get install -y git python3-pip python3-tk
pip3 install scanpy

# Checkout this repo
git clone https://github.com/theislab/scanpy_usage
cd scanpy_usage/170522_visualizing_one_million_cells

# Copy 10x data locally
gsutil -u hca-scale cp gs://ll-sc-data/10x/1M_neurons_filtered_gene_bc_matrices_h5.h5 1M_neurons_filtered_gene_bc_matrices_h5.h5
