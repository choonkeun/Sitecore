
$ItemPath = "master:/sitecore/content/Home/"
$items = Get-ChildItem -Path $ItemPath -Recurse -Language @("ar-EG","en") -Version *
$search = "fieldvaluesearch"
$hashTable = [System.Collections.ArrayList]@()
$count = 0
if($items -ne $null)
{
    $items | ForEach-Object { 
        $thisItem = $_
        foreach($field in $_.Fields) {
            if($field.Value.Contains($search)) {
                $count++
                Write-Host $count "|" $field.Name "|" $field.Value "|" $_.Paths.Path
                $info = [PSCustomObject]@{
                    "Name"          =$_.DisplayName  
                    "Languages"     =$_.Language 
                    "Version"       =$_.Version  
                    "Owner"         =$_."__Owner"  
                    "Updated"       =$_."__Updated"  
                    "Updatedby"     =$_."__Updated by"  
                    "TemplateName"  =$_.TemplateName  
                    "FieldType"     =$field.Type  
                    "FieldValue"    =$field.Value  
                    "Path"          =$_.Paths.Path
                }
                [void]$hashTable.Add($info)
            }
        }
    }
}
#$hashTable | Format-Table -AutoSize
$hashTable | Show-ListView -property `
    @{ Name="Name";         Expression={$_.Name} }, 
    @{ Name="Languages";    Expression={$_.Languages} },
    @{ Name="Version";      Expression={$_.Version} }, 
    @{ Name="Owner";        Expression={$_.Owner} }, 
    @{ Name="Updated";      Expression={$_.Updated} }, 
    @{ Name="Updated by";   Expression={$_.Updatedby} }, 
    @{ Name="TemplateName"; Expression={$_.TemplateName} }, 
    @{ Name="FieldType";    Expression={$_.FieldType} }, 
    @{ Name="FieldValue";   Expression={$_.FieldValue} }, 
    @{ Name="Path";         Expression={$_.Path} }
