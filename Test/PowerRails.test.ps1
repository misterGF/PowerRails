# Determine our script root
if(-not $PSScriptRoot) {
  $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}

# Load module via definition
Import-Module $PSScriptRoot\..\PowerRails.psd1 -Force

# Run our module tests
InModuleScope PowerRails {
  # Check that modules are installed
  Describe 'Load PowerRails' {
    It 'PowerRails modules is loaded' {
      $powerRailsModule = get-module PowerRails
      $powerRailsModule | Should Be $true
    }
  }

  # Define name and where our module will be created
  $TestPath = 'TestDrive:\'
  $newModuleName = 'TestModule'
  $moduleFullPath = $TestPath + $newModuleName
  $moduleFile = $moduleFullPath +"\$newModuleName.psd1"

  # Define name and where our script will be created
  $newScriptName = 'TestScript'
  $scriptFullPath = $TestPath + $newScriptName

  # Test how our module responds to different inputs
  Describe 'Module - Input validation' {
    # Make sure that a name not given throws
    It 'Throws if no name is given' { { New-PowerRailsModule -path $TestPath } | Should throw }

    # Check path is given
    It 'Throws if no path is given' { { New-PowerRailsModule -name $name } | Should throw }
  }

  Describe 'Module - Validate resource files' {
    # Check and grab resources
    $requiredFiles = @('build.ps1', 'psakeBuild.ps1', 'Template.psm1', 'Template.psd1', 'Template.psdeploy.ps1', 'Template.tests.ps1')
    $testFolder = get-item $PSScriptRoot
    $parentFolder = $testFolder.parent.FullName + '\Resources\'

    foreach ($file in $requiredFiles) {
      $checkFile = $parentFolder + $file

      It "Check for required resource file: $checkFile" {
        Test-Path $checkFile | Should Be $true
      }
    }
  }

  Describe 'Module - New-PowerRailsModule runs successfully' {
    It "Generate module: $newModuleName" { { New-PowerRailsModule -Name $newModuleName -Path $TestPath | Out-Null } | Should Not throw }
    
    It "Created module folder" {
      test-path $moduleFullPath | Should Be $true
    }

    # Verify that the resources were copied over
    foreach ($file in $requiredFiles) {
      $newName = $file.replace('Template', $newModuleName)
      $checkFile = $moduleFullPath +"\"+ $newName

      It "Check generated file: $checkFile" {
        Test-Path $checkFile | Should Be $true
      }
    }
  }

  Describe 'Module - Can import and run' {
    It "Importing $moduleFile" { { Import-Module $moduleFile -force } | Should Not throw }

    It "Running test-$newModuleName" {
      $cmdlet = "Test-$newModuleName"
      Invoke-Expression $cmdlet | Should Be "Reporting from test-$newModuleName function!"
    }
  }

