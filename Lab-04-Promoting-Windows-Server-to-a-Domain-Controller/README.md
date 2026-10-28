# Building a Windows Server Lab on Hyper-V

## Post-Installation Configuration and Promoting the Server to a Domain Controller

This lab continues from the previous lab, where we installed Windows Server 2019 and completed the initial post-installation configuration. With the server ready, we will carry out a few additional configuration tasks before installing Active Directory Domain Services (AD DS) and promoting the server to a Domain Controller (DC).

This process transforms the standalone server into the foundation of our Active Directory lab environment, allowing us to manage domain users, groups, organizational units, and other directory services in subsequent labs.

## Step 1: Post-Installation Configuration

Before making any structural changes, we tidy up two small items left over from the default installation. Almost all of our configuration from this point on happens inside Server Manager.

**1. Open Server Manager:** Open Server Manager and click Local Server on the left menu.

![Open Server Manager and select Local Server](images/01-server-activation.png)

**2. Enter the Product ID:** Under Properties, click the link next to Product ID, and enter your product key if you have one. This step is optional for an evaluation edition, but worth knowing about for real deployments, where servers are usually activated immediately after installation.

![Enter the product key](images/02-enter-product-key.png)

**3. Rename the computer:** Click the link next to Computer name.

![Locate the computer name setting](images/03-rename-server.png)

**4.** Click Change, type a clear, descriptive name for this server, then click OK.

![Change the computer name](images/04-change-computer-name.png)

**5.** Restart the server when prompted, so the new name takes effect.

**Note:** Renaming the server before promoting it to a domain controller is standard practice.

Once a server is a domain controller, changing its name becomes a much more involved process, since the name is tied into DNS, the domain database and every domain-joined computer’s configuration.

## Step 2: Workgroup vs Domain

By default, every Windows Server installs into a Workgroup, a loose, peer-to-peer grouping where each computer manages its own local accounts and security settings independently. There's no central authority; every machine is an island.

A Domain works differently. It is a centrally managed group of computers that all trust one authority for identity and security. Usernames, passwords, permissions, and policies are defined once and applied everywhere. This is exactly why organizations use domains. A new employee's account is created once, on one server, and that identity works across every domain-joined computer, printer, and shared folder in the company.

The server that holds and manages this central authority is called a Domain Controller. To turn a plain Windows Server into a Domain Controller, we install a specific role: Active Directory Domain Services (AD DS). Once installed and configured, any computer we connect to this domain becomes a domain-joined computer, and from that point on, its identity and security are managed centrally by our Domain Controller rather than locally.

**Note:** In most established companies, this initial setup is already done long before a new IT hire ever touches it. Where this skill becomes relevant on the job is usually when a company needs an additional or backup domain controller for an existing domain which is a much simpler process than creating the very first one, which is what we’re doing here.

## Step 3: Choosing a Domain Name for this Lab

For this lab, we will use divineuzor.com.

## Step 4: Install the Active Directory Domain Services Role

**1. Launch the wizard:** In Server Manager, click dashboard, then click Add roles and features.

![Launch the Add Roles and Features Wizard](images/05-add-roles-and-features.png)

**2.** On the Before you Begin screen, read the notes and click next.

![Before You Begin screen](images/06-installation-type.png)

**3.** On Installation Type, select Role-based or feature-based installation, then click Next.

![Installation Type selection](images/07-select-server.png)

**4.** On Server Selection, select a server from the server pool, choose your VM from the list, then click Next.

![Server Selection](images/08-select-ad-ds-role.png)

**5.** On Server Roles, tick the box for Active Directory Domain Services, then click Next.

(A dialog will prompt you to add required supporting features. Accept it.)

![Select Active Directory Domain Services and add required features](images/09-add-required-features.png)

**6.** On Features, tick any additional features you want. Several are ticked by default and are fine to leave as-is. Click Next.

**7.** On the AD DS introduction screen, read the notes and click Next.

![AD DS introduction screen](images/10-ad-ds-introduction.png)

**8.** On Confirmation, review everything you selected, then click Install.

![Confirm installation selections](images/11-confirm-installation-selections.png)

**9.** On the Results screen, wait for the installation to complete. Once it finishes, click the link that appears: Promote this server to a domain controller.

![AD DS installation results](images/12-installation-progress.png)

## Step 5: Promote the Server to a Domain Controller

**1.** Clicking that link opens the Active Directory Domain Services Configuration Wizard, which is where the actual promotion happens.

**2.** Under Deployment Configuration, select Add a new forest, since this is the very first domain controller in our environment.

**3.** Under Root domain name, type divineuzor.com, then click Next.

![Create a new forest and enter the root domain name](images/13-create-new-forest.png)

**4.** Under Domain Controller Options, review the Forest functional level. This setting defines the minimum Windows Server version any domain controller in this forest can run.

**5.** Confirm that Domain Name System (DNS) server and Global Catalog (GC) are both selected. They're selected by default for the first DC in a new forest.

**6.** Type and confirm a Directory Services Restore Mode (DSRM) password. This is a separate emergency-recovery password, distinct from your Administrator password, used only if AD DS ever needs to be repaired in restore mode. Click Next.

**Note:** Store the DSRM password somewhere safe, separately from your regular password.

![Domain Controller Options and DSRM password](images/14-domain-controller-options.png)

**7.** This warning below is expected and can be safely ignored when creating a new forest root domain. Since divineuzor.com is being set up as a brand new forest with no existing parent domain above it in DNS, there is no authoritative parent zone available to delegate authority from. This message simply confirms that this DC will be the top-level authority for DNS within this new forest, this is normal for a first domain controller in a new environment. Leave "Create DNS delegation" unchecked and click next to proceed.

![DNS delegation warning](images/15-dns-delegation-warning.png)

**8.** Under Additional Options, Windows automatically suggests a NetBIOS name derived from your domain name (maximum 15 characters). Accept the suggested name and click Next.

![Additional Options and NetBIOS name](images/16-netbios-domain-name.png)

**9.** Click through the Paths screen (default database, log, and SYSVOL folder locations are fine for a lab) and click Next.

![AD DS database, log, and SYSVOL paths](images/17-ad-ds-paths.png)

**10.** On Review Options, review everything you've configured. If you'd like to see the equivalent PowerShell commands, click “View script” Click Next.

![Review Options](images/18-review-options.png)

**11.** On Prerequisites Check, wait for validation to complete, then click Install.

![Prerequisites Check](images/19-prerequisites-check.png)

**12.** The server will apply the configuration and restart automatically. When it comes back, it's no longer a workgroup computer, it's the domain controller for divineuzor.com.

![Server restarting during promotion](images/20-server-restarting.png)

## Step 6: First Sign-In as a Domain Controller

**1.** After the restart, the sign-in screen displays `DIVINEUZOR\Administrator`, confirming Windows recognize this as a domain login rather than a local one. This format follows the pattern [NetBIOS domain name][username], DIVINEUZOR being the domain name generated from divineuzor.com, and Administrator being the built-in account used during ADDS installation.

![Domain Administrator sign-in](images/21-domain-administrator-sign-in.png)

**2.** Enter the password set earlier for the built-in administrator and sign in.

**3.** Notice the sign-in screen now references your domain (e.g. “Sign in to DIVINEUZOR”) instead of the local workgroup.

**4.** Open Server Manager and click Local Server. Confirm that the Domain field now shows divineuzor.com instead of the old workgroup name.

![Verify the domain in Server Manager](images/22-verify-domain-controller.png)

**Note:** There’s no limit on how many computers can join a single domain. For this lab, any client computer we add going forward can be joined to divineuzor.com and centrally managed from this server.

## Up Next

We now have a fully functioning Domain Controller for the divineuzor.com forest. The workgroup is gone, replaced by centralized identity and security management. The next lab in this series will pick up from here: creating our first domain user account and exploring how identity now flows from this one central point.
