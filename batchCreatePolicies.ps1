$policyDefRootFolder = "$(System.DefaultWorkingDirectory)/policies"
$subscriptionName = "$(subscriptionName)"

class PolicyDef {
    [string]$PolicyName
    [string]$PolicyRulePath
    [string]$PolicyParamPath
    [string]$ResourceId
}

function Select-Policies {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)]
        [System.IO.DirectoryInfo[]]$PolicyFolders
    )

    Write-Verbose "Processing policies"
    $policyList = @()
    foreach ($policyDefinition in $PolicyFolders) {
        $policy = New-Object -TypeName PolicyDef
        $policy.PolicyName = $policyDefinition.Name
        $policy.PolicyRulePath = $($policyDefinition.FullName + "\policydef.json")
        $policy.PolicyParamPath = $($policyDefinition.FullName + "\policydef.params.json")
        $policyList += $policy
    }

    return $policyList
}

function Add-Policies {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)]
        [PolicyDef[]]$Policies,
        [String]$subscriptionId
    )

    Write-Verbose "Creating policy definitions"
    $policyDefList = @()
    foreach ($policy in $Policies) {
        $policyDef = New-AzureRmPolicyDefinition -Name $policy.PolicyName -Policy $policy.PolicyRulePath -Parameter $policy.PolicyParamPath -SubscriptionId $subscriptionId -Metadata '{"category":"Pipeline"}'
        $policyDefList += $policyDef
    }
    return $policyDefList
}

$subscriptionId = (Get-AzureRmSubscription -SubscriptionName $subscriptionName).Id
Write-Verbose $policyDefRootFolder
Write-Verbose $subscriptionId

#get list of policy folders
$policies = Select-Policies -PolicyFolders (Get-ChildItem -Path $policyDefRootFolder -Directory)
$policyDefinitions = Add-Policies -Policies $policies -subscriptionId $subscriptionId
$policyDefsJson = ($policyDefinitions | ConvertTo-Json -Depth 10 -Compress)

Write-Host "##vso[task.setvariable variable=PolicyDefs]$policyDefsJson"