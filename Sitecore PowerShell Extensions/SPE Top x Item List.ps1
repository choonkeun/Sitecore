
###- Sitecore Powershell Extension -

$topCount = Show-Input "Enter Top x count to select "
#Write-host $topCount

$outputFilePath = Show-Input "Enter result file path with filename"
#Write-host $outputFilePath
if ($outputFilePath -eq $null) {
	$outputFilePath = "C:\Temp\xm1.csv"
}
write-host "Started..."
write-host "Selected record count : " $topCount
write-host "Result file path : " $outputFilePath

$sourcepath = "master:\sitecore\"
$getAllItems = 
	get-childitem -Path $sourcepath -recurse `
		| Sort-Object -Property ItemPath `
		| select-object -First $topCount `

$incre = 0
#$outputFilePath = "D:\Temp\my-csv-file.csv"
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
write-host "export count : " $incre
$Results | Select-Object Name,Id,Language,Templatename,ItemPath | Export-Csv -notypeinformation -Path $outputFilePath
write-host "Finished..."
