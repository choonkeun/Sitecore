#---
#--- Windows Powershell - Sitecore Powershell Remoting
#---

Import-Module -Name SPE
$sitecoreUrl = "https://xm1.cm.dev.local/"
$sharedSecret = "FC6699B1752D75E60C96D8139B2518412376804FC7CDD58595BC47DFBF47199A"
$name = "sitecore\admin"
$session = New-ScriptSession -Username $name -password b -ConnectionUri $sitecoreUrl

write-host "Started..."
Invoke-RemoteScript -Session $session -ScriptBlock { 
	$source1 = "master:/sitecore/content"
	$source2 = "master:/sitecore/Media Library"
	$source3 = "master:/sitecore/templates" 
	$source4 = "master:/sitecore/layout" 
	$getAllItems = 
		$source1, $source2, $source3, $source4 | get-childitem -recurse `
			| Sort-Object -Property ItemPath `
			| select-object -First 999999 `

    $incre = 0
	$outputFilePath = "C:\Temp\my-csv-file.csv"
	$results = @();

	$getAllItems | ForEach-Object {

        $incre++
        $properties = @{
            Name = $_.Name
            Id = $_.Id 
            Language = $_.Language 
            Templatename = $_.Templatename 
            ItemPath = $_.ItemPath
        }
        $results += New-Object psobject -Property $properties
	}
    
    "export count :{0}" -f $incre
	$Results | Select-Object Name,Id,Language,Templatename,ItemPath | Export-Csv -notypeinformation -Path $outputFilePath
}

write-host "Finished..."
Stop-ScriptSession -Session $session

