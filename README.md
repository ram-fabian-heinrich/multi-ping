# PowerShell Ping Test Script with Parameters

This PowerShell script pings a list of specified targets (IP addresses, domains) for a given number of times. The results of each ping are then recorded in a CSV file.

## Prerequisites

The script is written in PowerShell, so you must have PowerShell installed on your machine.

## Usage

The script has the following optional parameters:

- `targets`: A list of the targets to be pinged. Default value is `@("example.com", "example.org")`.
- `folderPath`: The directory where the results will be saved. Default value is `"C:\\temp"`.
- `timeoutBetweenPingsInSeconds`: The amount of time (in seconds) the script will wait between successive pings. Default value is `1`.
- `numberOfPings`: The number of pings to be sent to each target. Default value is `10`.
- `pingTimeoutInSeconds`: The amount of time (in seconds) the script will wait for a response from each ping. Default value is `1`.

You can run the script with custom parameters in your terminal as follows:

\\\```powershell
.\\script_name.ps1 -targets "domain1.com", "domain2.com" -folderPath "D:\\MyFolder" -timeoutBetweenPingsInSeconds 2 -numberOfPings 5 -pingTimeoutInSeconds 2
\\\```

Replace `script_name.ps1` with the actual name of the script, and replace the parameter values with your desired settings. If you don't specify a parameter, the script will use its default value.

## Output

The script will save the results of the pings in a CSV file located at the directory specified by `folderPath`. The CSV file will be named using the current date and time (format: `"yyyy-MM-dd_HHmm"`) followed by `_ping_test.csv`. For example, `2023-06-21_1234_ping_test.csv`.

Each row in the CSV file represents the result of a single ping to a single target. The columns of the CSV file are:

- `Timestamp`: The date and time (format: `"yyyy-MM-dd HH:mm:ss"`) when the ping was conducted.
- `Address`: The target of the ping.
- `StatusCode`: The status of the ping (`Success` or `Fail`).
- `ResponseTime (ms)`: The time (in milliseconds) it took to receive a response from the ping.
- `ErrorMessage`: If an error occurred while trying to send the ping, the error message will be recorded here.

## Disclaimer

Please use this script responsibly. Misuse of the script may lead to violations of network policies or cause network congestion.
