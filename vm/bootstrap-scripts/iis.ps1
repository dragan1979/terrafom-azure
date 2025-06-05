# Start transcript logging
Start-Transcript -Path "C:\Temp\iis.log" -Append -Force

Write-Host "Starting IIS installation script..."

# Install IIS Web Server role along with management tools
# -IncludeManagementTools installs IIS Management Console and other tools.
Install-WindowsFeature -Name Web-Server -IncludeManagementTools -Confirm:$false

# Configure the World Wide Web Publishing Service to start automatically and start it
Write-Host "Configuring and starting World Wide Web Publishing Service..."
Set-Service -Name W3SVC -StartupType Automatic
Start-Service -Name W3SVC

Write-Host "IIS installation complete."


Write-Host "Creating example web page content..."

# Define the path for the new website content
$WebAppPath = "C:\inetpub\MyExampleWebsite"

# Create the directory for the website
if (-not (Test-Path -Path $WebAppPath)) {
    New-Item -Path $WebAppPath -ItemType Directory -Force
    Write-Host "Created directory: $WebAppPath"
} else {
    Write-Host "Directory already exists: $WebAppPath"
}

# Define the content for the example HTML page
$HtmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello from IIS!</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; color: #333; text-align: center; padding-top: 50px; }
        .container { background-color: #fff; margin: 20px auto; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); max-width: 600px; }
        h1 { color: #0056b3; }
        p { font-size: 1.1em; }
        footer { margin-top: 30px; font-size: 0.9em; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Hello from your Azure IIS Web Server!</h1>
        <p>This is a simple example web page deployed via PowerShell custom data.</p>
        <p>Your IIS server is up and running!</p>
    </div>
    <footer>
        <p>Deployed on $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")</p>
    </footer>
</body>
</html>
"@

# Save the HTML content to index.html in the new directory
$IndexPath = Join-Path -Path $WebAppPath -ChildPath "index.html"
$HtmlContent | Out-File -FilePath $IndexPath -Encoding UTF8 -Force
Write-Host "Created index.html at: $IndexPath"


Write-Host "Configuring Default Web Site to use the new content path..."

# Import the WebAdministration module if not already loaded (might be after IIS installation)
Import-Module WebAdministration -ErrorAction SilentlyContinue

# Get the Default Web Site
$DefaultWebSite = Get-Website -Name "Default Web Site" -ErrorAction SilentlyContinue

if ($DefaultWebSite) {
    # Set the physical path of the Default Web Site
    Set-ItemProperty -LiteralPath "IIS:\Sites\$($DefaultWebSite.Name)" -Name physicalPath -Value $WebAppPath
    Write-Host "Default Web Site physical path updated to: $WebAppPath"

    # Restart the Default Web Site to apply changes
    Restart-Website -Name "Default Web Site"
    Write-Host "Default Web Site restarted."
} else {
    Write-Warning "Default Web Site not found. Cannot configure web page."
}

Write-Host "Web page creation and configuration complete."

# Stop transcript logging
Stop-Transcript