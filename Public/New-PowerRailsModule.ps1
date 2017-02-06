<#
.SYNOPSIS
  Scaffold a powershell module based on best practices.
.DESCRIPTION
  Scaffold a powershell module based on best practices.
  A folder will be created with required files to get you going.
.PARAMETER name
  Name of your module
.PARAMETER path
  Path where you want the new folder to be created. Defaults to current path.
.PARAMETER useTabs
  A switch parameter to change 2 space tabs into a tab character.
.EXAMPLE
  New-PowerRailsModule -name 'MakeMyLifeEasier' -path 'c:\scripts\'
#>
function New-PowerRailsModule {
  [CmdletBinding()]
  Param(
    [Parameter(Position=0, Mandatory=$true)][string]$name,
    [Parameter(Position=1, Mandatory=$false)][string]$path='.',
    [switch]$useTabs
  )

  $ErrorActionPreference = "STOP"

  # Import utility functions and variables
  . "$PSScriptRoot\utilities.ps1"

  # Collect some info to use in our generated files
  $date = get-Date
  $author = $Env:username
  $modulePath = "{0}\{1}" -f $path, $name

  # Write our starting output
  write-PowerRailsStatus "Generating new module: $name" -type 'header'

  try {
    write-error 'FUC'
    if (!(test-path $modulePath)) {
      Write-PowerRailsStatus "Generating module path: $modulePath"
      new-item -name $name -path $Path -type 'Directory' | Out-Null
    }

    $requiredFiles = @('.editorconfig', 'build.ps1', 'psakeBuild.ps1', 'Template.psm1', 'Template.psd1', 'Template.psdeploy.ps1', 'Template.tests.ps1')
    $testFolder = get-item $PSScriptRoot
    $parentFolder = $testFolder.parent.FullName + '\Resources\'

    foreach ($file in $requiredFiles) {
      $filePath = $parentFolder + $file
      $content = get-Content $filePath

      switch($file) {
        "build.ps1" {
          # Just copy
          Write-PowerRailsStatus "Copying Build.ps1"
          copy-item $filePath $modulePath
        }
        ".editorconfig" {
          # Just copy
          Write-PowerRailsStatus "Copying .editorconfig"
          copy-item $filePath $modulePath
        }
        "psakeBuild.ps1" {
          # Replace name in content and output to new file
          Write-PowerRailsStatus "Generating psakeBuild.ps1"
          $content = $content.replace('$name', $Name)
          $content = $content.replace('$fileType', 'psm1')

          $newFile = "$modulePath\$file"
          $content | out-file $newFile -encoding 'UTF8'
        }
        "Template.psd1" {
          # Generate file name
          $newName = $file.replace('Template', $name)
          $newFile = "$modulePath\$newName"
          Write-PowerRailsStatus "Generating $file"

          # Rename name and author
          $content = $content.replace('$Name', $Name)
          $content = $content.replace('$author', $Author)

          # Output file
          $content | out-file $newFile -encoding 'UTF8'
        }
        "Template.psm1" {
          # Generate file name
          $newName = $file.replace('Template', $name)
          $newFile = "$modulePath\$newName"
          Write-PowerRailsStatus "Generating $file"

          # Rename name, author & date
          $content = $content.replace('$name', $Name)
          $content = $content.replace('$author', $Author)
          $content = $content.replace('$date', $date)
          # Output file
          $content | out-file $newFile
        }
        "Template.tests.ps1" {
          # Generate file name
          $newName = $file.replace('Template', $name)
          $newFile = "$modulePath\$newName"
          Write-PowerRailsStatus "Generating $file"

          # Rename file name
          $fileName = $Name +".psm1"
          $content = $content.replace('$name', $fileName)

          # Output file
          $content | out-file $newFile -encoding 'UTF8'
        }
        "Template.psdeploy.ps1" {
          # Generate file name
          $newName = $file.replace('Template', $name)
          $newFile = "$modulePath\$newName"
          Write-PowerRailsStatus "Generating $file"

          # Replace variables name
          $content = $content.replace('$name', $newName)
          $content = $content.replace('$module', $name)

          # Output file
          $content | out-file $newFile -encoding 'UTF8'
        }
      }
    }
  } catch {
    $errorMessage = $_.toString()
    Write-PowerRailsStatus -line $errorMessage -type 'error'
  }
}

New-PowerRailsModule -name 'cool'
