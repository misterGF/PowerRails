function New-PowerRailsItem {
  <#
.SYNOPSIS
  Scaffold a powershell module or script based on best practices.
.DESCRIPTION
  Scaffold a powershell module or script based on best practices.
  A folder will be created with required files to get you going.
.PARAMETER name
  Name of your module or script.
.PARAMETER type
  Type of structure you want scaffolded. Script or module. Defaults to module.
.PARAMETER path
  Path where you want the new folder to be created. Defaults to current path.
.PARAMETER useTabs
  A switch parameter to change 2 space tabs into a tab character.
.EXAMPLE
  Create a new module
  New-PowerRailsItem -name 'MyAwesomeModule' -type 'module' -path 'c:\scripts'

  Create a new script
  New-PowerRailsItem -name 'MyStandAloneScript' -type 'script' -path 'c:\code'
#>
  [CmdletBinding(SupportsShouldProcess = $true)]

  Param(
    [Parameter(Mandatory=$true)][string]$name,
    [ValidateSet('script', 'module')][string]$type='module',
    [string]$path='.',
    [switch]$useTabs
  )

  Begin {
    $ErrorActionPreference = "STOP"

    # Import utility functions and variables
    . "$PSScriptRoot\utilities.ps1"

    # Collect some info to use in our generated files
    $date = get-Date
    $author = $Env:username
    $modulePath = "{0}\{1}" -f $path, $name

    # Write our starting output
    write-PowerRailsStatus -line "Generating new module: $name" -type 'header'
  }

  Process {
    try {
      # Create directory if needed
      if (!(test-path $modulePath)) {
        Write-PowerRailsStatus -line "Generating module path: $modulePath"
        new-item -name $name -path $Path -type 'Directory' | Out-Null
      }

      # Determine folders and files needed
      if ($type -eq 'module') {
        $requiredFiles = @('.editorconfig', 'build.ps1', 'psakeBuild.ps1', 'Template.psm1', 'Template.psd1', 'Template.psdeploy.ps1', 'Template.tests.ps1')
        $fileExtension = 'psm1'
      } else {
        $requiredFiles = @('.editorconfig', 'build.ps1', 'psakeBuild.ps1', 'Template.ps1', 'Template.psdeploy.ps1', 'Template.tests.ps1')
        $fileExtension = 'ps1'
      }

      $testFolder = get-item $PSScriptRoot
      $parentFolder = $testFolder.parent.FullName + '\Resources\'

      # Create each file based on our resources
      foreach ($file in $requiredFiles) {
        $filePath = Join-Path $parentFolder $file # Our resource template
        $content = get-Content $filePath # Content from the template file

        $newFile = Join-Path $modulePath $file # Our new file

        # Replace spaces with tabs when switch is passed
        if ($useTabs) {
          $content = $content.Replace($spaces, $tabs)
        }

        # Perform the proper action for each file
        switch ($file) {
          'build.ps1' {
            # Generate file
            Write-PowerRailsStatus "Generating $newFile"
            $content | out-file $newFile -Encoding 'UTF8'
          }
          '.editorconfig' {
            # Fill in indent style and size
            Write-PowerRailsStatus "Generating $newFile"

            # determine values for editorconfig
            if ($useTabs) {
              $style = 'tab'
            } else {
              $style = 'space'
            }

            # fill in required values
            $content = $content.replace('$indent_style', $style)

            # Generate file
            $content | out-file $newFile -encoding 'UTF8'
          }
          'psakeBuild.ps1' {
            # Replace name in content and output to new file
            Write-PowerRailsStatus "Generating $newFile"
            $content = $content.replace('$name', $Name)
            $content = $content.replace('$fileType', $fileExtension)

            # Generate file
            $content | out-file $newFile -encoding 'UTF8'
          }
          'Template.psd1' {
            # Generate file name
            $newFileName = $newFile.replace('Template', $name)
            Write-PowerRailsStatus "Generating $newFileName"

            # Rename name and author
            $content = $content.replace('$Name', $Name)
            $content = $content.replace('$author', $Author)

            # Output file
            $content | out-file $newFileName -encoding 'UTF8'
          }
          'Template.psm1' {
            # Generate file name
            $newFileName = $newFile.replace('Template', $name)
            Write-PowerRailsStatus "Generating $newFileName"

            # Rename name, author & date
            $content = $content.replace('$name', $Name)
            $content = $content.replace('$author', $Author)
            $content = $content.replace('$date', $date)

            # Output file
            $content | out-file $newFileName -encoding 'UTF8'
          }
          "Template.ps1" {
            # Generate file name
            $newFileName = $newFile.replace('Template', $name)
            Write-PowerRailsStatus "Generating $newFileName"

            # Rename name, author & date
            $content = $content.replace('$name', $Name)
            $content = $content.replace('$author', $Author)
            $content = $content.replace('$date', $date)

            # Output file
            $content | out-file $newFile -encoding 'UTF8'
          }
          'Template.tests.ps1' {
            # Generate file name
            $newFileName = $newFile.replace('Template', $name)
            Write-PowerRailsStatus "Generating $newFileName"

            # Construct our module path so that we import it in our tests
            $fileName = $Name + ".$fileExtension"
            $content = $content.replace('$name', $name)
            $content = $content.replace('$fileName', $fileName)

            # Output file
            $content | out-file $newFileName -encoding 'UTF8'
          }
          'Template.psdeploy.ps1' {
            # Generate file name
            $newFileName = $newFile.replace('Template', $name)
            Write-PowerRailsStatus "Generating $newFileName"

            # Replace variables name
            $content = $content.replace('$module', $name)

            # Output file
            $content | out-file $newFileName -encoding 'UTF8'
          }
        }
      }
    } catch {
      $errorMessage = $_.toString()
      Write-PowerRailsStatus -line $errorMessage -type 'error'
    }
  }

  End {
    # Empty
  }

}
