# Ceph

## Prepare hosts

```bash
ansible-playbook play-ceph.yaml -i hosts.ceph --limit ceph_cluster_01 -b
cephadm --image ceph/ceph:v18.2.0-20231129 bootstrap --mon-ip 10.10.10.101 --skip-monitoring-stack
ssh-copy-id -f -i /etc/ceph/ceph.pub root@10.10.10.102
ssh-copy-id -f -i /etc/ceph/ceph.pub root@10.10.10.103
cephadm shell

ceph orch host add ceph02 10.10.10.102
ceph orch host add ceph03 10.10.10.103 --labels _admin
ceph orch host ls --detail

ceph config set mgr mgr/cephadm/container_image_node_exporter prometheus/node-exporter:v1.7.0
ceph config set mgr mgr/cephadm/container_image_alertmanager prometheus/alertmanager:v0.25.0
ceph config set mgr mgr/cephadm/container_image_prometheus prometheus/prometheus:v2.43.0
ceph config set mgr mgr/cephadm/container_image_grafana ceph/ceph-grafana:9.4.7

ceph orch ls
ceph orch ps
ceph orch apply node-exporter --placement='*'
ceph orch apply prometheus --placement=1
ceph orch apply alertmanager
ceph orch apply grafana --placement='ceph01'

ceph orch device ls
ceph orch apply osd --all-available-devices

## pool
ceph osd pool create {pool-name} [{pg-num} [{pgp-num}]] [replicated] [crush-rule-name] [expected-num-objects]
ceph osd pool create {pool-name} [{pg-num} [{pgp-num}]] erasure [erasure-code-profile] [crush-rule-name] [expected_num_objects] [--autoscale-mode=<on,off,warn>]

ceph osd pool create pool1
ceph osd pool application enable pool1 {cephfs|rgw|rbd}
ceph osd pool set-quota pool1 max_objects 1000
ceph osd pool set-quota pool1 max_bytes 30G
ceph osd pool delete pool1 

# cephfs
ceph fs volume create cephfs
or
ceph osd pool create cephfs_data
ceph osd pool create cephfs_metadata
ceph fs new cephfs cephfs_metadata cephfs_data
# ceph fs add_data_pool cephfs cephfs_data_ssd
ceph mds stat
ceph config generate-minimal-conf
ceph fs authorize cephfs client.user1 / rw > client.user1.keyring
ceph fs authorize cephfs_a client.user3 / r /bar rw /dir rw
ceph fs ls

# mount cephfs
on the node you want to mount cephfs:
mkdir -p -m 755 /etc/ceph
sudo ls
cat generate-minimal-conf | sudo tee /etc/ceph/ceph.conf
chmod 644 /etc/ceph/ceph.conf
cat client.user1.keyring | sudo tee /etc/ceph/ceph.client.user1.keyring
chmod 600 /etc/ceph/ceph.client.user1.keyring
apt install ceph-common
mkdir /mnt/mycephfs
mount -t ceph user1@.cephfs=/ /mnt/mycephfs
mount -t ceph admin@.cephfs=/ /mnt/mycephfs
umount /mnt/mycephfs
apt install ceph-fuse
ceph-fuse --id admin /mnt/share-dir1
ceph-fuse --id admin -r /sub-dir1 /mnt/share-dir1

cat /etc/fstab
admin@.cephfs=/         /mnt/mycephfs   ceph    mon_addr=10.10.10.101:6789,defaults     0       0
cephuser@.cephfs=/     /mnt/ceph    ceph    mon_addr=192.168.0.1:6789,noatime,_netdev    0       0
none    /mnt/share-dir1     fuse.ceph ceph.id=user1,ceph.client_mountpoint=/sub-dir1,_netdev,defaults  0 0

# nfs
ceph nfs cluster create mynfs
# ceph orch apply nfs mynfs --placement="ceph01"
ceph nfs export create cephfs --cluster-id mynfs --pseudo-path /nfs1 --fsname app1-cephfs
apt install nfs-common
mount -t nfs 10.10.10.101:/nfs1 /mnt/mycephfs

#rgw - RADOS gateway
ceph mgr module enable rgw
ceph orch apply rgw rgw1

# rdb
ceph osd pool create pool-rbd-01
rbd pool init pool-rbd-01
rdb create --size 20G pool-rdb-01/vm109-image1
rbd ls pool-rbd-01
rbd info pool-rbd-01/vm109-image1
rbd device map pool-rbd-01/vm01-image --id rbd-user1

# change dashboard pass
ceph dashboard ac-user-set-password --force-password admin -i /tmp/plaintext-pass
```

## benchmarking
https://tracker.ceph.com/projects/ceph/wiki/Benchmark_Ceph_Cluster_Performance

```bash
# benchmark disk
dd if=/dev/zero of=./here bs=1G count=1 oflag=direct

# benchmark network
apt install iperf -y
iperf -s
iperf -c 10.10.10.101

# rados baseline benchmark
echo 3 | sudo tee /proc/sys/vm/drop_caches && sudo sync
ceph osd pool create benchmark
rados bench -p benchmark 10 write --no-cleanup
rados bench -p benchmark 10 seq
rados bench -p benchmark 10 rand
rados -p benchmark cleanup
# write: 60MB/s
# read: seq/rand 300MB/450MB per sec

# rbd benchmark
ceph osd pool create rbdbench
rbd create image01 --size 1024 --pool rbdbench
rbd map image01 --pool rbdbench --name client.admin
mkfs.ext4 -m0 /dev/rbd0
mount /dev/rbd/rbdbench/image01 /mnt
dd if=/dev/zero of=/mnt/here bs=100K count=1000 oflag=direct
rbd bench-write image01 --pool=rbdbench
rbd bench --io-type read --io-pattern=rand --io-size=100K rbdbench/image01
rbd bench --io-type read --io-pattern=rand --io-size=1M rbdbench/image01

# cephfs benchmark
mount -t ceph admin@.cephfs=/ /mnt
dd if=/dev/zero of=/mnt/here bs=100K count=1000 oflag=direct

# rgw benchmark
radosgw-admin user create --uid="benchmark" --display-name="benchmark"
radosgw-admin subuser create --uid=benchmark --subuser=benchmark:swift --access=full
radosgw-admin key create --subuser=benchmark:swift --key-type=swift --secret=Secret_key124
radosgw-admin user modify --uid=benchmark --max-buckets=0
apt install swift-bench
# swift-bench -c 64 -s 4096 -n 1000 -g 100 ./swift.conf
warp mixed --host=10.10.10.103:80 --access-key=FCVF68SEDT1NK9LJIE6H --secret-key=HMI5iXCmxBCrYDc7KAYdqmA1Ey3m0iOYhIofPsxT --autoterm --duration=5m --analyze.v --objects 500
```

## Upgrade cluster
# mgr -> mon -> crash -> osd -> mds -> rgw -> rbd-mirror -> cephfs-mirror -> iscsi -> nfs
ceph orch upgrade start --image ceph/ceph:v18.2.1-20240118
ceph -s
ceph orch upgrade status
ceph -W cephadm


## Ceph cluster bootstrap

```bash
cephadm --image ceph/ceph:v18.2.0-20231129 bootstrap --mon-ip 10.10.10.101 --skip-monitoring-stack
cephadm --image ceph/ceph:v18.2.0-20231129 bootstrap --mon-ip 10.10.10.101 --cluster-network 20.20.20.0/24
```

## Add new host to the cluster

```bash
ssh-copy-id -f -i /etc/ceph/ceph.pub root@10.10.10.102
cephadm shell
ceph orch host add ceph02 10.10.10.102
# ceph orch host add ceph03 10.10.10.103 --labels _admin
ceph orch host ls --detail
```

## change monitoring container image registry

ceph config set mgr mgr/cephadm/container_image_node_exporter prometheus/node-exporter:v1.7.0
ceph config set mgr mgr/cephadm/container_image_alertmanager prometheus/alertmanager:v0.25.0
ceph config set mgr mgr/cephadm/container_image_prometheus prometheus/prometheus:v2.43.0
ceph config set mgr mgr/cephadm/container_image_grafana ceph/ceph-grafana:9.4.7

## Add new disk to cluster

ceph orch device ls
sgdisk --zap-all /dev/sdd
ceph orch device zap ceph02 /dev/sdb --force
ceph orch host rescan ceph01 --with-summary
ceph orch apply osd --all-available-devices --dry-run

ceph orch apply osd --all-available-devices

## Add or remove node label 

ceph orch host label add ceph02 _admin
ceph orch host label rm ceph02 _admin

## Remove host from cluster

ceph orch host drain ceph03
ceph orch osd rm status
ceph orch ps ceph03
ceph orch host rm ceph03
ceph orch host rm <host> --offline --force

## Enter and exit node to Maintenance mode
ceph orch host maintenance enter ceph02
ceph orch host maintenance exit ceph02

## Create new pool

## Cluster Ops

## monitoring
https://docs.ceph.com/en/latest/monitoring/