# AWS Control Tower Custom Landing Zone Setup

This project provisions a customized AWS Control Tower landing zone using Terraform. It sets up AWS Organizations, creates mandatory accounts, defines OUs, and configures required IAM roles and policies. Additionally, it integrates with a Control Tower manifest to drive the automated setup of centralized logging, audit, and access management across governed regions.

---

## 📦 Components

### 1. **Landing Zone Initialization**
- Uses `aws_controltower_landing_zone` resource.
- Manifest template includes:
  - Governed region: `ap-southeast-1`
  - Centralized logging (`log_archive`)
  - Audit account (`security`)
  - Access management: enabled

### 2. **AWS Organization Accounts**
Creates two mandatory accounts:
- `Log Archive` (log storage and protection)
- `Security` (audit/monitoring)

Each account is placed into the organization root by default.

### 3. **IAM Roles and Policies**
Provisions all required IAM roles for Control Tower setup:
- `AWSControlTowerAdmin`
- `AWSControlTowerCloudTrailRole`
- `AWSControlTowerStackSetRole`
- `AWSControlTowerConfigAggregatorRoleForOrganizations`

Attached with relevant policies including:
- `AWSControlTowerServiceRolePolicy`
- Custom CloudTrail and StackSet policies

### 4. **Modules**
- `modules/ou`: Provisions OUs using a flexible map-based structure.
- `modules/account`: Provisions member accounts and maps them to appropriate OUs.

---

## 🛠️ How to Use

1. **Update Variables:**
   Ensure your `terraform.tfvars` contains valid:
   ```hcl
   organizational_units = {
     "Security-OU" = {
       child_ous = ["Child1", "Child2"]
     }
   }

   accounts = [
     {
       account_name  = "MyAppAccount"
       account_email = "app@example.com"
       ou_name       = "Child1"
     }
   ]













###### Nishant Singh
###### nishant.singh@softwareone.com



