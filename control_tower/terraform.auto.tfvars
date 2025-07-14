organizational_units = {
    "Network-OU" = {
    }
    "Shared Service-OU" = {
    }
    "Workload-OU" = {
    }
}


accounts = [
    {
        account_name   = "Network Account"
        account_email  = "aws2.na@the-afc.com"
        ou_name        = "Network-OU"
    },
    {
        account_name   = "Shared Services Account"
        account_email  = "aws2.ssa@the-afc.com"
        ou_name        = "Shared Service-OU"
    },
    {
        account_name   = "Prod Account"
        account_email  = "aws2.prod@the-afc.com"
        ou_name        = "Workload-OU"
    },
    {
        account_name   = "UAT Account"
        account_email  = "aws2.uat@the-afc.com"
        ou_name        = "Workload-OU"
    }
]