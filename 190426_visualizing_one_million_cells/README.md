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

Install official scanpy release

```bash
pip3 install scanpy==1.4
```

Run 130K benchmark:

```bash
cd ~/scanpy_usage/190426_visualizing_one_million_cells
python3 cluster_130K.py 1M_neurons_filtered_gene_bc_matrices_h5.h5 | tee logfile_130K_scanpy14.txt
```

Install scanpy that uses umap as a dependency (not yet released):

```bash
pip3 uninstall -y scanpy
pip3 install git+https://github.com/theislab/scanpy

cd ~/scanpy_usage/190426_visualizing_one_million_cells
python3 cluster_130K.py 1M_neurons_filtered_gene_bc_matrices_h5.h5 | tee logfile_130K_scanpy_umap.txt
```

Install scanpy that uses umap and pynndescent as dependencies:

```bash
cd
pip3 uninstall -y scanpy
rm -rf scanpy
git clone https://github.com/tomwhite/scanpy
(cd scanpy; mkdir data; git checkout -b pynndescent-dependency-threaded origin/pynndescent-dependency-threaded; pip3 install -e .)

pip3 uninstall -y pynndescent
pip3 install git+https://github.com/lmcinnes/pynndescent

#pip3 uninstall -y umap-learn
#pip3 install git+https://github.com/tomwhite/umap@embedding_optimization

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
pip3 install louvain # takes a while to install from source
```