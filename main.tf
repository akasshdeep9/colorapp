#__________________________________________________________
#
# Get Outputs from the kubeconfig Workspace
#__________________________________________________________

data "terraform_remote_state" "kubeconfig" {
  backend = "remote"
  config = {
    organization = var.tfc_organization
    workspaces = {
      name = var.tfc_workspace
    }
  }
}

locals {
  # IKS Cluster Name
  cluster_name = data.terraform_remote_state.kubeconfig.outputs.cluster_name
  # Kubernetes Configuration File
  kubeconfig = yamldecode(data.terraform_remote_state.kubeconfig.outputs.kubeconfig)
}

#_____________________________________________________________________
#
# Deploy the Hello-Kubernetes Application Pod using the Helm Provider
#_____________________________________________________________________

resource "kubernetes_deployment" "color" {
    metadata {
        name = "color-blue-dep"
        labels = {
            app   = "color"
            color = "blue"
        } //labels
    } //metadata
    
    spec {
        selector {
            match_labels = {
                app   = "color"
                color = "blue"
            } //match_labels
        } //selector
        #Number of replicas
        replicas = 3
        #Template for the creation of the pod
        template { 
            metadata {
                labels = {
                    app   = "color"
                    color = "blue"
                } //labels
            } //metadata
            spec {
                container {
                    image = "itwonderlab/color"   #Docker image name
                    name  = "color-blue"          #Name of the container specified as a DNS_LABEL. Each container in a pod must have a unique name (DNS_LABEL).
                    
                    #Block of string name and value pairs to set in the container's environment
                    env { 
                        name = "COLOR"
                        value = "blue"
                    } //env
                    
                    #List of ports to expose from the container.
                    port { 
                        container_port = 8080
                    }//port          
                    
                    resources {
                        limits={
                            cpu    = "0.5"
                            memory = "512Mi"
                        } //limits
                        requests={
                            cpu    = "250m"
                            memory = "50Mi"
                        } //requests
                    } //resources
                } //container
            } //spec
        } //template
    } //spec
} //resource
#-------------------------------------------------
# KUBERNETES DEPLOYMENT COLOR SERVICE NODE PORT
#-------------------------------------------------
resource "kubernetes_service" "color-service-np" {
  metadata {
    name = "color-service-np"
  } //metadata
  spec {
    selector = {
      app = "color"
    } //selector
    session_affinity = "ClientIP"
    port {
      port      = 8080 
      node_port = 30085
    } //port
    type = "NodePort"
  } //spec
} //resource
