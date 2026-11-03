# Lab 11: Group Policy Management and Troubleshooting

**Hands-On Practice: Linking, Ordering, Filtering, and Troubleshooting GPOs**

## Lab Overview

This lab provides practical experience configuring and troubleshooting Group Policy in an Active Directory domain. It demonstrates how Group Policy settings are linked, processed, filtered and applied to users and computers, including how inheritance and loopback processing affect the final result.

## Environment

The lab uses an existing Windows Server environment with two domain controllers, DC01 and DC02, and one domain-joined client PC in the `divineuzor.com` domain. DC01 and DC02 share the same Active Directory database. All configuration is performed from DC01, while policy application and results are verified on the client PC.

| Item | Purpose |
|---|---|
| Workstations (new OU) | Holds the client PC's computer account so computer-side GPOs have a dedicated location to target. |
| Tobenna Eze (new user) | Test account used to verify Drive Map preferences and Security Filtering. |
| GPO-Pilot-Users (new security group) | Restricts a GPO to a specific group rather than all authenticated users. |

## Objectives

- Create and link Group Policy Objects at domain and OU levels.
- Demonstrate LSDOU processing order and GPO Link Order.
- Configure interactive logon messages.
- Deploy mapped network drives using Group Policy Preferences.
- Apply Security Filtering and configure GPO delegation permissions.
- Demonstrate Block Inheritance and Enforced.
- Refresh and troubleshoot Group Policy using `gpupdate` and `gpresult`.
- Configure Loopback Processing in Merge and Replace modes.

---

## Task 1: Prepare the Lab Environment

1. On DC01, open Active Directory Users and Computers. Right-click divineuzor.com, select New, then Organizational Unit.

   ![01 Open Active Directory Users and Computers](images/01-Open-Active-Directory-Users-and-Computers.png)

2. Name it Workstations, and leave "Protect container from accidental deletion" checked.

   ![02 Create Workstations Organizational Unit](images/02-Create-Workstations-Organizational-Unit.png)

3. Expand the Computers container, locate the client PC's computer account, right-click it, and select Move. Select the new Workstations OU and click OK.

   ![03 Move client computer account](images/03-Move-Client-Computer-Account-to-Workstations-OU.png)

4. Right-click the IT OU, select New, then User. Enter First name: Tobenna, Last name: Eze, User logon name: Tobenna Eze, then click Next.

5. Set a password, click Next, then Finish.

   ![04 Create Tobenna Eze user account](images/04-Create-Tobenna-Eze-User-Account.png)

6. Right-click the IT OU again, select New, then Group. Name it GPO-Pilot-Users, leave Group scope as Global and Group type as Security, then click OK.

   ![05 Create GPO-Pilot-Users security group](images/05-Create-GPO-Pilot-Users-Security-Group.png)

7. Double-click GPO-Pilot-Users, go to the Members tab, click Add, type Tobenna Eze, click Check Names, then click OK, then OK again.

   ![06 Add Tobenna Eze to GPO-Pilot-Users](images/06-Add-Tobenna-Eze-to-GPO-Pilot-Users.png)

## Task 2: Create a Domain-Linked GPO With a Sign-In Banner

This task uses the interactive logon message, a single-valued Group Policy setting. It's a good first GPO because the result is immediately visible on the sign-in screen, with no need to log in first.

1. On DC01, open Server Manager, click Tools, then Group Policy Management.

2. Right-click divineuzor.com, select "Create a GPO in this domain, and Link it here." Name it Corporate Baseline, then click OK.

![07 Open Group Policy Management](images/07-Open-Group-Policy-Management.png)


3. Right-click Corporate Baseline and select Edit.

4. In the Group Policy Management Editor, navigate to Computer Configuration, then Policies, then Windows Settings, then Security Settings, then Local Policies, then Security Options.

 ![08 Create Corporate Baseline GPO](images/08-Create-Corporate-Baseline-GPO.png)


5. Double-click "Interactive logon: Message title for users attempting to log on." Enable it and enter a title, for example Divine Uzor Corp.

   ![09 Configure interactive logon message title](images/09-Configure-Interactive-Logon-Message-Title.png)

6. Double-click "Interactive logon: Message text for users attempting to log on." Enable it and enter a message, for example Authorized access only. All activity is monitored.

   ![10 Configure interactive logon message text](images/10-Configure-Interactive-Logon-Message-Text.png)

**Both Settings Are Required**

The title and the text are two separate policy settings, and both must be defined, or the banner will not display at all. This is a common first mistake: configuring only one of the two and then assuming Group Policy itself is broken.

![11 Verify Corporate Baseline message settings](images/11-Verify-Corporate-Baseline-Message-Settings.png)

## Task 3: Test the Domain GPO

Computer Configuration settings apply automatically at startup, before anyone signs in, in addition to the regular background refresh. Because of this, a simple restart of the client PC is enough to pick up Corporate Baseline on its own, with no need to sign in first or run any commands.

1. On the client PC, open Command Prompt and run gpupdate /force. (If the client PC is restarted instead of running this command, the same result follows automatically, since Computer Configuration is also applied during startup.)

2. Sign out completely, or restart the client PC.

   ![12 Verify domain-linked GPO on client PC](images/12-Verify-Domain-Linked-GPO-on-Client-PC.png)

This confirms the domain-linked GPO is reaching the client PC. Since Computer Configuration follows the computer account's OU location, this works regardless of which user eventually signs in.

## Task 4: Create an OU-Linked GPO to Demonstrate LSDOU

**What This Proves**

In Group Policy processing, for a single-valued setting, the GPO processed later in the LSDOU order wins. Domain is processed before OU, so a GPO linked to the Workstations OU should override the one linked to the domain, on the same client PC, for the same setting.

1. In Group Policy Management, right-click the Workstations OU, select "Create a GPO in this domain, and Link it here." Name it Workstation Notice, then click OK.

   ![13 Create Workstation Notice GPO](images/13-Create-Workstation-Notice-GPO.png)

2. Edit Workstation Notice and configure the same two Security Options settings as Task 2, but with different text, for example Message title: Workstations Team; Message text: This device is part of the Workstations OU.

   ![14 Configure Workstation Notice settings](images/14-Configure-Workstation-Notice-Settings.png)

3. On the client PC, run gpupdate /force, then sign out.

   ![15 Verify Workstation Notice on client PC](images/15-Verify-Workstation-Notice-on-Client-PC.png)

The OU-linked GPO won, exactly as LSDOU predicts: Organizational Unit is processed after Domain, so its version of this single-valued setting is the one that survives.

## Task 5: Link a Second GPO to the Same OU to Demonstrate Link Order

**What This Proves**

LSDOU only decides between different levels of the hierarchy. When two GPOs are linked to the very same OU, Link Order breaks the tie instead, and Link Order 1 wins.

1. Right-click the Workstations OU again, select "Create a GPO in this domain, and Link it here." Name it Workstation Notice v2, then click OK.

   ![16 Create Workstation Notice v2 GPO](images/16-Create-Workstation-Notice-v2-GPO.png)

2. Edit it and configure the same two settings with yet another message, for example Message title: Workstations Team v2; Message text: Updated notice for this OU.

   ![17 Configure Workstation Notice v2 settings](images/17-Configure-Workstation-Notice-v2-Settings.png)

3. Click the Workstations OU in the console tree and select the Linked Group Policy Objects tab. Note the current Link Order of both GPOs.

4. Select Workstation Notice v2 in the list and use the up-arrow button to move it to Link Order 1.

   ![18 Set Workstation Notice v2 to Link Order 1](images/18-Set-Workstation-Notice-v2-to-Link-Order-1.png)

5. On the client PC, run gpupdate /force, then sign out.

   ![19 Verify Workstation Notice v2 on client PC](images/19-Verify-Workstation-Notice-v2-on-Client-PC.png)

## Task 6: Configure a Group Policy Preference: Map a Network Drive

This task uses a Group Policy Preference (GPP) Drive Map instead of a Policy setting. Unlike a Policy setting, a Group Policy Preference can be changed by the user afterward, and its Action determines exactly how it behaves during a policy refresh.

1. In Group Policy Management, right-click the IT OU, select "Create a GPO in this domain, and Link it here." Name it IT Drive Map, then click OK.

   ![20 Create IT Drive Map GPO](images/20-Create-IT-Drive-Map-GPO.png)

2. Edit IT Drive Map and navigate to User Configuration, then Preferences, then Windows Settings, then Drive Maps.

 ![21 Configure IT Projects G drive mapping](images/21-Configure-IT-Projects-G-Drive-Mapping.png)


3. Right-click Drive Maps, select New, then Mapped Drive.

4. Set Action to Update. Set Location to \\DIVINE-DCO1\IT Projects (the shared folder from the earlier NTFS lab in this series). Choose a drive letter, for example G:, then click OK.

  
![22 Remove Authenticated Users from Security Filtering](images/22-Remove-Authenticated-Users-from-Security-Filtering.png)


**Why Update, Not Replace**

Update is the safer default because it modifies only the settings explicitly defined in the Group Policy Preference item, rather than deleting and recreating the item during every refresh. For a routine drive mapping like this one, Update is the appropriate choice.

## Task 7: Apply Security Filtering to the Drive Map GPO

**What This Proves**

By default, a new GPO's Security Filtering targets Authenticated Users, meaning everyone. This task narrows IT Drive Map down to a single group, so only its members get the mapped drive.

1. In Group Policy Management, select IT Drive Map and click the Scope tab.

2. Under Security Filtering, select Authenticated Users and click Remove.

   ![23 Add GPO-Pilot-Users to Security Filtering](images/23-Add-GPO-Pilot-Users-to-Security-Filtering.png)

3. Click Add, type GPO-Pilot-Users, click Check Names, then click OK.

   ![24 Verify initial drive map filtering result](images/24-Verify-Initial-Drive-Map-Filtering-Result.png)

4. On the client PC, run gpupdate /force, then sign out and sign back in as Tobenna Eze, who is a member of GPO-Pilot-Users. Open File Explorer and check This PC.

   ![25 Grant Authenticated Users Read permission](images/25-Grant-Authenticated-Users-Read-Permission.png)


**Why This Happens**

Removing Authenticated Users from Security Filtering doesn't just affect who the setting applies to, it also strips Read access from every computer account, since computer accounts were part of Authenticated Users too. A GPO still has to be retrieved from SYSVOL by the computer before it can be delivered to any user signed into it, including a User Configuration preference like this drive map. GPO-Pilot-Users only contains Tobenna's user account, not the client PC's computer account, so once Authenticated Users was removed, the computer itself lost the ability to even read this GPO. The result is that the GPO fails for everyone, including the one group it was supposed to reach.

5. Back on the Scope tab, confirm GPO-Pilot-Users is still the only entry under Security Filtering. Do not add Authenticated Users back here, that would restore Apply Group Policy to everyone and undo the restriction this task is meant to demonstrate.

6. Click the Delegation tab instead, then click Add.

7. Type Authenticated Users, click OK, and when prompted for a permission level, select Read only, not Edit settings or anything broader.

   
   ![26 Verify GPO delegation permissions](images/26-Verify-GPO-Delegation-Permissions.png)

**The Distinction That Matters**

Authenticated Users now has Read only, which lets any computer account retrieve and process this GPO. GPO-Pilot-Users has Read and Apply Group Policy together, shown as "Read (from Security Filtering)," which is what actually delivers the setting. Read alone never applies a GPO to anyone; Apply Group Policy is what does that. Separating the two is what lets the computer read the GPO while only GPO-Pilot-Users members receive it.

 ![27 Verify G drive mapping for Tobenna Eze](images/27-Verify-G-Drive-Mapping-for-Tobenna-Eze.png)


8. On the client PC, run gpupdate /force, then sign out and sign back in as Tobenna Eze. Open File Explorer and check This PC.

![28 Verify no G drive for non-member](images/28-Verify-No-G-Drive-for-Non-Member.png)

9. Sign out and sign in as a different domain user who is not a member of GPO-Pilot-Users. Confirm the drive does not appear.

   ![29 Enable Block Inheritance on Workstations OU](images/29-Enable-Block-Inheritance-on-Workstations-OU.png)

Same GPO, same OU, two different outcomes for the two test users, purely because of group membership, with the computer itself still able to read the GPO regardless of who's signed in. This is Security Filtering correctly deciding eligibility, with the computer's own Read access kept intact underneath it.

## Task 8: Block Inheritance and Enforced

**What This Proves**

Block Inheritance stops ordinary inherited GPOs from flowing into an OU. Enforced overrides that block. This task demonstrates both, using the Corporate Baseline GPO from Task 2.

1. In Group Policy Management, right-click the Workstations OU and select Block Inheritance.

   ![30 Verify Workstations OU after Block Inheritance](images/30-Verify-Workstations-OU-After-Block-Inheritance.png)

2. On the client PC, run gpupdate /force, then sign out.

 ![31 Enforce Corporate Baseline GPO](images/31-Enforce-Corporate-Baseline-GPO.png)

3. Back in Group Policy Management, click on the domain, select the Linked Group Policy Objects tab, right-click Corporate Baseline, and select Enforced.

  ![32 Verify Enforced Corporate Baseline GPO](images/32-Verify-Enforced-Corporate-Baseline-GPO.png)

4. On the client PC, run gpupdate /force again, then sign out.

   

   ![33 Verify Corporate Baseline after enforcement](images/33-Verify-Corporate-Baseline-After-Enforcement.png)

This demonstrates the distinction: Block Inheritance is a property of the OU, and it cannot stop a link that has been marked Enforced, because Enforced is a property of the link itself, one level more specific than the container it's fighting against.

## Task 9: Refresh and Troubleshoot

1. On the client PC, open Command Prompt.

2. Run gpupdate /force and observe the output.

   ![34 Run GPUpdate Force on client PC](images/34-Run-GPUpdate-Force-on-Client-PC.png)

3. Run gpresult /r and review the summary of applied GPOs.

   ![35 Review GPResult R output](images/35-Review-GPResult-R-Output.png)

4. Run gpresult /h "%userprofile%\Desktop\GPReport.html", to save the resulting file directly to Tobenna’s desktop, then click to view in a browser.

   ![36 Generate and review HTML GPReport](images/36-Generate-and-Review-HTML-GPReport.png)

The HTML report is worth comparing against what was configured across this lab: Corporate Baseline, Workstation Notice, Workstation Notice v2, and IT Drive Map should all appear as applied GPOs for the objects they were scoped to.

## Task 10: Demonstrate Loopback Processing

**What This Proves**

Loopback processing changes whose User Configuration settings apply, based on the computer being used rather than the signed-in user's own OU. This task reuses Tobenna Eze, who already has a Drive Map (G:) from the IT Drive Map GPO in Task 6, and the Workstations OU, which already holds the client PC's computer account. A second Drive Map (H:), delivered only through loopback, gives us something concrete to Merge or Replace against.

1. In Group Policy Management, right-click the Workstations OU, select "Create a GPO in this domain, and Link it here." Name it Workstation Loopback, then click OK.

   ![37 Create Workstation Loopback GPO](images/37-Create-Workstation-Loopback-GPO.png)

2. Edit Workstation Loopback and navigate to Computer Configuration, then Policies, then Administrative Templates, then System, then Group Policy.

   ![38 Navigate to Loopback Processing policy](images/38-Navigate-to-Loopback-Processing-Policy.png)

3. Double-click "Configure user Group Policy loopback processing mode." Set it to Enabled, and set Mode to Merge. Click OK.

   ![39 Enable Loopback Processing Merge mode](images/39-Enable-Loopback-Processing-Merge-Mode.png)

4. In the same GPO, navigate to User Configuration, then Preferences, then Windows Settings, then Drive Maps. Right-click, select New, then Mapped Drive.

   ![40 Configure Loopback H drive preference](images/40-Configure-Loopback-H-Drive-Preference.png)

5. Set Action to Update, Location to \\DIVINE-DCO1\IT Projects, and Drive Letter to H:. Click OK.

   ![41 Set H drive mapping location and letter](images/41-Set-H-Drive-Mapping-Location-and-Letter.png)

6. The Drive Maps list is now showing the new H: mapping.

   ![42 Verify H drive mapping in GPO](images/42-Verify-H-Drive-Mapping-in-GPO.png)

7. On the client PC, run gpupdate /force, then sign out and sign back in as Tobenna Eze.

8. Open File Explorer and check This PC.

   ![43 Verify G and H drives in Merge mode](images/43-Verify-G-and-H-Drives-in-Merge-Mode.png)

9. Back in Group Policy Management, edit Workstation Loopback again. Open "Configure user Group Policy loopback processing mode" and change Mode from Merge to Replace. Click OK.

   ![44 Change Loopback Processing to Replace](images/44-Change-Loopback-Processing-to-Replace.png)

10. On the client PC, run gpupdate /force, then sign out and sign back in as Tobenna Eze

11. Check This PC again.

   ![45 Verify H drive only in Replace mode](images/45-Verify-H-Drive-Only-in-Replace-Mode.png)

Same user, same computer, same two GPOs, two different outcomes, purely because of which loopback mode was selected. Merge layered the Workstations OU's setting on top of Tobenna's own; Replace ignored her own setting completely. This is the last mechanism from the theory documentation, and the only one that required a second variable, mode, rather than a second object, to demonstrate.

## Conclusion

This lab took every core mechanism from the theory documentation and made it visible on screen: a domain-linked GPO overridden by an OU-linked one (LSDOU), two GPOs at the same OU resolved by Link Order, a Preference deployed with the Update action rather than a Policy setting, Security Filtering narrowing a GPO to one group, Block Inheritance being overridden by Enforced, and Loopback Processing switching between Merge and Replace.

Ten tasks, five GPOs, and two Preference items were enough to demonstrate all of it with real, reproducible results rather than diagrams.

The Workstations OU, the test GPOs, Tobenna Eze's account, and the GPO-Pilot-Users group can all be left in place for future labs in this series, or removed if this environment is reset.
