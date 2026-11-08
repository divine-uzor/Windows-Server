# NTFS PERMISSION MANAGEMENT

## Creating Security Groups, Assigning Permissions, and Mapping Network Drives

## Lab Overview

You will manage access to shared folders in a Windows Server environment by using Active Directory security groups and NTFS permissions. Building on the NTFS and share permission concepts from Lab 09, this exercise applies different access levels to a practical folder structure for different roles.

The configuration includes two security groups, two user accounts, a shared parent folder, and subfolders with distinct permissions. It also demonstrates how to disable inheritance on a subfolder and how to map the shared folder as a network drive from a client PC.

## What This Lab Covers

NTFS permissions control who can access files and folders on an NTFS-formatted drive and what they are allowed to do. You will create security groups and user accounts, assign permissions at different folder levels, configure share access, test the resulting access, and map the shared folder as a network drive.

## Key Concepts Applied

- The five NTFS permission levels: Full Control, Modify, Read & Execute, Read, and Write.
- Permissions are cumulative, and an explicit Deny overrides an Allow.
- Files and folders inherit permissions from their parent unless inheritance is disabled.
- Share permissions apply to network access, while NTFS permissions apply to both local and network access.

## Lab Environment and Objectives

The lab uses two domain controllers, DC01 and DC02, and one domain-joined client PC in the `divineuzor.com` domain. The server-side configuration is performed on DC01. Two user accounts and two security groups are created specifically for this exercise.

The objective is to configure a shared folder structure and control access to its contents by role. CLOUD SNR receives Full Control over the parent folder, while CLOUD ENG receives Modify access to Code and Read access to Infra. Inheritance is disabled on Infra so its permissions can be managed independently. The configuration is then tested using the two user accounts, and the shared folder is mapped as a network drive.

| Item | Purpose |
|---|---|
| CLOUD ENG (security group) | Receives different access levels across the folder structure |
| CLOUD SNR (security group) | Receives Full Control across the folder structure |
| Chizaram Kelvin | Member of CLOUD ENG |
| Amara Nwoye | Member of CLOUD SNR |

## Task 1: Create Two Security Groups

A security group lets you assign permissions once, to the group, instead of repeating the same setup for every individual user. Two are created here: one for senior staff, one for junior staff

On DC01, open Server Manager, click Tools, then Active Directory Users and Computers.

1. Navigate to the IT organizational unit (OU).
2. Right-click the IT OU, select New, then Group.

![01 – open active directory users and computers](images/01-open-active-directory-users-and-computers.png)

3. Enter Group name: CLOUD SNR. Under Group scope, select Global. Under Group type, select Security. Click OK.

![02 – create cloud snr security group](images/02-create-cloud-snr-security-group.png)

4. Repeat the group creation process to create a second group named CLOUD ENG, with the same Global scope and Security type.

![03 – verify cloud security groups](images/03-verify-cloud-security-groups.png)

## Task 2: Create Two User Accounts

1. In Active Directory Users and Computers, navigate to the IT OU.
2. Right-click the OU, select New, then User.

![04 – open new user wizard in it ou](images/04-open-new-user-wizard-in-it-ou.png)

3. Enter First name: Chizaram, Last name: Kelvin. Set User logon name to Chizaram, then click Next.

![05 – enter chizaram kelvin account details](images/05-enter-chizaram-kelvin-account-details.png)

4. Enter a password, confirm it, choose the password option that fits (for a lab, unchecking "User must change password at next logon" keeps things simple), then click Next, then Finish.

![06 – set password and create chizaram account](images/06-set-password-and-create-chizaram-account.png)

5. Repeat steps 2 to 4 to create a second user: First name Amara, Last name: Nwoye, User logon name Amara.

![07 – verify user accounts in it ou](images/07-verify-user-accounts-in-it-ou.png)

## Task 3: Add Each User to Their Security Group

1. Double-click the CLOUD SNR group, click the Members tab, then click Add.
2. Type Amara Nwoye, click Check Names, then click OK, then OK again to close the group's Properties.

![08 – add amara nwoye to cloud snr group](images/08-add-amara-nwoye-to-cloud-snr-group.png)

3. Repeat the same process for the CLOUD ENG group: Members tab, Add, type Chizaram Kelvin, Check Names, OK, OK.

4. Confirm that the user account has been successfully added to the security group. Group membership enables the user to inherit the access permissions associated with the group.

![09 – add chizaram kelvin to cloud eng group](images/09-add-chizaram-kelvin-to-cloud-eng-group.png)


## Task 4: Create the Folder Structure

1. On DC01, open File Explorer and go to the C: drive.
2. Create a new folder named Cloud Files.

![10 – verify security group memberships](images/10-verify-security-group-memberships.png)

3. Inside Cloud Files, create two subfolders: Code and Infra.

![11 – create cloud files folder](images/11-create-cloud-files-folder.png)


## Task 5: Grant CLOUD SNR Full Control on Cloud Files

Senior staff need complete access to the whole folder structure, including the ability to manage permissions for others. Full Control on the top-level folder gives them that.

1. Right-click Cloud Files and select Properties

![12 – create code and infra subfolders](images/12-create-code-and-infra-subfolders.png)

2. Click the Security tab, click edit, then Add.
3. Type CLOUD SNR, click Check Names, then click OK.

![13 – open cloud files folder properties](images/13-open-cloud-files-folder-properties.png)


4. With CLOUD SNR selected, check the Allow box next to Full Control. Click Apply, then OK.

![14 – add cloud snr to ntfs permissions](images/14-add-cloud-snr-to-ntfs-permissions.png)



With Full Control, members of CLOUD SNR can open and read files, create new files and folders, edit and save changes, delete files and folders, change permissions, and take ownership, anywhere inside Cloud Files and its subfolders.

## Task 6: Share the Cloud Files Folder

NTFS permissions alone only govern local access. To reach this folder from the client PC over the network, it also needs to be shared.

1. On the folder's Properties, click the Sharing tab, then click Advanced Sharing.

![15 – grant cloud snr full control](images/15-grant-cloud-snr-full-control.png)

2. Check "Share this folder". Leave the share name as Cloud Files.
3. Click Permissions. Select the default Everyone entry and remove it.

![16 – open advanced sharing settings](images/16-open-advanced-sharing-settings.png)


4. Click Add, type CLOUD SNR, click Check Names, then click OK.

![17 – remove everyone from share permissions](images/17-remove-everyone-from-share-permissions.png)

5. With CLOUD SNR selected, check the Allow box next to Full Control. Click Apply, then OK, then OK again, then Close.


![18 – add cloud snr to share permissions](images/18-add-cloud-snr-to-share-permissions.png)


6. The Cloud Files folder has been successfully shared, and the network path is now accessible to authorized users.

![19 – grant cloud snr full share control](images/19-grant-cloud-snr-full-share-control.png)



## Test Run 1: Confirm Senior Access

This test run will validate that a user added to the Cloud SNR security group and assigned full control permission can successfully authenticate and access the Cloud Files directory and all associated folders.

1. On the client PC, sign in as Amara Nwoye’s domain account.

![20 – verify cloud files network share path](images/20-verify-cloud-files-network-share-path.png)

2. Open File Explorer, type \DC01\Cloud Files in the address bar, and press Enter.

![21 – sign in as amara nwoye on client pc](images/21-sign-in-as-amara-nwoye-on-client-pc.png)


3. Inside the folder, right-click and create a new folder to confirm write access works.

![22 – open cloud files share from client pc](images/22-open-cloud-files-share-from-client-pc.png)


This confirms Full Control is working as expected: a member of CLOUD SNR can freely create and manage content anywhere inside Cloud Files.

## Task 7: Grant CLOUD ENG Modify on the Code Subfolder

SCENARIO

Junior engineers need to edit scripts as part of their daily work, but they shouldn't be able to change permissions or take ownership of anything. Modify permission, assigned only on the Code subfolder, gives them exactly that room to work, without administrative control.

1. Right-click the Code subfolder, select Properties, then click the Security tab.

![23 – verify senior user full control access](images/23-verify-senior-user-full-control-access.png)

2. Click Edit, then Add. Type CLOUD ENG, click Check Names, then click OK.

![24 – open code folder security properties](images/24-open-code-folder-security-properties.png)


3. With CLOUD ENG selected, check the Allow box next to Modify. Click Apply, then OK.

![25 – add cloud eng to code permissions](images/25-add-cloud-eng-to-code-permissions.png)


With Modify, CLOUD ENG members can open files, create new files and folders, edit and save changes, rename items, delete items, and view folder contents inside Code, but they cannot change who else has access.

## Task 8: Grant CLOUD ENG Read-Only on the Infra Subfolder

SCENARIO

Configuration files are sensitive: junior engineers should be able to check settings when troubleshooting but never change them by accident. Read-only access on Infra makes that mistake impossible, regardless of what access they have elsewhere.

1. Right-click the Infra subfolder, select Properties, then click the Security tab.
![26 – grant cloud eng modify on code](images/26-grant-cloud-eng-modify-on-code.png)

2. Click Edit, then Add. Type CLOUD ENG, click Check Names, then click OK.

![27 – open infra folder security properties](images/27-open-infra-folder-security-properties.png)


3. With CLOUD ENG selected, check only the Allow box next to Read. Click Apply, then OK.
![28 – add cloud eng to infra permissions](images/28-add-cloud-eng-to-infra-permissions.png)


Notice that the same group, CLOUD ENG, now has two completely different permission levels depending on which folder is being accessed: Modify in Code, Read only in Infra. NTFS permissions apply per folder, not once for the whole structure.

## Task 9: Disable Inheritance on Infra

Right now, the Read permission on Infra sits alongside whatever Cloud Files' own permissions passed down to it through inheritance. To make Infra's permission list fully explicit and independent of its parent folder, inheritance needs to be switched off.

1. On the Infra subfolder's Security tab, click Advanced.

![29 – grant cloud eng read only on infra](images/29-grant-cloud-eng-read-only-on-infra.png)

2. Click Disable inheritance.

![30 – open advanced security settings for infra](images/30-open-advanced-security-settings-for-infra.png)

3. When prompted, choose "Convert inherited permissions into explicit permissions on this object". Click OK.
![31 – disable inheritance and convert permissions](images/31-disable-inheritance-and-convert-permissions.png)



4. Inheritance has been disabled on the Infra folder, and the permissions shown are explicit permissions that have been assigned directly to the folder rather than inherited from the parent folder.
![32 – verify explicit permissions on infra](images/32-verify-explicit-permissions-on-infra.png)

Once inheritance is disabled and converted, the permissions on Infra no longer automatically update if someone changes Cloud Files' permissions later. They now exist independently, directly on Infra itself.

## Test Run 2: Confirm Junior Access at Both Levels

1. On the client PC, sign out and sign back in as Chizaram Kelvin’s domain account.

![33 – sign in as chizaram kelvin on client pc](images/33-sign-in-as-chizaram-kelvin-on-client-pc.png)

2. Open File Explorer, type \DC01\Cloud Files\Code in the address bar, and press Enter. Create or edit a file to confirm Modify access works.

![34 – verify modify access in code folder](images/34-verify-modify-access-in-code-folder.png)

3. Now navigate to \DC01\Cloud Files\Infra and attempt to delete any file inside it.

![35 – test delete access in infra folder](images/35-test-delete-access-in-infra-folder.png)

![36 – verify read only access denial](images/36-verify-read-only-access-denial.png)

Chizaram can freely edit files in Code but is blocked the moment he tries to change anything in Infra. Same user, same overall folder structure, two different outcomes, because the permission was set differently on each subfolder.

## Task 10: Map a Network Drive

Typing a full network path every time is inconvenient. Mapping a network drive gives the shared folder its own drive letter, so it behaves like any other local drive on the client PC.

1. On the client PC, open File Explorer.
2. Right-click the Cloud Files folder under Network and select Map network drive.

![37 – open map network drive option](images/37-open-map-network-drive-option.png)

3. Choose a drive letter, for example G:
4. Enter the network path: \DC01\Cloud Files.
5. Check "Reconnect at sign-in", then click Finish.

![38 – configure cloud files network drive mapping](images/38-configure-cloud-files-network-drive-mapping.png)

6. Confirm the mapped drive now appears under This PC, and can be opened like any local drive.

![39 – verify mapped network drive](images/39-verify-mapped-network-drive.png)

## Conclusion

You have built a working example of layered NTFS permissions: two security groups, two users, a shared parent folder with Full Control for senior staff, and two subfolders carrying different permission levels for junior staff, with Modify in Code, Read-only in Infra, and inheritance disabled on Infra so its permissions remain explicit and independent.

The two test runs confirmed the setup actually behaves the way it was configured, not just the way it was intended. Test Run 1, using Amara Nwoye's CLOUD SNR account, confirmed that a member of the senior group could authenticate to the share, browse the full Cloud Files structure, and freely create and manage content anywhere inside it, proving Full Control was working correctly. Test Run 2, using Chizaram Kelvin's CLOUD ENG account, confirmed the split access design worked as designed. The same user account could create and edit files inside Code, proving Modify, but could only view files inside Infra and could not delete them, proving Read-only with inheritance disabled so the restriction held. The same group therefore had two completely different permission levels depending on which subfolder was being accessed.

The network drive mapping in the final task made the whole structure easy to reach from the client PC and confirmed the share was correctly published and accessible to authorized users. The core lesson worth carrying forward is that NTFS permissions are set per object, not once for an entire folder tree. The same group or user can have very different access just one folder level down, and that is a deliberate and useful tool for controlling exactly what people can touch. Combining this with inheritance control, disabling inheritance and converting inherited permissions into explicit ones where a tighter restriction is needed, gives administrators precise and predictable control over access at every level of the structure.
