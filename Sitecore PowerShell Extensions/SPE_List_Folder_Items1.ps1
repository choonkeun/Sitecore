#---
#--- Windows Powershell - Sitecore Powershell Remoting
#---

Import-Module -Name SPE
$sitecoreUrl = "https://xm1cm.dev.local"
$session = New-ScriptSession -Username $name -password b -ConnectionUri $sitecoreUrl

Invoke-RemoteScript -Session $session -ScriptBlock { 
	$sourcepath = "master:\sitecore\"
	$getAllItems = 
		get-childitem -Path $sourcepath -recurse `
			| Sort-Object -Property ItemPath `
			| select-object -First 999999 `

	$outputFilePath = "D:\Temp\my-csv-file.csv"
	$results = @();

	$getAllItems | ForEach-Object {

	  $properties = @{
			Name = $_.Name
			Id = $_.Id 
			Language = $_.Language 
			Templatename = $_.Templatename 
			ItemPath = $_.ItemPath
	  }
	  $results += New-Object psobject -Property $properties
	}

	$Results | Select-Object Name,Id,Language,Templatename,ItemPath | Export-Csv -notypeinformation -Path $outputFilePath
}
write-host "Finished..."
Stop-ScriptSession -Session $session

