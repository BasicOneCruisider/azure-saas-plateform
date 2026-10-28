#  Multi-Region SaaS Platform (Deployment Stamps)

![Terraform](https://img.shields.io/badge/Terraform-1.9+-623CE4?style=for-the-badge&logo=terraform&logoColor=white)
![Azure](https://img.shields.io/badge/Azure-Cloud-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Azure DevOps](https://img.shields.io/badge/Azure_DevOps-Pipeline-0078D7?style=for-the-badge&logo=azure-devops&logoColor=white)

##  Overview

This repository contains the Infrastructure as Code (IaC) for a highly available, multi-region SaaS platform deployed on Microsoft Azure. It implements the **Deployment Stamps** architectural pattern, ensuring complete network isolation, automated CI/CD, and robust Disaster Recovery capabilities.

##  Architecture

The architecture is based on two independent, identical regional stamps:
*   **Primary Stamp:** Hosted in `Sweden Central`.
*   **Disaster Recovery (DR) Stamp:** Hosted in `West US 2`.

### Key Design Principles:
*   **Zero Trust Network:** All PaaS services (SQL, Key Vault) are completely isolated from the internet using **Azure Private Endpoints**.
*   **Shared Private DNS:** Private DNS zones are created once at the root level and shared across both VNets via VNet Links, avoiding naming conflicts.
*   **Managed Identities:** The App Services use System-Assigned Managed Identities to securely retrieve secrets from Azure Key Vault without hardcoded credentials.
*   **Remote State Management:** Terraform state is securely stored in an Azure Storage Account with state locking enabled.

### Architecture Diagram

```mermaid
flowchart TD
    subgraph Global [ Shared Resources]
        DNS_SQL[DNS Zone: privatelink.database.windows.net]
        DNS_KV[DNS Zone: privatelink.vaultcore.azure.net]
    end

    subgraph Primary [ Primary Stamp - Sweden Central]
        VNet1[Primary VNet]
        App1[App Service]
        SQL1[(Azure SQL)]
        KV1[Key Vault]
        PE1[Private Endpoint SQL]
        PE2[Private Endpoint KV]
        
        App1 -->|VNet Integration| VNet1
        VNet1 --> PE1 --> SQL1
        VNet1 --> PE2 --> KV1
        App1 -.->|DNS Resolution| DNS_SQL
        App1 -.->|DNS Resolution| DNS_KV
    end

    subgraph DR [ DR Stamp - West US 2]
        VNet2[DR VNet]
        App2[App Service]
        SQL2[(Azure SQL)]
        KV2[Key Vault]
        PE3[Private Endpoint SQL]
        PE4[Private Endpoint KV]
        
        App2 -->|VNet Integration| VNet2
        VNet2 --> PE3 --> SQL2
        VNet2 --> PE4 --> KV2
        App2 -.->|DNS Resolution| DNS_SQL
        App2 -.->|DNS Resolution| DNS_KV
    end

    DNS_SQL -.->|VNet Link| VNet1
    DNS_SQL -.->|VNet Link| VNet2
    DNS_KV -.->|VNet Link| VNet1
    DNS_KV -.->|VNet Link| VNet2