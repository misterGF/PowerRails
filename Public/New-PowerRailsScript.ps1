<#
.Synopsis
  Scaffold a powershell script based on best practices.
.DESCRIPTION
  Scaffold a powershell script based on best practices.
.EXAMPLE
  New-PowerRailsScript -name "AwesomeModule"
#>
function New-PowerRailsScript {
  [CmdletBinding()]
  Param([string]$name, [string]$path, [switch]$useTabs)

  if(!$Name) {
    throw 'A name is required.'
  }

  if(!$Path) {
    throw 'A path is required.'
  }
  $date = get-Date
  $Author = $Env:username
  $modPath = $Path +"\"+ $Name

  write-HostPretty "Generating new script: $name" -type 'Title'

  if(!(test-path $modPath)) {
    write-HostPretty "Generating script path: $modPath"
    new-item -name $name -path $Path -type 'Directory' | Out-Null
  }

  $requiredFiles = @('.editorconfig', 'build.ps1', 'psakeBuild.ps1', 'Template.ps1', 'Template.psdeploy.ps1', 'Template.tests.ps1')
  $testFolder = get-item $PSScriptRoot
  $parentFolder = $testFolder.parent.FullName + '\Resources\'

  foreach ($file in $requiredFiles) {
    $filePath = $parentFolder + $file
    $content = get-Content $filePath

    switch($file) {
      "build.ps1" {
        # Just copy
        Write-HostPretty "Copying Build.ps1"
        copy-item $filePath $modPath
      }
      ".editorconfig" {
        # Just copy
        Write-HostPretty "Copying .editorconfig"
        copy-item $filePath $modPath
      }
      "psakeBuild.ps1" {
        # Replace name in content and output to new file
        Write-HostPretty "Generating psakeBuild.ps1"
        $content = $content.replace('$name', $Name)
        $content = $content.replace('$fileType', 'ps1')

        $newFile = "$modPath\$file"
        $content | out-file $newFile -encoding 'UTF8'
      }
      "Template.ps1" {
        # Generate file name
        $newName = $file.replace('Template', $name)
        $newFile = "$modPath\$newName"
        Write-HostPretty "Generating $file"

        # Rename name, author & date
        $content = $content.replace('$name', $Name)
        $content = $content.replace('$author', $Author)
        $content = $content.replace('$date', $date)
        # Output file
        $content | out-file $newFile -encoding 'UTF8'
      }
      "Template.tests.ps1" {
        # Generate file name
        $newName = $file.replace('Template', $name)
        $newFile = "$modPath\$newName"
        Write-HostPretty "Generating $file"

        # Rename file name
        $fileName = $Name +".ps1"
        $content = $content.replace('$name', $fileName)

        # Output file
        $content | out-file $newFile -encoding 'UTF8'
      }
      "Template.psdeploy.ps1" {
        # Generate file name
        $newName = $file.replace('Template', $name)
        $newFile = "$modPath\$newName"
        Write-HostPretty "Generating $file"

        # Replace variables name
        $content = $content.replace('$name', $newName)
        $content = $content.replace('$module', $name)

        # Output file
        $content | out-file $newFile -encoding 'UTF8'
      }
    }
  }
}

$tabs = "	"
$spaces = "  "
