# batch-policy-scripts
sample powershell scripts to create and assign Azure policies from Azure Pipelines

Pre-requisites:
- Each Azure policy is maintained in it's own folder - name of the folder is going to be the name of the Policy definition on Policy Center
- Each policy folder contains:
    - policydef.json: policy definition
    - policydef.params.json: parameters used in the definition (if any) or {}
    - values.<pipeline.stage.name>.json: values to be used for the specified pipeline stage. stage names should match. Eg. values.dev.json

Refer to the sample folder for examples.