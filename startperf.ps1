# startperf.ps1 version 1.1 8/13/2025

$labSKU = 'vSphere Performance (HOL-2637-07/08/09-VCF-L)'
$timeNow = $(Get-Date)
Write-Host -ForegroundColor Green "`nPlease wait, starting $labSKU labs @ $timeNow"

# Connect vC
Write-Host "Connecting to vCenter Server..."
Connect-VIserver -server "vc-mgmt-a.site-a.vcf.lab" -user "administrator@vsphere.local" -password "VMware123!VMware123!" | Out-Null

# Disable DRS
Write-Host "Configuring Cluster..."
Set-Cluster -Cluster "cluster-mgmt-01a" -DrsEnabled:$false -HAAdmissionControlEnabled $false -Confirm:$false | Out-Null

# Move VMs to correct hosts
Write-Host "Migrating VMs to Correct Hosts..."
Move-VM -VM 'perf-01a' -Destination 'esx-01a.site-a.vcf.lab' | Out-Null
Move-VM -VM 'perf-02a' -Destination 'esx-02a.site-a.vcf.lab' | Out-Null
Move-VM -VM 'Client0' -Destination 'esx-03a.site-a.vcf.lab' | Out-Null
Move-VM -VM 'PrimeClient' -Destination 'esx-03a.site-a.vcf.lab' | Out-Null
Move-VM -VM 'Standby0' -Destination 'esx-03a.site-a.vcf.lab' | Out-Null

# Start VMs
Write-Host "Starting VMs..."
#Get-VM | Where-Object {$_.PowerState -eq 'PoweredOff'} | Start-VM -RunAsync -Confirm:$false | Out-Null
Start-VM -VM 'acct-web01' -RunAsync -Confirm:$false | Out-Null
Start-VM -VM 'app01a' -RunAsync -Confirm:$false | Out-Null
Start-VM -VM 'Client0' -RunAsync -Confirm:$false | Out-Null
#Start-VM -VM 'core-a' -RunAsync -Confirm:$false | Out-Null
Start-VM -VM 'perf-01a' -RunAsync -Confirm:$false | Out-Null
Start-VM -VM 'perf-02a' -RunAsync -Confirm:$false | Out-Null
Start-VM -VM 'PrimeClient' -RunAsync -Confirm:$false | Out-Null
Start-VM -VM 'Standby0' -RunAsync -Confirm:$false | Out-Null

# Disconnect vC
Write-Host "Disconnecting from vCenter Server..."
Disconnect-VIserver -Confirm:$false

$timeNow = $(Get-Date)
Write-Host -ForegroundColor Green "Finished starting $labSKU labs @ $timeNow`n"
#Write-Host $( "$(Get-Date) Finished. Runtime was {0:N0} minutes." -f  ((Get-RuntimeSeconds $timeNow) / 60) )
