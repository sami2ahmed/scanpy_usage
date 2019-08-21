An updated version of the one million cells code, with optimizations.

Start a machine running on Google Cloud:

```bash
./create-machine.sh
```

Log in:

```bash
gcloud compute --project "hca-scale" ssh --zone "us-east1-b" "tw1"
```

Install this repo and data

```bash
git clone https://github.com/tomwhite/scanpy_usage
(cd scanpy_usage; git checkout -b pipeline-optimization origin/pipeline-optimization)
cd scanpy_usage/190426_visualizing_one_million_cells

# Copy 10x data locally
gsutil -u hca-scale cp gs://ll-sc-data/10x/1M_neurons_filtered_gene_bc_matrices_h5.h5 1M_neurons_filtered_gene_bc_matrices_h5.h5
```

Install official scanpy release (1.4.3)

```bash
pip3 install scanpy==1.4.3
```

Run 130K benchmark:

```bash
cd ~/scanpy_usage/190426_visualizing_one_million_cells
python3 cluster_130K.py 1M_neurons_filtered_gene_bc_matrices_h5.h5 | tee logfile_130K_scanpy144.txt
```

Install official scanpy release (1.4.4.post1)

```bash
cd
pip3 uninstall -y scanpy
pip3 install scanpy==1.4.4.post1
cd ~/scanpy_usage/190426_visualizing_one_million_cells
python3 cluster_130K.py 1M_neurons_filtered_gene_bc_matrices_h5.h5 | tee logfile_130K_scanpy144.txt
```

Install scanpy that uses pynndescent as a dependency (not released). Also use a umap optimization.

```bash
cd
pip3 uninstall -y scanpy
rm -rf scanpy
git clone https://github.com/tomwhite/scanpy
(cd scanpy; mkdir data; git checkout -b pynndescent-dependency-threaded origin/pynndescent-dependency-threaded; pip3 install -e .)

cd
pip3 uninstall -y umap-learn
rm -rf umap
git clone https://github.com/tomwhite/umap
(cd umap; git checkout -b embedding_optimization origin/embedding_optimization; pip3 install -e .)

cd ~/scanpy_usage/190426_visualizing_one_million_cells
python3 cluster_130K.py 1M_neurons_filtered_gene_bc_matrices_h5.h5 | tee logfile_130K_scanpy_optimized.txt
```

TODO: rest of pipeline

```bash
sudo apt-get install -y libz-dev libxml2-dev
pip3 install louvain # takes a while to install from source
```
