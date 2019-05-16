$policyObjs = ConvertFrom-Json -InputObject $env:POLICYDEFS
$policyAssignmentRG = "$(resourceGroupName)$(Release.EnvironmentName)"
$policyDefRootFolder = "$(System.DefaultWorkingDirectory)/policies"

foreach ($policyDefFolder in (Get-ChildItem -Path $policyDefRootFolder -Directory)) {

    Write-Host Processing folder: $policyDefFolder.Name
    $selected = $policyObjs | Where-Object { $_.Name -eq $policyDefFolder.Name }
    Write-Host Creating assignment for: $selectedObj

    New-AzureRmPolicyAssignment -Name $policyDefFolder.Name -PolicyDefinition $selected -Scope ((Get-AzureRmResourceGroup -Name $policyAssignmentRG).ResourceId) -PolicyParameter  "$($policyDefFolder.FullName)\values.$(Release.EnvironmentName).json"

}