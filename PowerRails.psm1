# Get public and private function definition files.
$Public = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)

# Dot source the files
forEach($import in @($Public + $Private)) {
  try {
    . $import.fullname
  } catch {
    Write-Error -Message "Failed to import function $($import.fullname): $_"
  }
}

# Export Public functions
Export-ModuleMember -Function $Public.Basename
