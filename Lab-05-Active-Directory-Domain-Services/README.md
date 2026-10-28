# Active Directory Domain Services (AD DS)

## Lab Exercise

This lab builds on Part 3 of this series, where we installed the Active Directory Domain Services (AD DS) role and promoted our Windows Server to a Domain Controller (`divineuzor.com`). All tasks in this guide will be performed on that Domain Controller.

By the end of this lab, we will:

- Create two Organizational Units (OUs) representing the HR and IT departments.
- Create two sub-Organizational Units under each department OU.
- Create a user account in the Cloud Engineer sub-OU using Active Directory Users and Computers (ADUC).
- Create a user account in the Software Engineer sub-OU using the Active Directory Administrative Center (ADAC).
- Create a security group, add both users as members, and verify the group membership.

## Step 1: Create the Organizational units (HR & IT)

1. Log in to the domain controller as administrator.
2. Open Server Manager (It usually opens automatically on login).
3. Click Tools in the top-right corner, then select Active Directory Users and Computers.

   ![Open Active Directory Users and Computers](images/01-open-aduc.png)

4. In the Active Directory Users and Computers (ADUC) console, expand the domain node in the left pane (`divineuzor.com`) so you can see it selected.
5. Right-click the domain root (`divineuzor.com`), then select New, then Organizational Unit.

   ![Select New, then Organizational Unit](images/02-select-new-organizational-unit.png)

6. In the New Object - Organizational Unit window, type HR as the name. Leave "Protect container from accidental deletion" checked, this is best practice in real environments. Click OK.

   ![Create the HR organizational unit](images/03-create-hr-ou.png)

7. Repeat the same process to create the second OU: type IT as the name and click OK.

   ![Create the IT organizational unit](images/04-create-it-ou.png)

## Step 2: Create Sub-Departments Inside Each OU

1. Right-click the IT OU, Select New, then Organizational Unit, name it Cloud Engineer and click OK.
2. Right-click the IT OU, Select New, then Organizational Unit, name it Software Engineer and click OK.

   ![Verify the IT sub-departments](images/05-verify-it-sub-departments.png)

3. Right-click the HR OU, Select New, then Organizational Unit, name it Recruitment and click OK.
4. Right-click the HR OU, Select New, then Organizational Unit, name it Payroll and click OK.

   ![Verify the HR sub-departments](images/06-verify-hr-sub-departments.png)

## Step 3: Create a User via Active Directory Users and Computers (ADUC)

This is the "normal" or traditional method of creating a user in AD, and it is still the most commonly used approach day to day.

1. In ADUC, right-click the Cloud Engineer OU, select New, then User.

   ![Select New, then User in ADUC](images/07-select-new-user-aduc.png)

2. In the New Object - User window, fill in First name and Last name (these auto-populate the Full name field), and enter a User logon name, for example `c.engineer1`. Click Next.

   ![Enter user details in ADUC](images/08-enter-aduc-user-details.png)

3. Enter and confirm a password that meets the domain's complexity requirements. For lab purposes you can leave "User must change password at next logon" checked, this reflects real-world best practice for new accounts. Click Next.

   ![Set the user password](images/09-set-aduc-user-password.png)

4. Review the summary screen and click Finish to create the account.

   ![Confirm user creation in ADUC](images/10-confirm-aduc-user-creation.png)

   ![Verify the user in ADUC](images/11-verify-aduc-user.png)

## Step 4: Create a User via Active Directory Administrative Center

Active Directory Administrative Center (ADAC) is the newer, task-based console Microsoft introduced as a more modern alternative to ADUC. It is built on PowerShell under the hood, which means every action you take in ADAC can also show you the equivalent PowerShell command, useful for anyone moving toward automation.

1. Open Server Manager, click Tools, and select Active Directory Administrative Center. Alternatively, run `dsac.exe` from the Run dialog.

   ![Open Active Directory Administrative Center](images/12-open-adac.png)

2. In the left pane, navigate to `divineuzor.com (local) > IT > Software Engineer`.
3. In the Tasks pane on the right, click New, then User (or right-click the Software Engineer OU and choose the same option).

   ![Select the Software Engineer OU in ADAC](images/13-select-software-engineer-ou.png)

4. Fill in the First name, Last name, and User UPN logon name (for example `s.engineer1`), set and confirm a password, and click OK to create the account.

   ![Create the user in ADAC](images/14-create-adac-user.png)

5. Confirm the account now appears inside the Software Engineer OU.

   ![Verify the user in ADAC](images/15-verify-adac-user.png)

## Step 5: Create a Group and confirm membership

Groups are how real admins assign permissions efficiently. Instead of granting access to a shared folder one user at a time, you grant access to a group, then simply add or remove users from that group as staff join or leave. Here we create a group for the IT department and add both new user accounts to it.

1. In ADUC, right-click the IT OU, select New, then Group.

   ![Create a group in ADUC](images/16-create-it-staff-group.png)

2. Name the group IT Staff. Set Group scope to Global and Group type to Security (the standard choice for granting resource permissions). Click OK.

   ![Configure the IT Staff group](images/17-configure-it-staff-group.png)

3. Double-click the newly created IT Staff group to open its Properties window, then click the Members tab.

   ![Open the IT Staff Members tab](images/18-open-it-staff-members-tab.png)

4. Click Add. In the "Select Users, Contacts, Computers..." window, type the logon names of both new accounts (the Cloud Engineer user and the Software Engineer user) separated by a semicolon, then click Check Names to verify them, and click Apply. Finally, click OK to close the group properties.

   ![Add users to the IT Staff group](images/19-add-users-to-it-staff-group.png)

5. Reopen the IT Staff group and view the Members tab again to confirm both users are now listed.

   ![Verify IT Staff group membership](images/20-verify-it-staff-membership.png)

## Summary

In this lab, we moved from theory to hands-on administration within our Active Directory environment. We created a departmental Organizational Unit (OU) structure, provisioned user accounts using both Active Directory Users and Computers (ADUC) and the Active Directory Administrative Center (ADAC), and organized those accounts into a security group to demonstrate how identities and access are managed in an enterprise environment.

These foundational tasks reflect how Active Directory is used in real organizations.

Organizational Units provide structure, user accounts represent identities, and security groups simplify access management. Together, they form the foundation for more advanced Active Directory administration, including Group Policy, delegation of control, and resource permissions.
