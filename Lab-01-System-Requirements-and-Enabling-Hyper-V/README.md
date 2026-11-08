# Lab 01: System Requirements and Enabling Hyper-V

## Overview

Building a Windows Server infrastructure requires a reliable virtualization platform where server systems can be deployed, configured, and managed.

This lab establishes the foundation for the Windows Server Infrastructure Project by assessing the host computer's compatibility with Microsoft Hyper-V and enabling the required virtualization feature.

Hyper-V provides the virtualization platform that will host the Windows Server virtual machines used throughout this project. Preparing the host environment first helps ensure that subsequent deployment and configuration activities can be carried out on a suitable platform.

## Objectives

By the end of this lab, you should be able to:

- Assess a host computer's compatibility with Microsoft Hyper-V.
- Identify the hardware and operating system requirements for virtualization.
- Verify that hardware virtualization is enabled.
- Enable the Hyper-V role through Windows Features.
- Complete the installation and verify Hyper-V Manager availability.
- Prepare the host environment for the deployment of Windows Server virtual machines.

## Prerequisites

- A Windows computer running a supported edition of Windows.
- Access to Windows settings and Windows Features with permission to enable optional Windows features.
- Hardware virtualization support enabled in the computer's BIOS/UEFI.
- Administrator access may be required to enable Hyper-V and restart the computer.

## System requirements

The original lab guide lists the following requirements:

| Requirement | Description |
|---|---|
| Operating system | Windows 10/11 Pro, Enterprise, or Education. Hyper-V is not available on Windows Home by default. |
| Processor | 64-bit CPU with Second Level Address Translation (SLAT). |
| RAM | Minimum 4 GB; 8 GB or more recommended. |
| Hardware virtualization | Intel VT-x or AMD-V enabled in BIOS/UEFI. |
| Data Execution Prevention (DEP) | Hardware-enforced DEP enabled. |

These are the requirements listed in the source lab. Actual performance will depend on the host computer and the virtual machines you plan to run.

## Procedure 1: Check your Windows edition

1. Open **Settings**.
2. Select **System**.
3. Select **About**.

![Open Windows Settings and navigate to System](images/01-open-system-settings.png)

4. Review the Windows specifications to identify your Windows edition.

![Review the Windows edition in About](images/02-check-windows-edition.png)

Confirm that the installed edition supports Hyper-V before continuing.

## Procedure 2: Check whether virtualization is enabled

1. Open **Task Manager**.

![Open Task Manager Performance](images/03-task-manager-performance.png)


2. Select the **Performance** tab.
3. Find the **Virtualization** entry and check that it says **Enabled**.


![Check virtualization status in CPU performance details](images/04-check-virtualization-status.png)

If virtualization is disabled, check your computer manufacturer's instructions for enabling Intel VT-x or AMD-V in BIOS/UEFI. The exact menu and wording depend on the computer.

## Procedure 3: Open Windows Features

1. Select **Start** or press the **Windows** key.
2. Search for `Turn Windows features on or off`.
3. Open the matching result.

![Find Turn Windows features on or off](images/05-open-windows-features.png)

## Procedure 4: Enable Hyper-V

1. In the **Windows Features** window, locate **Hyper-V**.
2. Select the **Hyper-V** checkbox.
3. Allow Windows to select the required Hyper-V components.
4. Select **OK**.

![Select Hyper-V in Windows Features](images/06-select-hyper-v-feature.png)

Windows will begin applying the requested changes.

## Procedure 5: Complete installation and restart

1. Wait while Windows searches for the required files and installs Hyper-V.
2. When prompted, select **Restart now**.
3. Allow the computer to restart before trying to use Hyper-V.

Save any open work before restarting.

## Procedure 6: Verify Hyper-V installation

1. After the computer restarts, open **Start**.
2. Search for **Hyper-V Manager**.
3. Confirm that Hyper-V Manager appears in the search results.
4. Open Hyper-V Manager to check that it launches.

![Verify Hyper-V Manager is available](images/07-verify-hyper-v-manager.png)

If Hyper-V Manager is available, the installation step has completed. Hyper-V is ready for you to begin preparing virtual machines, subject to the host's configuration and available resources.

![Final verification of Hyper-V installation](images/08-final-verification.png)


## Troubleshooting notes

- **Hyper-V is not listed in Windows Features:** Confirm that the Windows edition supports Hyper-V and that the computer meets the virtualization requirements.
- **Virtualization is disabled:** Check BIOS/UEFI settings and your computer manufacturer's documentation.
- **Hyper-V Manager does not appear after restarting:** Recheck the Windows Features selection and whether installation completed successfully.

## Outcome

The host computer has been assessed for Hyper-V compatibility, the virtualization feature has been enabled, and Hyper-V Manager has been verified. This establishes the virtualization foundation required for deploying the Windows Server environment in the next stage of the project.

## Next step

Continue to **Lab 02: Building a Windows Server 2019 Lab on Microsoft Hyper-V**, where the prepared virtualization platform will be used to organize the lab environment and create the first Windows Server virtual machine.
