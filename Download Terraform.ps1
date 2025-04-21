# $ErrorActionPreference = "SilentlyContinue"
# Enable TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Variables
$downloadfolder = "D:\Automation\Terraform\"

# Create Folder
$checkdir = Test-Path -Path $downloadfolder
if ($checkdir -eq $false){
    Write-Verbose "Creating '$downloadfolder' folder"
    New-Item -Path $downloadfolder -ItemType Directory | Out-Null
}
else {
    Write-Verbose "Folder '$downloadfolder' already exists."
}

# Download the latest Packer version
$product='terraform'
$terraformurl = Invoke-WebRequest -Uri "https://developer.hashicorp.com/terraform/install?product_intent=terraform" | Select-Object -Expand links | Where-Object href -match "//releases\.hashicorp\.com/$product/\d.*/$product_.*_windows_amd64\.zip$" | Select-Object -Expand href
$terraformdown = $terraformurl | Split-Path -Leaf
$terraformdownload = $downloadfolder + $terraformdown
$webclient = New-object -TypeName System.Net.WebClient
$webclient.DownloadFile($terraformurl, $terraformdownload)

# Unzip Packer
Expand-Archive $terraformdownload -DestinationPath $downloadfolder -force
# Remove the Packer ZIP file
Remove-Item $terraformdownload

# Go to the Packer download folder
Set-Location $downloadfolder