# Determine our script root
$root = Split-Path $PSScriptRoot -Parent

# Load module via definition
Import-Module $root\PowerRails.psd1 -Force

# Run our module tests
InModuleScope PowerRails {
  # Check that modules are installed
  Describe 'Load PowerRails' {
    It 'PowerRails modules is loaded' {
      $powerRailsModule = get-module PowerRails

      $powerRailsModule | Should Be $true
    }
  }

  Describe 'New-PowerRailsItem - Validate resource files' {
    # Check and grab resources
    $requiredFiles = @('build.ps1', 'psakeBuild.ps1', 'Template.ps1', 'Template.psm1', 'Template.psd1', 'Template.psdeploy.ps1', 'Template.tests.ps1')
    $testFolder = get-item $PSScriptRoot
    $parentFolder = $testFolder.parent.FullName + '\Resources\'

    foreach ($file in $requiredFiles) {
      $checkFile = $parentFolder + $file

      It "Check for required resource file: $checkFile" {
        Test-Path $checkFile | Should Be $true
      }
    }
  }

  Describe 'Module - Runs successfully' {
    # Define name and where our module will be created
    $TestPath = 'TestDrive:\'

    $newModuleName = 'TestModule'
    $moduleFullPath = $TestPath + $newModuleName
    $moduleFile = $moduleFullPath +"\$newModuleName.psd1"
    
    It "Generate module: $newModuleName" { 
      { New-PowerRailsItem -Name $newModuleName -Path $TestPath } | Should Not throw 
    }
    
    It "Created module folder" {
      test-path $moduleFullPath | Should Be $true
    }

    # Verify that the resources were copied over
    $exclude = @('template.ps1') # Script specific file

    foreach ($file in $requiredFiles) {
      if ($exclude -notcontains $file) {
        $newName = $file.replace('Template', $newModuleName)
        $checkFile = $moduleFullPath +"\"+ $newName

        It "Check generated file: $checkFile" {
          Test-Path $checkFile | Should Be $true
        }
      }
    }
  }
  
  Describe 'Script - Runs successfully' {
    # Define name and where our script will be created
    $TestPath = 'TestDrive:\'

    $newScriptName = 'TestScript'
    $scriptFullPath = $TestPath + $newScriptName

    It "Generate script: $scriptFullPath" { 
      { New-PowerRailsItem -Name $newScriptName -Type 'script' -Path $TestPath } | Should Not throw
    }
    
    It "Created script folder" {
      test-path $scriptFullPath | Should Be $true
    }

    # Verify that the resources were copied over
    $exclude = @('template.psm1', 'template.psd1') # module specific file

    foreach ($file in $requiredFiles) {
      if ($exclude -notcontains $file) {
        $newName = $file.replace('Template', $newScriptName)
        $checkFile = $scriptFullPath +"\"+ $newName

        It "Check generated file: $checkFile" {
          Test-Path $checkFile | Should Be $true
        }
      }
    }
  }
}

