Param( 
    [Parameter(Mandatory = $True, Position = 1)]
    [string]$filesToCleanPath,
    [Parameter(Mandatory = $True, Position = 2)]
    [string]$logFilePath
)

#region Functions
Function WriteDebug {
    param(
        [Parameter(Mandatory = $True, Position = 1)]
        [object]$message,
        [Parameter(Mandatory = $False, Position = 2)]
        [System.ConsoleColor]$color = [System.ConsoleColor]::White
    )

    Write-Host $message -ForegroundColor $color
    $message.ToString() | Add-Content -Path $logFilePath -Encoding "utf8" 
}
#endregion


#region Config Variables
$separator = "----------------------------------------"
$filesToCleanPath = [System.IO.Path]::GetFullPath($filesToCleanPath) #resolve the full absolute file path from the relative path using System.IO.Path from .net framework
$logFilePath = [System.IO.Path]::GetFullPath($logFilePath)

WriteDebug "------------Config Variables------------" Blue
WriteDebug "Files To Clean Path: $filesToCleanPath" Blue
WriteDebug "Log File Path: $logFilePath" Blue;
WriteDebug "----------------------------------------" Blue
#endregion

"Log File Initialized..." | out-file -FilePath $logFilePath

$filesToCheckForRename = Get-ChildItem -Path $filesToCleanPath *.* -Recurse | Select-Object -ExpandProperty FullName;
$joinedNames = $filesToCheckForRename -Join "`r`n";

WriteDebug "Files to check for rename..."
WriteDebug $joinedNames
WriteDebug $separator

$filesToRename = New-Object System.Collections.Generic.List[string]



foreach ($path in $filesToCheckForRename) {
    $fileName = [System.IO.Path]::GetFileName($path);    
    if ($fileName.IndexOf(' ') -gt -1 -xor $fileName.IndexOf('(') -gt -1 -xor $fileName.IndexOf(')') -gt -1) {
        $filesToRename.Add($path);
    }
}

if ($filesToRename.Count -eq 0) {
    WriteDebug "There are no files with illegal characters to clean up!" Green
} else {
    foreach($path in $filesToRename) {
        $fileName = [System.IO.Path]::GetFileName($path);
        $newFileName = $fileName.Replace(" ", "").Replace("(", "").Replace(")", "")
        WriteDebug "Renaming: $path [To->] $newFileName"        
        Rename-Item -Path $path -NewName $newFileName        
    }
}

WriteDebug $separator
WriteDebug "Done cleaning up for CMS prep" Green









