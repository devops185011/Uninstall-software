
cls
$RemoteComputers=Get-Content D:\test\serverList.txt 

$output="D:\test\output.csv"
$log="D:\test\log.txt"

If (Test-Path $output){
	Remove-Item $output
}

If (Test-Path $log){
	Remove-Item $log
}


<#
Function Get-Cred
{
    try
    {
        $a=get-credential
        $u = $a.username
        $user = $u.split("\")
        $p = $a.password
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($p)
        $pass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    }   
    catch
    {
            $l= New-Object -ComObject wscript.shell
            if($m -eq '1')
            {
                write-host 'Script cancelled'
                $host.SetShouldExit(1)
                exit
            }
            else
            {
                exit
            }
    }       
    return $a
}   


$cred=get-cred

#>

ForEach ($Computer in $RemoteComputers)
{

If (Test-Connection -ComputerName $Computer -Quiet)

{


Write-Host "able to connect to $Computer" -ForegroundColor Yellow



$scriptBlock = { 


#dir
dir|out-null



$antivirusName='Trend Micro OfficeScan Agent'


$antivirusInfo=Get-WmiObject -Class Win32_Product |?{$_.name -eq $antivirusName}|select name|foreach{$_.name} -ErrorAction SilentlyContinue

if($antivirusInfo -eq $antivirusName)
{

$serverName=hostname
Write-Output "$antivirusName NOT uninstalled `n"

}

else
{
    $serverName=hostname
Write-Output "SUCCESSFULLY uninstalled $antivirusName `n"

}




#############################################################################################>




} #end of script block


     Try
         {

            
         Invoke-Command -ComputerName $Computer -ScriptBlock $scriptBlock -Credential $cred -ErrorAction Continue
         
         
         
         } #end of try
   
   
     Catch
         {
             Write-Host "unavaible to connect to $Computer" -ForegroundColor Yellow
         } #end of catch


} ##end of if

else{
             Write-Host "unavaible to connect to $Computer" -ForegroundColor Yellow
             Write-Output "unavaible to connect to $Computer" |out-file -FilePath $log -Append
}

} #end of for loop
