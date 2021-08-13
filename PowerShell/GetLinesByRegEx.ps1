# Inputs
#   $InputFilePath - Path to file to be checked.
#   $OutputFilePath - File path to write matched lines.
#   $RegExp - Regular Expression to be used to match against.
$InputFilePath = ""
$OutputFilePath = ""
$RegExp = ""

# Initialize reader
$reader = [System.IO.File]::OpenText($InputFilePath)

while($true)
{
    ($line = $reader.ReadLine()) | Out-Null

    # Break infinite loop when no more lines to read in from $InputFilePath.
    if ($null -eq $line)
    {
        break
    }

    if ($line -imatch $RegExp)
    {
        Write-Host("Line match found!")
        $line | Out-File -FilePath $OutputFilePath -Append
    }
}

$reader.Close()