function Write-PowerRailsStatus {
  <#
  .SYNOPSIS
    Write PowerRails progress to host.
  .DESCRIPTION
    Write PowerRails progress to host. This function just makes the output a little prettier.
  .PARAMETER line
    The text that you want to appear in your console
  .PARAMETER type
    The type of output you want. This changes the display of line accordingly.
    Validate entries are header, info, task, success, error & warning.
  .PARAMETER depth
    Controls how deep the text is indented. For display purposes.
  .PARAMETER spaces
    Constrol what is used as the indentation characters.
  .EXAMPLE
    Write-PowerRailsStatus -line 'Hello world!' -type 'header'
  #>

  param(
    [Parameter(Mandatory=$true)][string]$line,
    [ValidateSet('header', 'info', 'task', 'success', 'error', 'warning')][string]$type='info',
    [int]$depth=1,
    $spaces="  ",
    $tabs = "	"
  )

  # Determine starting point.
  $seperator = $spaces * $depth

  # Switch between type that is required
  switch ($type) {
    'header' {
      Write-Host $line
      Write-Host ("=" * $line.length) -ForegroundColor:Green
      Write-Host "`n"
    }
    'info' {
      Write-Host "$seperator * " -ForegroundColor:DarkGray -NoNewline
      Write-Host $line "`n"
    }
    'task' {
      # This option exists so that we can attach some cool animations to the output for something that is long running.
      Write-Host "$seperator" -ForegroundColor:DarkGray -NoNewline
      Write-Host $line -NoNewline
    }
    'success' {
      Write-Host "$seperator Success! - " -ForegroundColor:Green -NoNewline
      Write-Host $line "`n"
    }
    'warning' {
      Write-Host "$seperator ! " -ForegroundColor:Yellow -NoNewline
      Write-Host $line "`n"
    }
    'error' {
      Write-Host "$seperator X " -ForegroundColor:Red -NoNewline
      Write-Host $line "`n"
    }
    default {
      Write-Host $seperator $line
    }
  }
}

# Helpers for generator
$spaces = "  "
$tabs = "	"

