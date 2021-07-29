$InputCsvPath = "C:\Users\ckali\Desktop\Temp.csv"
$OutputCsvPath = "C:\Users\ckali\Desktop\Temp_Out.csv"
$ColumnIndex = 0

# Initialize current reader & skip header row
$currentReader = [System.IO.File]::OpenText($InputCsvPath)
$currentReader.ReadLine() | Out-Null

$currentLineCount = 1

$writer = New-Object System.IO.StreamWriter $OutputCsvPath

while($true)
{
    ($currentLine = $currentReader.ReadLine()) | Out-Null
    $currentLineCount += 1

    # Break infinite loop when no more lines to read in $InputCsvPath
    if ($null -eq $currentLine)
    {
        break
    }

    $current = $currentLine.Split(',')[$ColumnIndex]

    # Close duplicate reader if was open previously
    if ($null -ne $duplicateReader)
    {
        $duplicateReader.Close()
    }

    $duplicateReader = [System.IO.File]::OpenText($InputCsvPath)

    # Have duplicate reader skip lines already passed in current reader
    for ($i = 0; $i -lt $currentLineCount; $i += 1)
    {
        $duplicateReader.ReadLine() | Out-Null
    }

    Write-Host("Checking for duplicates for $($current)")

    while($true)
    {
        ($line = $duplicateReader.ReadLine()) | Out-Null

        if ($null -eq $line)
        {
            break
        }

        $target = $line.Split(',')[$ColumnIndex]

        if ($current -eq $target)
        {
            Write-Host("Duplicate has been located! ($($target))")
            $writer.WriteLine($line)
        }
    }
}

$currentReader.Close()
$duplicateReader.Close()
$writer.Close()
