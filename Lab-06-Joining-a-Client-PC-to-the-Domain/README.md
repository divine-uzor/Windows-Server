# Joining a Client PC to the Domain

This lab demonstrates how to build a Windows 10 client virtual machine in Hyper-V, configure its network settings, and join it to the `divineuzor.com` Active Directory domain. It covers IP addressing, DNS configuration, connectivity testing, domain authentication, and verification of the client computer object in Active Directory.

## Objectives

By the end of this lab, we will:

- Create a Windows 10 client virtual machine in Hyper-V.
- Install Windows 10 Pro and complete the initial setup.
- Understand the IP addressing scheme used in this lab.
- Configure the domain controller and client network settings.
- Test connectivity between the client PC and the domain controller.
- Join the client PC to the `divineuzor.com` domain.
- Sign in with a domain account and verify the computer object in Active Directory.

## Step 1: Download Windows 10

Download a 64-bit Windows 10 ISO from Microsoft's official Software Download or Media Creation Tool page. Once the download finishes, move the file into the Hyper-V Labs folder so everything for this lab lives in one place.

**Note:** Only download Windows ISOs from Microsoft's official pages. Third-party sources are a common way to end up with a tampered image.

## Step 2: Create the Client Virtual Machine

With the ISO ready, create the second VM the same way DC 01 was created in the earlier lab, using the New Virtual Machine Wizard in Hyper-V Manager.

### Create a subfolder for this VM

1. Open File Explorer and go to the Hyper-V Labs folder.
2. Create a new folder inside it for this VM, for example `Didi Client PC 1`. Keeping each VM in its own subfolder inside Hyper-V Labs keeps the lab organized as it grows.

### Run the New Virtual Machine Wizard

1. In Hyper-V Manager, click **New**, then **Virtual Machine**.

![Open Hyper-V Manager and start the New Virtual Machine Wizard](images/01-open-hyper-v-manager.png)
2. On the **Before You Begin** screen, click **Next**.

![Before You Begin screen](images/02-new-vm-before-you-begin.png)
3. On **Specify Name and Location**, name it `Didi Client PC 1`. Tick **Store the virtual machine in a different location** and browse to the subfolder just created.

![Specify the client VM name and location](images/03-name-and-location-client-vm.png)
4. On **Specify Generation**, select **Generation 2**, the same as DC 01, and click **Next**.

![Select Generation 2](images/04-select-generation-2.png)
5. On **Assign Memory**, tick **Use Dynamic Memory for this virtual machine** and set **Startup memory** to `1024 MB`.

   **Note:** 1024 MB is enough to install and run Windows 10 for this lab, but it will feel slow. That is expected and not a sign that anything is wrong.

![Assign startup memory and enable Dynamic Memory](images/05-assign-dynamic-memory.png)

6. On **Configure Networking**, select the same virtual switch the domain controller is using, `Didi private Virtual Switch`. This is what lets the two VMs communicate.

![Select the private virtual switch](images/06-select-private-virtual-switch.png)
7. On **Connect Virtual Hard Disk**, confirm **Create a virtual hard disk** is selected. The name and location fill in automatically based on the VM name and folder chosen. Set the size to `30 GB` and click **Next**.

![Create the 30 GB virtual hard disk](images/07-create-30gb-virtual-disk.png)
8. On **Installation Options**, select **Install an operating system from a bootable image file**, click **Browse**, and select the Windows 10 ISO downloaded in Step 1.

![Select the Windows 10 ISO](images/08-select-windows-10-iso.png)
9. On **Summary**, review the configuration and click **Finish**.

![Review the client VM configuration](images/09-review-client-vm-summary.png)

## Step 3: Verify the VM Before Powering It On

Just like with DC 01, it is worth a quick check before the first boot.

1. Right-click `Didi Client PC 1` and select **Settings**.

![Open the client VM settings](images/10-open-client-vm-settings.png)
2. Under **Firmware**, confirm the DVD Drive is at the top of the boot order.

![Confirm DVD Drive boot order](images/11-verify-dvd-boot-order.png)
3. Under **Security**, confirm **Enable Secure Boot** is checked with the template set to **Microsoft Windows**. Generation 2 VMs need this to boot the Windows ISO, the same as DC 01. Click **OK**.

![Confirm Secure Boot settings](images/12-confirm-secure-boot-settings.png)

## Step 4: Install Windows 10

1. In Hyper-V Manager, right-click `Didi Client PC 1` and select **Connect**.
2. Click the green **Start** button. When the prompt “Press any key to boot from CD or DVD” appears, click inside the window and press a key promptly.
3. On the first setup screen, choose the language, time and currency format, and keyboard layout, then click **Next**.

![Windows Setup language and region screen](images/13-windows-setup-language-region.png)
4. Click **Install now**.
5. When asked for a product key, click **I don't have a product key**.

![Choose not to enter a product key](images/14-windows-product-key-prompt.png)

   **Note:** This is expected for a lab. You are not activating the copy of Windows, just installing it.

6. On **Select the operating system you want to install**, choose **Windows 10 Pro**, then click **Next**.

   **Note:** Windows 10 Pro is the deliberate choice here, not Home. Windows 10 Home cannot join a domain; the option is simply not available in its System Properties. Pro, Enterprise, and Education are the editions that support domain join.

7. Accept the license terms and click **Next**.
8. On **Which type of installation do you want**, click **Custom: Install Windows only (advanced)**.
9. On **Where do you want to install Windows**, select the 30 GB drive created earlier and click **Next**.

![Select the virtual drive for Windows installation](images/15-select-windows-installation-drive.png)

Setup now copies files and installs Windows. The VM will restart on its own one or more times. Do not interrupt it.

![Windows installation progress](images/16-windows-installation-progress.png)

## Step 5: Complete the Out of Box Setup

After installation finishes, Windows 10 walks through its first-time setup, known as the Out of Box Experience.

1. Select a region, for example **United States**, and click **Yes**.
2. Select a keyboard layout and click **Yes**. Skip adding a second layout unless needed.
3. When asked **Let's connect you to a network**, click **I don't have internet**.

![Choose the option to continue without internet](images/17-windows-oobe-no-internet.png)
4. On the next prompt, click **Continue with limited setup**.

![Continue with limited setup](images/18-continue-with-limited-setup.png)
5. Enter a name for this PC, for example `Divineg`, then click **Next**.

![Enter a name for the client PC](images/19-enter-client-pc-name.png)
6. Create a strong password, confirm it, and click **Next**.

![Create the local account password](images/20-create-local-account-password.png)
7. Answer the three security questions and click **Next**.
8. Wait for Windows to finish setting up. It will land on the desktop signed in as the local account just created.

![Windows 10 client desktop](images/21-windows-10-client-desktop.png)

**Note:** At this stage, `Didi Client PC 1` is a standalone computer with a local account only. Once it is joined to the domain later in this documentation, that local account stays on the machine, but sign-in will happen with a domain account instead. The local account will no longer show up on the login screen once the domain account is in use.

## Step 6: Understand the IP Addressing for This Lab

Before configuring the client's network settings, it is worth breaking down the addressing scheme used here, since understanding it makes troubleshooting far easier later.

In the earlier lab, the domain controller was given the static IP `192.168.6.1` with a subnet mask of `255.255.255.252`, a `/30`. To demonstrate subnetting principles within a single lab environment, a slightly larger allocation, `192.168.6.0/27`, was divided into eight equal `/30` subnets. A `/30` holds only four addresses: one network ID, one broadcast address, and two usable host addresses, tight, but perfectly suited to a point-to-point style link between exactly two machines.

Splitting a `/27` into eight `/30` subnets gives blocks starting at `192.168.6.0`, `.4`, `.8`, `.12`, `.16`, `.20`, `.24`, and `.28`.

For this lab, the first of those subnets, `192.168.6.0/30`, is used. Inside that block, `.0` is the network ID and `.3` is the broadcast address, which leaves exactly two usable addresses: `.1` and `.2`. The domain controller took `.1`, which means the client PC has exactly one valid address remaining inside that subnet: `192.168.6.2`.

**Note:** This tight addressing was a deliberate choice for a two-machine lab. In a production environment, or when adding more clients later, widening the mask back out to the full `/27` would open up room for up to 30 hosts on this same segment.

## Step 7: Disable IPv6 on the Domain Controller's Network Adapter

This is a small tidy-up step on DC 01, not on the client. Since this lab uses IPv4 addressing only, disabling IPv6 on both machines keeps things simple and avoids any confusion about which protocol is handling communication.

1. On DC 01, open **Server Manager**, click **Local Server**, then click the link next to **Ethernet** under **Properties**.
2. In **Network Connections**, right-click the adapter and select **Properties**.
3. Untick **Internet Protocol Version 6 (TCP/IPv6)** and click **OK**.

![Disable IPv6 on the domain controller adapter](images/22-disable-ipv6-on-domain-controller.png)

## Step 8: Configure the Client PC's Network Settings

1. On `Didi Client PC 1`, click the network icon on the taskbar, then click **Network and Internet settings**.
2. Click **Change adapter options**.

![Open Change adapter options](images/23-open-client-network-settings.png)
3. Right-click **Ethernet** and select **Properties**. Untick **Internet Protocol Version 6 (TCP/IPv6)**.

![Open Ethernet adapter properties](images/24-open-ethernet-adapter-properties.png)
4. Confirm **Internet Protocol Version 4 (TCP/IPv4)** is ticked, then select it and click **Properties**.
5. Click **Use the following IP address**. Enter `192.168.6.2` as the IP address and `255.255.255.252` as the subnet mask.
6. Click **Use the following DNS server addresses**, and enter `192.168.6.1`, the domain controller's address, as the preferred DNS server. This is what lets the client resolve names inside the `divineuzor.com` domain.
7. Click **OK**, then **Close**.

![Set the client IPv4 address, subnet mask, and preferred DNS server](images/25-configure-client-ip-and-dns.png)

**Note:** Entering an IP address outside the usable range for this subnet triggers a warning from Windows when applying it. That warning is Windows confirming the address does not belong to this network.

## Step 9: Test Connectivity with Ping

1. On the client PC, open Command Prompt.
2. Type `ping 192.168.6.1` and press **Enter**.
3. Replies should come back from the domain controller, confirming the two machines can reach each other over the private switch.

![Successful ping to the domain controller](images/26-verify-ping-to-domain-controller.png)

**Note:** To see what a mismatch looks like, temporarily change the client's IP address to something outside this subnet, for example `192.168.6.10` with the same mask, and try the ping again. It will fail, since `192.168.6.10` is not part of the same `/30` network as the domain controller. Set the address back to `192.168.6.2` afterward, since the domain join in the next step depends on the client being able to reach the domain controller.

![Ping fails when the client uses an address outside the subnet](images/27-demonstrate-ping-failure-outside-subnet.png)

## Step 10: Join the Client PC to the Domain

1. On the client PC, open File Explorer, right-click **This PC**, and select **Properties**.

![Open This PC properties](images/28-open-client-system-properties.png)
2. Find the link next to **Related settings** called **Advanced system settings**, and click it. This opens System Properties. Click on the **Computer Name** tab.
3. Click **Change**.

![Open the computer name and domain changes dialog](images/29-open-computer-name-settings.png)
4. Under **Member of**, select **Domain**, and type `divineuzor.com`.
5. Click **OK**.

![Select domain membership and enter the domain name](images/30-select-domain-membership.png)
6. When prompted, enter the credentials of an account with permission to join computers to the domain, for example `DIVINEUZOR\Administrator`, and the matching password.

![Enter credentials for joining the domain](images/31-enter-domain-join-credentials.png)
7. After a short pause, a message welcoming the PC to the `divineuzor.com` domain appears.

![Domain join success message](images/32-domain-join-success-message.png)
8. Click **OK**, then click **OK** again on the message about restarting. Click **Restart Now**.

![Confirm the restart after joining the domain](images/33-confirm-restart-after-domain-join.png)

## Step 11: Sign In with the Domain Account

1. After the restart, the sign-in screen offers a choice between **Other user** and the local account. Click **Other user**.

![Choose Other user on the sign-in screen](images/34-select-other-user-at-sign-in.png)
2. Sign in using `DIVINEUZOR\Administrator`, or the domain user account created in the previous lab, and the matching password.
3. Once signed in, open **Settings**, then **Accounts**, then **Access work or school**, and confirm the connection to `divineuzor.com` is listed. Alternatively, open **System Properties** again and confirm the **Computer Name** tab now shows `divineuzor.com` under **Domain** instead of the old workgroup name.

![Verify domain membership on the client PC](images/35-verify-domain-membership-on-client.png)

## Step 12: Verify the Client PC in Active Directory

1. On DC 01, open **Active Directory Users and Computers**.
2. Expand `divineuzor.com`, then click the **Computers** container.
3. Confirm `Divineg` appears in the list as a Computer object.

![Verify the client computer object in Active Directory](images/36-verify-client-computer-object-in-ad.png)

## Up Next

Two machines are now talking to each other on an isolated private network: a domain controller managing identity for `divineuzor.com`, and a Windows 10 client that trusts it. From here, future work in this series can explore moving this computer object into one of the existing OUs, applying Group Policy to it, and signing in as one of the department-specific users created in the previous lab to see permissions and policy in action.
