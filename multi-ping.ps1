<#
.SYNOPSIS
PowerShell Ping Test Script with Parameters

.DESCRIPTION
This PowerShell script pings a list of specified targets (IP addresses, domains) for a given number of times. 
The results of each ping are then recorded in a CSV file.

.PARAMETER targets
A list of the targets to be pinged. Default value is @("example.com", "example.org").

.PARAMETER folderPath
The directory where the results will be saved. Default value is "C:\temp".

.PARAMETER timeoutBetweenPingsInSeconds
The amount of time (in seconds) the script will wait between successive pings. Default value is 1.

.PARAMETER numberOfPings
The number of pings to be sent to each target. Default value is 10.

.PARAMETER pingTimeoutInSeconds
The amount of time (in seconds) the script will wait for a response from each ping. Default value is 1.

.EXAMPLE
.\script_name.ps1 -targets "domain1.com", "domain2.com" -folderPath "D:\MyFolder" -timeoutBetweenPingsInSeconds 2 -numberOfPings 5 -pingTimeoutInSeconds 2

Replace script_name.ps1 with the actual name of the script, and replace the parameter values with your desired settings. If you don't specify a parameter, the script will use its default value.

.NOTES
The script will save the results of the pings in a CSV file located at the directory specified by folderPath. 
The CSV file will be named using the current date and time (format: "yyyy-MM-dd_HHmm") followed by _ping_test.csv.
Each row in the CSV file represents the result of a single ping to a single target. The columns of the CSV file are:
- Timestamp: The date and time (format: "yyyy-MM-dd HH:mm:ss") when the ping was conducted.
- Address: The target of the ping.
- StatusCode: The status of the ping (Success or Fail).
- ResponseTime (ms): The time (in milliseconds) it took to receive a response from the ping.
- ErrorMessage: If an error occurred while trying to send the ping, the error message will be recorded here.

Please use this script responsibly. Misuse of the script may lead to violations of network policies or cause network congestion.

.LINK
https://github.com/ram-fabian-heinrich/multi-ping/
#>

param(
    [string[]]$targets = @("8.8.8.8", "1.1.1.1"),
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
