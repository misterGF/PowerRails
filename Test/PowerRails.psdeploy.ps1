# Upload to powershell gallery
Deploy 'Upload to gallery' {
  $root = Split-Path $PSScriptRoot -Parent
  $config = get-content "$root\config.json" | ConvertFrom-Json

   Publish-Module -Name $config.name -NuGetApiKey $config.apikey
}
