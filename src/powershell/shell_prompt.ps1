param (
    [string]$bashexepath,
    [string]$installpart
)

<# Experimental shell prompt for Kali in Batch
    * REQUIRES PowerShell 7+
    * Speed is quite a lot better than the original shell prompt that was entirely written in Batch.
#>

$colorGreen = 'Green'
$colorBlue = 'Blue'
$colorRed = 'Red'
$colorReset = 'White'

chcp 65001 >$null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Convert-ToBashPath {
    param ([string]$path)
    $bashPath = $path.Replace('\', '/')
    # Replace drive letters with drive letters in Bash format
    if ($bashPath -match '^([A-Za-z]):/(.*)') {
        $drive = $matches[1].ToLower()
        $rest  = $matches[2]
        return "/$drive/$rest"
    }
    # Give the bash path back
    return $bashPath
}

function Convert-ToKaliPath {
    param ([string]$path)
    # Replace backslashes with slashes
    $kaliPath = $path.Replace('\', '/')
    # If it starts with DriveLetter + colon + slash, remove drive letter and colon, add leading slash
    if ($kaliPath -match '^([A-Za-z]):/(.*)') {
        $rest = $matches[2]
        return "/$rest"
    }
    # 
    return $kaliPath
}


function Get-Command {
    while ($true) {
        $kaliPath = Convert-ToKaliPath -path (Get-Location).Path
        Write-Host '╔══(' -NoNewline -ForegroundColor $colorGreen
        Write-Host "$env:USERNAME@$env:COMPUTERNAME" -NoNewline -ForegroundColor $colorBlue
        Write-Host ')-[' -NoNewline -ForegroundColor $colorGreen
        Write-Host $kaliPath -NoNewline -ForegroundColor $colorReset
        Write-Host ']' -ForegroundColor $colorGreen
        Write-Host '╚══' -NoNewline -ForegroundColor $colorGreen
        Write-Host '$ ' -ForegroundColor $colorBlue -NoNewline

        $inputLine = Read-Host

        # Parse the input line into command and arguments
        $tokens = $inputLine -split '\s+'
        $command = if ($tokens.Count -gt 0) { $tokens[0] } else { '' }
        $args = if ($tokens.Count -gt 1) { $tokens[1..($tokens.Count - 1)] } else { @() }

        # Execute the command
        switch ($command) {
            'exit' {
                exit
            }
            'echo' {
                Write-Host $args
            }
            'clear' {
                Clear-Host
            }
            'pwd' {
                Write-Host $kaliPath
            }
            'cd' {
                $cdPath = $args
                # Block Windows paths by checking if the second character is a colon
                if ($cdPath -match '^[A-Za-z]:') {
                    Write-Host "Cannot change directory to Windows path: $cdPath"
                    continue
                }

                # If the path starts with /, replace that character with the $installPart variable
                if ($cdPath -match '^/') {
                    $cdPath = $installPart + '/' + $cdPath[1..$cdPath.Length]
                }

                # Replace forward slashes with backslashes
                $cdPath = $cdPath.Replace('/', '\')

                # If the path starts with ~, replace that character with the home directory
                if ($cdPath -match '^~') {
                    $homeDir = "$installPart\home\$env:USERNAME"
                    $cdPath = $homeDir + $cdPath[1..$cdPath.Length]
                    Write-Host "Changing directory to $cdPath"
                    Set-Location -Path $cdPath
                } else {
                    Write-Host "Changing directory to $cdPath"
                    Set-Location -Path $cdPath
                }
            }
            default {
                if ($command -eq '') {
                    # No command
                    # Loop automatically will continue, so we don't need the continue statement.
                } else {
                    # Get bashPath
                    $bashPath = Convert-ToBashPath -path (Get-Location).Path

                    # Fallback to git bash
                    $bashExe = $bashexepath
                    $commandLine = "cd '$bashPath'; $command $($args -join ' ')"
                    & $bashExe -c $commandLine
                }
            }
        }
    }
}

# Run the cmdlet
Get-Command