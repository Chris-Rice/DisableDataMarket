<#
Written by: Lance Anderson
Stop all the Qlik Sense Services.  This stops them on the local machine 
but you can update the ComputerName to perform this task on a remote server.
#>

Get-Service QlikLoggingService -ComputerName localhost | Stop-Service
Get-Service QlikSenseEngineService -ComputerName localhost | Stop-Service
Get-Service QlikSensePrintingService -ComputerName localhost | Stop-Service
Get-Service QlikSenseProxyService -ComputerName localhost | Stop-Service
Get-Service QlikSenseServiceDispatcher -ComputerName localhost | Stop-Service
Get-Service QlikSenseSchedulerService -ComputerName localhost | Stop-Service
Get-Service QlikSenseRepositoryService -ComputerName localhost | Stop-Service

New-Item 'C:\Program Files\Common Files\Qlik\Sense' -ItemType directory
Move-Item 'C:\Program Files\Common Files\Qlik\Custom Data\QvDataMarketConnector' 'C:\Program Files\Common Files\Qlik\Sense\QvDataMarketConnector'

$path = 'C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config'
$xml = [xml](get-content($path))
$xml.Save($path+ ".old")

$runtime = $xml.configuration["runtime"]
if($runtime.generatePublisherEvidence -eq $null)
{
$gc = $xml.CreateElement("generatePublisherEvidence")
$gc.SetAttribute("enabled", "false")
$runtime.AppendChild($gc)
}

$runtime.generatePublisherEvidence.enabled = "false";
$xml.Save($path)

Get-Service QlikSenseRepositoryService -ComputerName localhost | Start-Service
Get-Service QlikSenseSchedulerService -ComputerName localhost | Start-Service
Get-Service QlikSenseServiceDispatcher -ComputerName localhost | Start-Service
Get-Service QlikSenseProxyService -ComputerName localhost | Start-Service
Get-Service QlikSensePrintingService -ComputerName localhost | Start-Service
Get-Service QlikSenseEngineService -ComputerName localhost | Start-Service
Get-Service QlikLoggingService -ComputerName localhost | Start-Service
