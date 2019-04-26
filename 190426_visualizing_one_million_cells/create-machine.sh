#!/usr/bin/env bash

set -x

gcloud compute \
  --project=hca-scale \
  instances create tw1 \
  --zone=us-east1-b \
  --machine-type=n1-standard-16 \
  --subnet=default \
  --network-tier=PREMIUM \
  --maintenance-policy=MIGRATE \
  --service-account=218219996328-compute@developer.gserviceaccount.com \
  --scopes=https://www.googleapis.com/auth/cloud-platform \
  --image=ubuntu-1804-bionic-v20190429 \
  --image-project=ubuntu-os-cloud \
  --boot-disk-size=1000GB \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=tw1 \
  --metadata-from-file \
  startup-script=gce-startup.sh
