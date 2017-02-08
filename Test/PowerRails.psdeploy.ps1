# Upload to powershell gallery
Deploy 'Upload to gallery' {
  # Get config file
  $root = Split-Path $PSScriptRoot -Parent

  try {
    $config = get-content "$root\config.json" | ConvertFrom-Json
    $moduleFolder = Join-Path "$root\dist" $config.name
    
    # Create and empty out dist file
    if (!(Test-Path $moduleFolder)) {
      New-Item -Path "$moduleFolder" -ItemType:Directory | Out-Null
    }

    Remove-Item -Path "$moduleFolder\*" -Recurse

    # Copy files over
    Copy-Item -Path "$root\PowerRails*" -Destination $moduleFolder
    Copy-Item -Path "$root\build.ps1" -Destination $moduleFolder
    Copy-Item -Path "$root\Public" -Destination $moduleFolder -Recurse
    Copy-Item -Path "$root\Private" -Destination $moduleFolder -Recurse
    Copy-Item -Path "$root\Resources" -Destination $moduleFolder -Recurse
    Copy-Item -Path "$root\Test" -Destination $moduleFolder -Recurse

    # Publish module
    Publish-Module -path $moduleFolder -NuGetApiKey $config.apikey
  } catch {
    write-error "Unable to deploy: $_"
  }
}
