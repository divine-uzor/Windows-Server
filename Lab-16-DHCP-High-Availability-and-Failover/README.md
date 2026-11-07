# Lab 16: DHCP High Availability and Failover

## Introduction

This technical report documents the deployment and validation of DHCP High Availability using Load-Balance Failover across Windows Server 2019 domain controllers. The configuration is designed to maintain address allocation if one DHCP server becomes unavailable.

The exercise covers Active Directory integration, custom scope configuration, failover parameters, and service fault-tolerance testing. All operational steps and failover behaviour are verified using a Windows 10 client.

## 1. Scenario

An organization wants its computers to receive IP addresses automatically, and wants the service to stay available if one DHCP server fails. The administrator installs DHCP on one domain controller, creates a scope, and adds a second domain controller as a failover partner.

## 2. Lab Environment

| Machine | IP address | Role in this lab |
|---|---|---|
| DC01 (DIVINE-DCO1) | `192.168.6.1` | Primary DHCP server |
| DC02 (DIVINE-DC02) | `192.168.6.3` | Failover partner |
| Client PC | `192.168.6.2` (static before the lab) | Receives an address from DHCP |

### Scope plan

| Setting | Value |
|---|---|
| Scope name | `LAN-Scope` |
| Address range | `192.168.6.10` to `192.168.6.30` |
| Subnet mask | `255.255.255.224` (length 27) |
| Lease duration | 8 days (default) |
| Router (gateway) | None. This network has no gateway |
| DNS servers | `192.168.6.1` and `192.168.6.3` |
| DNS domain | `divineuzor.com` |
| Failover mode | Load balance (50% / 50%) |

**Note:** The range starts at `.10` and ends at `.30`, so the scope never hands out `.1`, `.2`, or `.3`, which are already in use as static addresses.

## 3. Objectives

- Install the DHCP Server role and authorize it in Active Directory.
- Create and activate a DHCP scope with the correct options.
- Install DHCP on a second server.
- Configure DHCP failover between the two servers.
- Confirm a client receives its address automatically.
- Test that the service continues when one server stops.

## 4. Part 1: Pre-Checks

1. On the client PC, open Command Prompt and run `ipconfig /all`. Confirm DHCP Enabled shows No and the address is `192.168.6.2`.

   ![Client DHCP disabled before configuration](images/01-Verify-Client-DHCP-Disabled.png)

2. From the client, run `ping 192.168.6.1` and `ping 192.168.6.3`. Both should reply.

   ![Connectivity checks to both domain controllers](images/02-Verify-Connectivity-to-Both-Servers.png)

## 5. Part 2: Install and Authorize DHCP on DC01

1. On DC01, open Server Manager, click Manage, then Add Roles and Features.

   ![Open Add Roles and Features on DC01](images/03-Open-Add-Roles-and-Features-on-DC01.png)

2. Click Next until Server Selection. Select DC01 and click Next.

   ![Select DC01 in Server Selection](images/04-Select-DC01-Server.png)

3. On Server Roles, tick DHCP Server. If a window appears asking to add features, click Add Features.

   ![Select DHCP Server role](images/05-Select-DHCP-Server-Role.png)

4. Click Next through the remaining pages, then click Install.

   ![Confirm DHCP installation](images/06-Confirm-DHCP-Installation.png)

5. When the installation finishes, click Complete DHCP configuration in the results window. If you closed it, use the yellow flag at the top of Server Manager.

   ![Review DHCP installation progress](images/07-Review-DHCP-Installation-Progress.png)

6. In the DHCP Post-Install configuration wizard, choose the default option to use your domain administrator credentials, click Commit, then Close.

   ![Complete DHCP post-install configuration](images/08-Complete-DHCP-Post-Install-Configuration.png)

### Verify

In Server Manager, click Tools. DHCP should now be listed.

![Verify DHCP in Server Manager Tools](images/09-Verify-DHCP-in-Server-Manager-Tools.png)

**Why authorization matters:** In a domain, a DHCP server must be authorized in Active Directory before it will hand out addresses. This step does that for you.

## 6. Part 3: Create the Scope on DC01

1. Open Tools → DHCP.
2. Expand `DIVINE-DCO1.divineuzor.com`, right-click IPv4, and select New Scope.

   ![Open the New Scope wizard](images/10-Open-New-Scope-Wizard.png)

3. Click Next on the welcome page.

   ![New Scope Wizard welcome page](images/11-New-Scope-Wizard-Welcome.png)

4. Scope Name: enter `LAN-Scope` and click Next.

   ![Enter LAN-Scope as the scope name](images/12-Enter-LAN-Scope-Name.png)

5. IP Address Range:
   - Start IP address: `192.168.6.10`
   - End IP address: `192.168.6.30`
   - Length: `27` (the subnet mask fills in as `255.255.255.224`)

   Click Next.

   ![Configure the scope IP address range](images/13-Configure-Scope-IP-Address-Range.png)

6. Add Exclusions and Delay: leave empty and click Next.
7. Lease Duration: keep the default of 8 days and click Next.

   ![Configure the lease duration](images/14-Configure-Scope-Lease-Duration.png)

8. Configure DHCP Options: select Yes, I want to configure these options now and click Next.

   ![Choose to configure DHCP options](images/15-Configure-DHCP-Options.png)

9. Router (Default Gateway): leave blank and click Next. This network has no gateway.
10. Domain Name and DNS Servers:
    - Parent domain: `divineuzor.com`
    - Enter `192.168.6.1` and click Add.
    - Enter `192.168.6.3` and click Add.

    Click Next.

    ![Configure domain name and DNS servers](images/16-Configure-Domain-and-DNS-Servers.png)

11. WINS Servers: leave empty and click Next.
12. Activate Scope: select Yes, I want to activate this scope now then click Next.

    ![Activate the DHCP scope](images/17-Activate-DHCP-Scope.png)

13. On the completion page, click Finish.

    ![Complete the New Scope wizard](images/18-Complete-New-Scope-Wizard.png)

### Verify

Expand the scope. Address Pool shows the range `192.168.6.10` to `192.168.6.30`, and Scope Options lists 006 DNS Servers and 015 DNS Domain Name. The scope should show as active, not with a red down arrow.

![Verify scope address pool and options](images/19-Verify-Scope-Address-Pool-and-Options.png)

## 7. Part 4: Install and Authorize DHCP on DC02

1. Sign in to DC02.
2. Repeat Part 2 on DC02: install the DHCP Server role, then click Complete DHCP configuration and commit.

   ![Install DHCP role on DC02](images/20-Install-DHCP-Role-on-DC02.png)

   
**Important:** Do not create a scope on DC02. The failover wizard copies the scope from DC01. It will not work if the same scope already exists on the partner.

![Complete DHCP post-install configuration on DC02](images/21-Complete-DHCP-Post-Install-on-DC02.png)


## 8. Part 5: Configure DHCP Failover

Do this on DC01.

1. In the DHCP console, right-click the scope LAN-Scope (or IPv4) and select Configure Failover.

   ![Start DHCP failover configuration](images/22-Start-DHCP-Failover-Configuration.png)

2. Select scopes: ensure `192.168.6.0` is checked (or leave Select all checked) and click Next.

   ![Select the scope for failover](images/23-Select-Scope-for-Failover.png)

3. Partner server: click Add Server, enter `192.168.6.3` (or browse for DIVINE-DC02), and click OK. Then click Next.

   ![Select DC02 as the failover partner](images/24-Select-DC02-as-Failover-Partner.png)

4. Create a new failover relationship:
   - Relationship name: `DC01-DC02-Failover`
   - Maximum Client Lead Time: leave the default.
   - Mode: Load balance (the default).
   - Load Balance Percentage: 50% for the local server and 50% for the partner.
   - Tick Enable Message Authentication and enter a shared secret of your choice.

   Click Next.

   ![Configure the failover relationship](images/25-Configure-Failover-Relationship.png)

   Then click Finish.

   ![Review failover relationship settings](images/26-Review-Failover-Relationship-Settings.png)

5. The wizard shows its progress as it creates the relationship and copies the scope to DC02. Wait for all steps to show Successful, then click Close.

   ![Complete failover configuration](images/27-Complete-Failover-Configuration.png)

### Verify

1. On DC01, right-click the IPv4 and select Properties. Open the Failover tab. It shows the relationship name, the partner, the mode, and State of this Server: Normal.

   ![Verify failover configuration on DC01](images/28-Verify-Failover-on-DC01.png)

2. Open the DHCP console on DC02, right-click the server name, and select Refresh. LAN-Scope now appears there with the same address pool and scope options.
3. Check the Failover tab on DC02 as well.

   ![Verify the scope and failover configuration on DC02](images/29-Verify-Failover-Scope-on-DC02.png)

## 9. Part 6: Test DHCP from the Client

### Step 1: Switch the client to DHCP

1. On the client PC, press Win + R, type `ncpa.cpl`, and press Enter.
2. Right-click Ethernet and select Properties.

   ![Open client Ethernet properties](images/30-Open-Client-Ethernet-Properties.png)

3. Double-click Internet Protocol Version 4 (TCP/IPv4).
4. Select Obtain an IP address automatically and Obtain DNS server address automatically. Click OK, then Close.

   ![Configure automatic IP and DNS addressing](images/31-Configure-Client-for-Automatic-IP-and-DNS.png)

### Step 2: Check the address

Open Command Prompt on the client and run:

```cmd
ipconfig /release
ipconfig /renew
ipconfig /all
```

Check that:

- DHCP Enabled is Yes.
- The IPv4 address is inside `192.168.6.10` to `192.168.6.30`.
- DHCP Server shows `192.168.6.1` or `192.168.6.3`.
- DNS Servers shows `192.168.6.1` and `192.168.6.3`.
- The Lease Obtained and Lease Expires dates are shown.

![Release and renew the client IP address](images/32-Release-and-Renew-Client-IP-Address.png)

### Step 3: Check the lease on the server

On the DHCP server that answered, expand the scope and click Address Leases. The client's address and computer name appear there.

![Verify the client DHCP lease on the server](images/33-Verify-Client-DHCP-Lease-on-Server.png)

### Step 4: Confirm the network still works

On the client, run `nslookup divineuzor.com` and `ping DIVINE-DCO1`. Both should succeed, which proves the DNS settings from the scope are working.

![Verify DNS resolution and connectivity](images/34-Verify-DNS-Resolution-and-Connectivity.png)

## 10. Part 7: Test Failover

### Step 1: Stop DHCP on the serving server

1. On the client, note the DHCP Server address from `ipconfig /all` in Part 6. This is the server that answered.
2. On that server, open `services.msc`, right-click DHCP Server, and select Stop. You can also run `Stop-Service dhcpserver` in PowerShell.

   ![Stop the DHCP Server service](images/35-Stop-DHCP-Server-Service.png)

### Step 2: Request an address again

On the client, run:

```cmd
ipconfig /release
ipconfig /renew
ipconfig /all
```

The client still gets an address, and DHCP Server now shows the other server (the partner).

![Verify the client receives an address from the partner](images/36-Verify-Client-Receives-Address-from-Partner.png)

### Step 3: Check the partner

On the partner server, open Address Leases. The client's lease is listed. Also open the scope’s Failover tab. It shows State of this Server: Lost contact with partner and State of Partner Server: Not available while the other server is stopped.

![Verify the partner lease and failover state](images/37-Verify-Failover-Partner-Lease-and-State.png)

### Step 4: Restore the stopped server

Start the DHCP Server service again.

![Restart the DHCP Server service](images/38-Restart-DHCP-Server-Service.png)

After a short time, refresh the Failover tab. Both State of this Server and State of Partner Server return to Normal.

![Verify failover returns to Normal](images/39-Verify-Failover-Returns-to-Normal.png)

## 11. Verification

Confirm that:

- DHCP is installed and authorized on both servers.
- LAN-Scope exists on DC01 and was copied to DC02 by the failover wizard.
- The failover relationship shows the state Normal on both servers.
- The client received an address from the scope, plus the DNS settings.
- The client still received an address when one DHCP server was stopped.

## 12. Troubleshooting

| Problem | What to check |
|---|---|
| Client gets an address like `169.254.x.x` | No DHCP server answered. Check that the scope is activated and the server is authorized. |
| Client gets an address but can't find the domain | Check that scope options 006 (DNS servers) and 015 (domain name) are set. |
| Failover wizard reports the scope already exists on the partner | Delete the scope on DC02, then run the wizard again from DC01. |
| Failover state shows Lost contact with partner | The partner is stopped or unreachable. Check that both servers can reach each other and that the DHCP Failover firewall rules are enabled. |
| DC02 doesn't show the scope | Right-click the server in the DHCP console and select Refresh. |
| Wrong DHCP server answers | Run `ipconfig /all` and read the DHCP Server line. A server outside your lab means another DHCP server is on the network. |

## 13. Key Takeaways

- DHCP gives devices IP addresses and settings automatically.
- A scope is the range of addresses the server may hand out, and scope options deliver extras such as DNS servers.
- In a domain, a DHCP server must be authorized in Active Directory.
- Failover pairs two servers so the service continues if one stops. In load balance mode, both answer clients and share the work.
- The failover wizard copies the scope to the partner, so the scope should be created only once.

## Conclusion

In this lab I installed and authorized the DHCP Server role on one domain controller, created and activated a scope with DNS options, and installed DHCP on a second domain controller. I then configured load-balance failover between the two servers. A client PC received its address automatically, and it kept getting addresses when one DHCP server was stopped.
