# Building a Windows Server 2019 Lab on Microsoft Hyper-V

> **Part 1:** Preparing the Environment and Creating a Virtual Machine


## Overview

With Hyper-V enabled on the host computer in Lab 01, the next stage of the Windows Server Infrastructure Project is to prepare the virtual machine environment that will host the server systems.

This lab focuses on creating the first Windows Server 2019 virtual machine. It covers organizing VM storage, obtaining the Windows Server installation media, creating an isolated private virtual switch, configuring a Generation 2 virtual machine, and verifying its hardware, firmware, security, memory, and network settings before installation.

Completing these preparation and verification steps establishes a consistent virtual machine foundation for installing Windows Server and building the infrastructure in the subsequent labs.


## Learning Objectives

After completing this lab, you will be able to:

- Prepare an organized Hyper-V storage location for the project virtual machines.
- Obtain the Windows Server 2019 Evaluation ISO.
- Create an isolated virtual network using a Private Virtual Switch.
- Create a Generation 2 Windows Server 2019 virtual machine.
- Configure the virtual machine's memory, networking, and virtual storage.
- Attach the Windows Server installation media.
- Verify the virtual machine's firmware, Secure Boot, memory, and network adapter settings before installation.

---

## Lab Environment

| Component | Configuration |
|-----------|---------------|
| Hypervisor | Microsoft Hyper-V |
| Guest Operating System | Windows Server 2019 Evaluation |
| VM Generation | Generation 2 |
| Startup Memory | 4096 MB |
| Virtual Hard Disk | 50 GB VHDX |
| Network Type | Private Virtual Switch |



# Step 1: Create a Storage Folder for the Virtual Machine

A dedicated storage folder keeps virtual machine configuration files, virtual hard disks and checkpoints organized in one location.

This makes future maintenance, backups and troubleshooting much easier.

### Screenshot

![Create VM Storage Folder](images/01-create-vm1-storage-folder.png)

### Screenshot

![VM Storage Folder Created](images/01-vm-storage-folder-created.png)


# Step 2: Download Windows Server 2019

Windows Server is installed from an ISO image.

Always download installation media directly from Microsoft's Evaluation Center to ensure authenticity and integrity.

### Screenshot

![Download Windows Server ISO](images/02-download-windows-server-iso.png)


# Step 3: Open Hyper-V Manager

Hyper-V Manager provides the interface used to create, configure and manage virtual machines.

This is where the entire virtualization environment is administered.

### Screenshot

![Open Hyper-V Manager](images/03-open-hyper-v-manager.png)


# Step 4: Create a Private Virtual Switch

Virtual machines require a virtual switch before they can communicate across a network.

For this lab, a **Private Virtual Switch** creates an isolated environment where virtual machines can communicate without accessing the host network or the Internet.

### Open Virtual Switch Manager

![Open Virtual Switch Manager](images/04-create-virtual-switch.png)

### Create the Private Virtual Switch

![Create Private Virtual Switch](images/04-create-virtual-switch2.png)


# Step 5: Launch the New Virtual Machine Wizard

With the environment prepared, the next step is to create the virtual machine.

### Open the Wizard

![Launch New Virtual Machine Wizard](images/05-new-virtual-machine.png)

### Before You Begin

The wizard displays an introductory page explaining the creation process.

Click **Next** to continue.

![Before You Begin](images/05-new-virtual-machine2.png)


# Step 6: Configure the Virtual Machine Name and Storage Location

Provide a meaningful name for the virtual machine and store it inside the dedicated lab folder created earlier.

Keeping the VM in its own location simplifies management and keeps related files together.

### Screenshot

![Configure VM Name and Location](images/06-configure-vm-name-and-location.png)


# Step 7: Select Generation 2

Generation 2 virtual machines support modern features including:

- UEFI firmware
- Secure Boot
- Faster boot process
- Improved compatibility with modern operating systems

Windows Server 2019 is fully supported on Generation 2 virtual machines.

### Screenshot

![Select Generation 2](images/07-select-generation-2.png)


# Step 8: Assign Startup Memory

Memory determines the resources available when the virtual machine starts.

For this lab:

- Startup Memory: **4096 MB**
- Dynamic Memory: **Enabled**

Dynamic Memory allows Hyper-V to optimize RAM usage while the virtual machine is running.

### Screenshot

![Assign Memory](images/08-assign-memory.png)


# Step 9: Configure Networking

Connect the virtual machine to the **Private Virtual Switch** created earlier.

This ensures the VM communicates only within the isolated lab environment.

### Screenshot

![Configure Networking](images/09-configure-networking.png)


# Step 10: Create the Virtual Hard Disk

The virtual hard disk stores:

- Windows Server
- Installed applications
- User data
- System configuration

For this lab, create a **50 GB dynamically expanding VHDX**.

### Screenshot

![Create Virtual Hard Disk](images/10-create-virtual-hard-disk.png)


# Step 11: Choose the Installation Media

Attach the Windows Server 2019 Evaluation ISO.

Hyper-V mounts this ISO as a virtual DVD drive during installation.

### Screenshot

![Installation Options](images/11-installation-options.png)


# Step 12: Review the Configuration Summary

Before creating the virtual machine, carefully review every configuration.

Confirm:

- VM name
- Storage location
- Memory
- Network
- Virtual hard disk
- Installation media

If any setting is incorrect, return to the previous page and update it before continuing.

### Screenshot

![Review Summary](images/12-review-summary.png)


# Step 13: Confirm the Virtual Machine Has Been Created

After clicking **Finish**, Hyper-V creates the virtual machine.

At this stage, the VM should appear in **Hyper-V Manager** with a status of **Off**.

This indicates that the virtual machine has been created successfully and is ready for configuration verification.

### Screenshot

![Virtual Machine Created](images/13-virtual-machine-created.png)


# Verify the Virtual Machine Configuration

Before powering on the virtual machine, verify its configuration.

Checking these settings now helps prevent installation issues later.


## Step 14: Open Virtual Machine Settings

Open the virtual machine's **Settings** window.

This provides access to all hardware and firmware configuration options.

### Screenshot

![Open VM Settings](images/14-open-vm-settings.png)


## Step 15: Verify Firmware Settings

Generation 2 virtual machines use **UEFI firmware**.

Verify that the **DVD Drive** appears before the hard drive in the boot order so the virtual machine starts from the Windows Server installation media.

### Screenshot

![Verify Firmware Settings](images/15-verify-firmware-settings.png)


## Step 16: Verify Security Settings

Generation 2 virtual machines support **Secure Boot**.

For Windows Server 2019:

- Secure Boot should be enabled.
- The Secure Boot template should be set to **Microsoft Windows**.

These settings help ensure a secure boot process.

### Screenshot

![Verify Security Settings](images/16-verify-security-settings.png)


## Step 17: Verify Memory Configuration

Confirm that the startup memory matches the value configured during the virtual machine creation process.

Also verify that **Dynamic Memory** is enabled if required.

### Screenshot

![Verify Memory Configuration](images/17-verify-memory-configuration.png)


## Step 18: Verify Network Adapter Configuration

Finally, verify that the virtual machine is connected to the correct **Private Virtual Switch**.

Without the correct virtual switch, the virtual machine will not communicate with other systems in the lab.

### Screenshot

![Verify Network Adapter](images/18-verify-network-adapter.png)


# Verification Checklist

Before proceeding to the Windows Server installation, confirm the following:

- Hyper-V environment prepared
- VM storage location created
- Windows Server ISO downloaded
- Private Virtual Switch configured
- Generation 2 virtual machine created
- Startup memory configured
- Virtual hard disk created
- Installation media attached
- Firmware verified
- Secure Boot verified
- Memory configuration verified
- Network adapter verified

If all items above are complete, the virtual machine is ready for operating system installation.


# Key Takeaways

You have prepared the virtual machine that will host the first Windows Server system in the Windows Server Infrastructure Project. The VM storage location, isolated private network, installation media, and Generation 2 hardware configuration are in place and verified before operating system installation.

Verifying these settings at this stage provides a controlled starting point for the Windows Server installation and configuration work that follows.


# Next Steps

The virtual machine is now created and its configuration has been verified. Continue to **Lab 03: Installing and Configuring Windows Server 2019** to install the operating system, configure the built-in Administrator account, assign the initial static IPv4 address, and verify the server's initial configuration.


⭐ If you found this guide helpful, consider starring this repository.
