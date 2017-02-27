<#
Changelog:
v2 - added warnings at 4 and 10 minutes.
     added comments
#>

$credentials = Get-credential
New-PSDrive -Name KangoPrintQueue -PSProvider FileSystem -Root \\<servername>\c$\printoutput -Credential $credentials | out-null
""
"==========================="
""
function kangoCheck # Constantly check queue length
{
    $files = 0
    $crashCount = 0
    While ($true) {
        $count = (Get-ChildItem KangoPrintQueue:\).count -7
        if ( $count -lt $files ) {                # If queue has decreased in last 30s
            $crashCount = 0                       # Set error counter back to 0
        } elseif ( ($count -gt $files) -or ($count -eq $files) -and ($files -gt 0) ) {                             # If queue is 1 or more and has increased or stayed the same for last 30s
            $crashCount += 1                      # Increase error counter by 1
            if ( $crashCount -eq 4 ) {            # If error counter reaches 4 (4x30s = 2 minutes)
                Write-Host "WARNING: Print queue has not decreased for 2 minutes" -ForegroundColor Yellow          # Print warning message to screen in yellow
            } elseif ( $crashCount -gt 9 ) {     # If error counter reaches 10 (10x30s = 5 minutes)
                Write-Host "WARNING: Print queue has not decreased for >5 minutes" -ForegroundColor Red             # Print warning message to screen in red
                Write-Host "Go restart services right now!" -ForegroundColor Red
            }
        }
        [string]$count + " files in Kango print queue"
        $files = $count
        Start-Sleep -s 30                         # Wait 30s
        }
}

kangoCheck