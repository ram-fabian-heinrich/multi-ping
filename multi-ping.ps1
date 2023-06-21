param(
    [string[]]$targets = @("example.com", "example.org"),
    [string]$folderPath = "C:\temp",
    [int]$timeoutBetweenPingsInSeconds = 1,
    [int]$numberOfPings = 10,
    [int]$pingTimeoutInSeconds = 1
)

$dateTimePrefix = Get-Date -Format "yyyy-MM-dd_HHmm"
$outfile = Join-Path -Path $folderPath -ChildPath "${dateTimePrefix}_ping_test.csv"

# Create folder if it does not exists
if (-not (Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath
}

if (-not (Test-Path $outfile)) {
    New-Item -ItemType File -Path $outfile
    "Timestamp;Address;StatusCode;ResponseTime (ms);ErrorMessage" | Out-File -Encoding utf8 -FilePath $outfile
}

Write-Output "Starting to send $($numberOfPings) pings with a timeout of $($timeoutBetweenPingsInSeconds) seconds to following target(s): $($targets)"

for ($i = 0; $i -lt $numberOfPings; $i++) {
    foreach ($target in $targets) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        try {
            if ($PSVersionTable.PSVersion.Major -ge 6) {
                $pingResult = Test-Connection -TimeoutSeconds $pingTimeoutInSeconds -ComputerName $target -Count 1 -ErrorAction Stop | Select-Object Address, StatusCode, ResponseTime
            } else {
                $pingResult = Test-Connection -ComputerName $target -Count 1 -ErrorAction Stop | Select-Object Address, StatusCode, ResponseTime
            }
            $csvLine = "{0};{1};{2};{3};;" -f $timestamp, $pingResult.Address, $pingResult.StatusCode, $pingResult.ResponseTime
            $csvLine | Out-File -Encoding utf8 -Append -FilePath $outfile
        } catch {
            $errorOutput = $_.Exception.Message
            $csvLine = "{0};{1};EXCEPTION;;{2}" -f $timestamp, $target, $errorOutput
            $csvLine | Out-File -Encoding utf8 -Append -FilePath $outfile
        }
    }
    Start-Sleep -Seconds $timeoutBetweenPingsInSeconds
}

Write-Output "Result saved: $($outfile)"
