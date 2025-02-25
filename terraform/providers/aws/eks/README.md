### Setup eks
- terraform init
- terraform workspace new stg
- terraform plan (check resource in terraform)
- comment all in file autoscaler.tf
- terraform apply -target="aws_eks_cluster.eks[0]" untuk buat cluster kubernetesnya
- aws sts get-caller-identity
- aws eks update-kubeconfig --region ap-southeast-1 --name learning-kube-stg
- terraform apply untuk create beberapa resource seperti node worker 
- kubectl edit deploy cluster-autoscaler -n kube-system
  (update inline : automountServiceAccountToken: true)


### Setup ebs gp2 & gp3
full documentation see{https://aws.amazon.com/blogs/containers/migrating-amazon-eks-clusters-from-gp2-to-gp3-ebs-volumes/}

helm upgrade --install aws-ebs-csi-driver \
    --namespace kube-system \
    aws-ebs-csi-driver/aws-ebs-csi-driver
create storage class

### validation connection ebs gp2 & gp3
cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: gp3
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp3
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-pv-claim
  namespace: default
spec:
  storageClassName: gp3
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
EOF

### validation connection s3

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: access-s3
  namespace: default
  EOF

kubectl annotate serviceaccount -n default s3-access-test-pod eks.amazonaws.com/role-arn=arn:aws:iam::{account_id_aws}:role/demo-access


cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: s3-access-test-pod
  namespace: default
spec: 
  serviceAccountName: access-s3
  containers:
  - name: s3-access-test-container
    image: amazon/aws-cli
    command: ['aws', 's3', 'ls', 's3://namabucket']
  EOF

