# Visualizing and Clustering 1.3M neurons, with optimizations

## Speeding up Louvain with GPUs

We will use a machine on Google Cloud Platform, since it makes it easy
to get a GPU-enabled machine with all the software pre-configured.
(See https://cloud.google.com/deep-learning-vm/docs/images.)

You may wish to change the zone specified here:

```bash
export IMAGE_FAMILY="rapids-latest-gpu-experimental"
export ZONE="us-central1-a"
export INSTANCE_NAME="$USER-scanpy"

gcloud compute instances create $INSTANCE_NAME \
  --zone=$ZONE \
  --image-family=$IMAGE_FAMILY \
  --image-project=deeplearning-platform-release \
  --machine-type=n1-standard-16 \
  --maintenance-policy=TERMINATE \
  --accelerator="type=nvidia-tesla-t4,count=1" \
  --metadata="install-nvidia-driver=True"
```

Connect to the instance with the following command. Note that it may
take a few minutes before it is ready to accept connections.

```bash
gcloud compute ssh --zone $ZONE $INSTANCE_NAME
```

Once connected, type `nvidia-smi` to check that there is indeed a GPU.

```
$ nvidia-smi
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 410.104      Driver Version: 410.104      CUDA Version: 10.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  Tesla T4            Off  | 00000000:00:04.0 Off |                    0 |
| N/A   65C    P0    29W /  70W |      0MiB / 15079MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```

Install scanpy (with Louvain GPU support):

```bash
pip install --user git+https://github.com/tomwhite/scanpy@louvain-cugraph
```

Install louvain (to run on a CPU):

```bash
sudo apt-get install -y libz-dev libxml2-dev
pip install --user louvain # takes a while to install from source
```

Checkout this repo in the instance to give access to the scripts.

```bash
git clone https://github.com/tomwhite/scanpy_usage
(cd scanpy_usage; git checkout -b gpu-optimization origin/gpu-optimization)
cd scanpy_usage/1908_louvain_gpu
```

Copy test data to the instance. Note that you will have to change the user
(`-u`) to be your GCP project since the data is in a requester pays bucket.

```bash
gsutil -u hca-scale cp gs://ll-sc-data/10x/1M_neurons_filtered_gene_bc_matrices_h5.h5 1M_neurons_filtered_gene_bc_matrices_h5.h5
```

Run the analysis (optimized):

```bash
python cluster_130K_opt.py 1M_neurons_filtered_gene_bc_matrices_h5.h5
```

Run the analysis (regular):

```bash
python cluster_130K.py 1M_neurons_filtered_gene_bc_matrices_h5.h5
```

_Summary: unoptimized Louvain takes 1:20 minutes, optimized (GPU) takes
0:03 minutes (3 seconds)._

To view the figures, run the following from your local machine to copy
them locally:

```bash
gcloud compute scp --zone $ZONE --recurse $INSTANCE_NAME:scanpy_usage/1908_louvain_gpu/figures figures
```

## 1M cells

_Note_: this currently fails due to out of memory errors (even with `n1-highmem-16`).

Run the analysis (optimized):

```bash
python cluster_opt.py 1M_neurons_filtered_gene_bc_matrices_h5.h5
```

Run the analysis (regular):

```bash
python cluster.py 1M_neurons_filtered_gene_bc_matrices_h5.h5
```

## Finishing up

```bash
gcloud compute instances delete --zone $ZONE --quiet $INSTANCE_NAME
```
