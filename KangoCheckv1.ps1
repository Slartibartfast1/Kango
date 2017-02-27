$credentials = Get-credential
New-PSDrive -Name KangoPrintQueue -PSProvider FileSystem -Root \\<servername>\c$\printoutput -Credential $credentials | out-null
""
"==========================="
""
function kangoCheck 
{
    While ($true) {
        [string]$files = ((Get-ChildItem KangoPrintQueue:\).count -7)
        $files + " files in Kango print queue"
        Start-Sleep -s 30
        }
}

kangoCheck