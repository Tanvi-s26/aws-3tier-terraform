\# AWS Highly Available 3-Tier Architecture with Terraform



!\[Terraform](https://img.shields.io/badge/IaC-Terraform-7B42BC)

!\[AWS](https://img.shields.io/badge/Cloud-AWS-FF9900)

!\[Region](https://img.shields.io/badge/Region-ap--south--1-blue)

!\[Status](https://img.shields.io/badge/Status-In%20Progress-yellow)



A highly available 3-tier architecture on AWS, defined entirely as code with reusable Terraform modules. It is designed to run within the AWS free tier and to be destroyed and recreated safely.



\## Why this project



I built this to practise designing infrastructure the way production teams do: isolated network tiers, redundancy across Availability Zones, least-privilege access, and everything reproducible from code instead of console clicks.



\## Target architecture



```mermaid

flowchart TB

&#x20;   Internet(("Internet")) --> IGW\["Internet Gateway"]

&#x20;   IGW --> ALB\["Application Load Balancer"]

&#x20;   subgraph VPC\["VPC 10.0.0.0/16"]

&#x20;       subgraph AZ1\["Availability Zone 1"]

&#x20;           P1\["Public subnet 10.0.1.0/24"]

&#x20;           A1\["App subnet 10.0.11.0/24"]

&#x20;           D1\["Database subnet 10.0.21.0/24"]

&#x20;       end

&#x20;       subgraph AZ2\["Availability Zone 2"]

&#x20;           P2\["Public subnet 10.0.2.0/24"]

&#x20;           A2\["App subnet 10.0.12.0/24"]

&#x20;           D2\["Database subnet 10.0.22.0/24"]

&#x20;       end

&#x20;   end

&#x20;   ALB --> P1

&#x20;   ALB --> P2

&#x20;   P1 --> A1

&#x20;   P2 --> A2

&#x20;   A1 --> D1

&#x20;   A2 --> D2

```



| Tier | Subnets | Purpose | Internet access |

|---|---|---|---|

| Web | Public, 2 AZs | Load balancer | Direct, via internet gateway |

| App | Private, 2 AZs | Application servers | Only through the load balancer |

| Data | Private database, 2 AZs | Database | None |



\## Design decisions



\- \*\*Two Availability Zones per tier\*\*, so the loss of one data centre does not take the application down.

\- \*\*Database subnets have no route to the internet\*\*, keeping the data tier isolated from the web tier.

\- \*\*Reusable modules\*\*, so the same VPC code can serve a `prod` environment later.

\- \*\*Free-tier first:\*\* no NAT gateway is created yet because it bills by the hour. Cost-sensitive resources are added deliberately.

\- \*\*Least privilege:\*\* Terraform runs as a dedicated IAM user, not the root account, and a monthly AWS budget alarm guards against surprise bills.



\## Roadmap



\- \[x] VPC with DNS support

\- \[x] Six subnets across two Availability Zones (web, app, database)

\- \[x] Internet gateway and public route table

\- \[ ] Security groups per tier

\- \[ ] Application Load Balancer and Auto Scaling Group

\- \[ ] Multi-AZ RDS in the database subnets, with failover test

\- \[ ] GitHub Actions pipeline (fmt, validate, plan, apply)

\- \[ ] CloudWatch dashboards and alarms



\## Progress



\### VPC creation

!\[VPC creation, step 1](docs/screenshots/1\_VPC\_Creation.png)



!\[VPC creation, step 2](docs/screenshots/2\_VPC\_Creation.png)



\### VPC created in AWS

!\[VPC created](docs/screenshots/AWS\_VPC\_Created.png)



\### Six subnets across two Availability Zones

!\[Subnets added](docs/screenshots/Subnets\_Added.png)



\### Resource map: VPC, subnets, route table and internet gateway

!\[VPC resource map](docs/screenshots/VPC-Resource-Map.png)



\## Project structure



```

.

├── environments/

│   └── dev/          # Environment entry point: provider and module calls

├── modules/

│   └── vpc/          # Reusable VPC module (VPC, subnets, IGW, routing)

└── docs/

&#x20;   └── screenshots/  # Proof of deployed resources

```



\## How to deploy



\*\*Prerequisites:\*\* Terraform 1.5 or later, AWS CLI configured with an IAM user that can manage VPC and EC2 resources.



```bash

cd environments/dev

terraform init

terraform plan

terraform apply

```



\*\*Tear down everything to avoid charges:\*\*



```bash

terraform destroy

```



\## Tech



Terraform, AWS (VPC, Subnets, Internet Gateway, Route Tables), with ALB, Auto Scaling, RDS, GitHub Actions and CloudWatch in progress.



\## Author



\*\*Tanvi\*\* | DevOps and Cloud Engineer | \[GitHub](https://github.com/Tanvi-s26)

