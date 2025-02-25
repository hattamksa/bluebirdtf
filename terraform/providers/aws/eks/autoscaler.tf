# resource "kubernetes_deployment_v1" "autoscaler" {
#   count           = local.env == "stg" ? 1 : 0
#   wait_for_rollout = true
#   metadata {
#       annotations      = {}
#       labels           = {
#           "app" = "cluster-autoscaler"
#       }
#       name             = "cluster-autoscaler"
#       namespace        = "kube-system"
#   }

#   spec {
#       min_ready_seconds         = 0
#       paused                    = false
#       progress_deadline_seconds = 600
#       replicas                  = "1"
#       revision_history_limit    = 10

#       selector {
#           match_labels = {
#               "app" = "cluster-autoscaler"
#           }
#       }

#       strategy {
#           type = "RollingUpdate"

#           rolling_update {
#               max_surge       = "25%"
#               max_unavailable = "25%"
#           }
#       }

#       template {
#           metadata {
#               annotations = {}
#               labels      = {
#                   "app" = "cluster-autoscaler"
#               }
#           }

#           spec {
#               automount_service_account_token  = false
#               dns_policy                       = "ClusterFirst"
#               enable_service_links             = false
#               host_ipc                         = false
#               host_network                     = false
#               host_pid                         = false
#               node_selector                    = {}
#               priority_class_name              = "system-cluster-critical"
#               restart_policy                   = "Always"
#               scheduler_name                   = "default-scheduler"
#               service_account_name             = "cluster-autoscaler"
#               share_process_namespace          = false
#               termination_grace_period_seconds = 30

#               container {
#                   args                       = []
#                   command                    = [
#                       "./cluster-autoscaler",
#                       "--v=4",
#                       "--stderrthreshold=info",
#                       "--cloud-provider=aws",
#                       "--skip-nodes-with-local-storage=false",
#                       "--expander=least-waste",
#                       "--node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/eccomerce-kube-${local.env}",
#                   ]
#                   image                      = "registry.k8s.io/autoscaling/cluster-autoscaler:v1.28.0"
#                   image_pull_policy          = "Always"
#                   name                       = "cluster-autoscaler"
#                   stdin                      = false
#                   stdin_once                 = false
#                   termination_message_path   = "/dev/termination-log"
#                   termination_message_policy = "File"
#                   tty                        = false

#                   env {
#                       name  = "AWS_REGION"
#                       value = "ap-southeast-1"
#                   }

#                   resources {
#                       limits   = {
#                           "cpu"    = "100m"
#                           "memory" = "600Mi"
#                       }
#                       requests = {
#                           "cpu"    = "100m"
#                           "memory" = "512Mi"
#                       }
#                   }

#                   volume_mount {
#                       mount_path        = "/etc/ssl/certs/ca-certificates.crt"
#                       mount_propagation = "None"
#                       name              = "ssl-certs"
#                       read_only         = true
#                   }
#               }

#               security_context {
#                   fs_group            = "65534"
#                   run_as_non_root     = true
#                   run_as_user         = "65534"
#                   supplemental_groups = []
#               }

#               volume {
#                   name = "ssl-certs"

#                   host_path {
#                       path = "/etc/ssl/certs/ca-bundle.crt"
#                   }
#               }
#           }
#       }
#   }

#   timeouts {}
# }
