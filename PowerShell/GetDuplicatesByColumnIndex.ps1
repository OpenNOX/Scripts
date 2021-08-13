# Inputs
#     $InputCsvPath - File path to CSV file to be checked.
#     $OutputPath - File path to results log file.
#     $ColumnIndex - 0-based index of column to be checked.
$InputCsvPath = ""
$OutputPath = ""
$ColumnIndex = 0

# Initialize reader & skip header row
$reader = [System.IO.File]::OpenText($InputCsvPath)
$reader.ReadLine() | Out-Null

$values = [System.Collections.ArrayList]@()
$duplicateValues = @{}

while($true)
{
    ($line = $reader.ReadLine()) | Out-Null

    # Break infinite loop when no more lines to read in from $InputCsvPath.
    if ($null -eq $line)
    {
        break
    }

    $value = $line.Split(',')[$ColumnIndex]

    if ($values.Contains($value))
    {
        if ($duplicateValues.Contains($value) -eq $false)
        {
            $duplicateValues.Add($value) | Out-Null

            Write-Host("New Duplicate Found! ($($value))")
            $line | Out-File -FilePath $OutputPath -Append
        }
    }
    else
    {
        $values.Add($value) | Out-Null
    }
}

$reader.Close()
