# Windows Server Infrastructure Project

An end-to-end Windows Server infrastructure build, documented from initial Hyper-V setup through domain services, centralized administration, file services, DHCP high availability, and PowerShell-based administration.

This project brings together 17 connected implementation labs. Each stage builds on the environment and configuration established in earlier stages, resulting in a small, multi-server Windows domain environment that can be used to demonstrate core Windows Server administration tasks.

## Project Overview

The project follows a practical infrastructure scenario: establish a virtualized Windows Server environment, deploy and manage an Active Directory domain, connect a client computer, apply access and configuration controls, provide shared storage and namespace services, improve DHCP service availability, and administer the environment with PowerShell.

Rather than treating the exercises as unrelated tasks, the repository documents the progressive build and administration of the same lab environment.

## Lab Environment

| Component | Role |
|---|---|
| Hyper-V | Hosts the virtual machines used for the infrastructure build |
| DC01 | Primary Windows Server domain controller and infrastructure server |
| DC02 | Additional Windows Server used for secondary domain services, replication, and failover exercises |
| Client PC | Domain-joined Windows client used to test authentication, policy application, access, and network services |

The environment is developed progressively across the labs. Individual lab documentation identifies the server or client involved in each task and records the relevant configuration and verification steps.

## Project Implementation

### Phase 1: Build the Virtualized Server Environment

Establish the Hyper-V environment and prepare the Windows Server machines that will host the domain infrastructure.

| Lab | Implementation |
|---|---|
| [Lab 01 – System Requirements and Enabling Hyper-V](Lab-01-System-Requirements-and-Enabling-Hyper-V/) | Review system requirements and enable the Hyper-V role. |
| [Lab 02 – Building a Windows Server 2019 Lab](Lab-02-Building-a-Windows-Server-2019-Lab/) | Build the virtual lab environment. |
| [Lab 03 – Installing and Configuring Windows Server 2019](Lab-03-Installing-and-Configuring-Windows-Server-2019/) | Install and configure Windows Server. |
| [Lab 04 – Promoting Windows Server to a Domain Controller](Lab-04-Promoting-Windows-Server-to-a-Domain-Controller/) | Configure the first domain controller and establish the domain. |

### Phase 2: Deploy Active Directory and Connect Client Systems

Build the directory environment, organize identities, and connect a Windows client to the domain.

| Lab | Implementation |
|---|---|
| [Lab 05 – Active Directory Domain Services](Lab-05-Active-Directory-Domain-Services/) | Configure and administer Active Directory Domain Services. |
| [Lab 06 – Joining a Client PC to the Domain](Lab-06-Joining-a-Client-PC-to-the-Domain/) | Join a Windows client to the domain and verify domain connectivity. |
| [Lab 07 – Everyday Windows Administration Tasks](Lab-07-Everyday-Windows-Administration-Tasks/) | Perform routine Windows Server administration tasks. |
| [Lab 08 – Deploying a Read-Only Domain Controller](Lab-08-Deploying-a-Read-Only-Domain-Controller/) | Deploy and verify an additional Read-Only Domain Controller. |

### Phase 3: Manage Access, Permissions, and Group Policy

Apply controls that govern how users access shared resources and how domain-joined computers are configured.

| Lab | Implementation |
|---|---|
| [Lab 09 – NTFS and Share Permissions](Lab-09-NTFS-and-Share-Permissions/) | Configure file-system and network share permissions. |
| [Lab 10 – NTFS Permission Management](Lab-10-NTFS-Permission-Management/) | Manage and verify NTFS permissions. |
| [Lab 11 – Group Policy Management and Troubleshooting](Lab-11-Group-Policy-Management-and-Troubleshooting/) | Create, apply, and troubleshoot Group Policy settings. |
| [Lab 12 – Group Policy Wallpaper, Drive Mapping, and Account Security](Lab-12-Group-Policy-Wallpaper-Drive-Mapping-and-Account-Security/) | Use Group Policy to configure user and computer settings, drive mappings, and account-related controls. |

### Phase 4: Configure Storage and Distributed File Services

Provide storage and shared-folder access, then make selected shared data available through a namespace and replication between servers.

| Lab | Implementation |
|---|---|
| [Lab 13 – Disk Management and Storage Pools](Lab-13-Disk-Management-and-Storage-Pools/) | Configure disks, volumes, and Storage Pools. |
| [Lab 14 – iSCSI Target and Initiator Configuration](Lab-14-iSCSI-Target-and-Initiator-Configuration/) | Configure iSCSI storage access between Windows Server systems. |
| [Lab 15 – DFS Namespaces and Replication](Lab-15-DFS-Namespaces-and-Replication/) | Present shared folders through a DFS namespace and configure folder replication between servers. |

### Phase 5: Provide DHCP Availability and PowerShell Administration

Configure resilient address assignment and use PowerShell to inspect, manage, and automate administrative tasks.

| Lab | Implementation |
|---|---|
| [Lab 16 – DHCP High Availability and Failover](Lab-16-DHCP-High-Availability-and-Failover/) | Configure DHCP failover between servers and verify address assignment and failover behaviour. |
| [Lab 17 – Windows Server Administration with PowerShell](Lab-17-Windows-Server-Administration-with-PowerShell/) | Use PowerShell for system diagnostics, Active Directory administration, bulk user creation, service and role inspection, share administration, remote management, reporting, and cleanup. |

## Infrastructure Capabilities Demonstrated

The completed lab sequence documents practical administration across these areas:

- **Virtualization and server deployment:** Hyper-V, virtual machines, and Windows Server installation.
- **Identity and domain services:** Active Directory, domain controllers, user and group administration, domain-joined clients, and an RODC.
- **Access and configuration management:** NTFS permissions, share permissions, Group Policy, and account security.
- **Storage and file services:** Disk Management, Storage Pools, iSCSI, DFS Namespaces, and DFS Replication.
- **Network services:** DHCP configuration, address assignment, and DHCP failover.
- **Automation and remote administration:** PowerShell commands, CSV-based bulk user provisioning, remote server administration, reporting, and administrative cleanup.

## How to Use This Repository

The implementation is documented in sequence. Start with Lab 01 and work through the labs in order to follow how the environment is established and extended.

Each lab folder contains its own `README.md` with the relevant scenario, implementation steps, commands or configuration details, screenshots, and verification where included in that lab.

The `Foundations/` directory contains supporting foundational material.

## Project Scope

This is a hands-on virtual lab project built to demonstrate Windows Server infrastructure deployment and administration. Configurations and results are documented in the individual labs. The environment is a controlled practice environment and should not be interpreted as a production deployment design without further assessment, security hardening, capacity planning, backup strategy, and operational controls.

## Repository Structure

```text
Windows-Server/
├── Foundations/
├── Lab-01-System-Requirements-and-Enabling-Hyper-V/
├── Lab-02-Building-a-Windows-Server-2019-Lab/
├── Lab-03-Installing-and-Configuring-Windows-Server-2019/
├── Lab-04-Promoting-Windows-Server-to-a-Domain-Controller/
├── Lab-05-Active-Directory-Domain-Services/
├── Lab-06-Joining-a-Client-PC-to-the-Domain/
├── Lab-07-Everyday-Windows-Administration-Tasks/
├── Lab-08-Deploying-a-Read-Only-Domain-Controller/
├── Lab-09-NTFS-and-Share-Permissions/
├── Lab-10-NTFS-Permission-Management/
├── Lab-11-Group-Policy-Management-and-Troubleshooting/
├── Lab-12-Group-Policy-Wallpaper-Drive-Mapping-and-Account-Security/
├── Lab-13-Disk-Management-and-Storage-Pools/
├── Lab-14-iSCSI-Target-and-Initiator-Configuration/
├── Lab-15-DFS-Namespaces-and-Replication/
├── Lab-16-DHCP-High-Availability-and-Failover/
├── Lab-17-Windows-Server-Administration-with-PowerShell/
├── LICENSE
└── README.md
```

## Technologies

- Microsoft Hyper-V
- Windows Server 2019 and Windows Server 2022
- Active Directory Domain Services
- DNS
- Group Policy
- NTFS and SMB share permissions
- Storage Pools
- iSCSI
- DFS Namespaces and DFS Replication
- DHCP and DHCP Failover
- Windows PowerShell

---

**Project status:** 17 implementation labs documented and committed.
