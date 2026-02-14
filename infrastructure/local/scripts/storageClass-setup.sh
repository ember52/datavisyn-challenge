#!/bin/bash
# NFS Subdir External Provisioner — creates a default StorageClass backed by NFS

helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install nfs-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --namespace kube-system \
  --set nfs.server=<NFS_SERVER_IP> \
  --set nfs.path=<NFS_EXPORT_PATH> \
  --set storageClass.name=nfs-storage \
  --set storageClass.defaultClass=true
