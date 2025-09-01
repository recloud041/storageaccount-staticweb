
# 🚀 Azure Static Website Deployment with Terraform and Azure DevOps

This project demonstrates how to deploy a **static website** to **Azure Storage Account** using **Terraform** and an automated **Azure DevOps YAML Pipeline**.

It includes:
- Azure infrastructure provisioning using Terraform
- Azure DevOps pipeline to deploy infrastructure
- Uploading static files to the Storage Account’s `$web` container

---

## 🧾 Prerequisites

Ensure the following are in place:

1. **Azure Subscription** with Contributor-level access
2. **Azure DevOps** project
3. A **Service Connection** in Azure DevOps for Azure authentication (e.g., `ado-aks-deployer`)
4. A Linux or GCP DevOps Agent pool (e.g., `gcp-agent-ads`)
5. Terraform installed on the agent (or installed via pipeline task)
6. Static website files in a folder named `website/` at repo root
7. Terraform code in the `terraform/` folder

---

## 🗂 Project Structure

```
.
├── terraform/
│   ├── main.tf                # Terraform config to create RG, Storage Account, Role Assignment
├── website/
│   ├── index.html             # Your static HTML files
│   ├── error.html
├── azure-pipelines.yml        # Azure DevOps pipeline definition
└── README.md
```

---

## 🔧 What the Terraform Code Does

Located in `/terraform/main.tf`, it:
- Creates a **Resource Group**
- Creates a **Storage Account** (name must be globally unique)
- Enables **Static Website Hosting**
- Assigns the **"Storage Blob Data Contributor"** role to the Azure DevOps Service Principal (SPN) so it can upload files



---

## 🔄 Azure DevOps Pipeline Flow

File: `azure-pipelines.yml`

### Stage 1: Terraform
- Checks if RG exists
- If not, runs `terraform init` and `apply`
- If exists, skips creation

### Stage 2: Upload Website
- Uploads `index.html` and `error.html` using `az storage blob upload-batch` with `--overwrite` flag

Azure CLI sample command:

```bash
az storage blob upload-batch   --account-name staticwebsatya01   --auth-mode key   -s "$(System.DefaultWorkingDirectory)/website"   -d '$web'   --overwrite
```

---

## ✅ How to Use This Repository

### 1. Clone the Repo

```bash
git clone https://github.com/<your-username>/static-website-azure-devops.git
cd static-website-azure-devops
```

### 2. Modify Terraform

Update `main.tf` as per your Azure subscription and storage account naming.

### 3. Configure Azure DevOps

Set up pipeline to point to `azure-pipelines.yml`. Ensure the following variables are set:

```yaml
variables:
  azureServiceConnection: 'ado-aks-deployer'
  tfStorageAccount: 'staticwebsatya01'
```

### 4. Run Pipeline

Push changes to trigger pipeline. It will provision resources and upload static content.

---

## 🔎 Access Your Website

After successful deployment:

- Go to your Storage Account > Static Website
- Copy the **Primary endpoint** URL

Your website will be accessible at:

```
https://staticwebsatya01.z13.web.core.windows.net
```

