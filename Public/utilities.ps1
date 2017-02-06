function Write-PowerRailsStatus {
  param(
    [string]$line,
    [string]$type='info',
    [int]$depth=1,
    $spaces="  "
  )

  # Determine starting point.
  $seperator = $spaces * $depth

  switch ($type) {
    'header' {
      Write-Host $line "`n" -NoNewline
      Write-Host ("=" * $line.length) -ForegroundColor:Green
    }
    'info' {
      Write-Host "$seperator" -ForegroundColor:DarkGray -NoNewline
      Write-Host $line
    }
    'success' {
      Write-Host "$seperator $([char]0x2713) " -ForegroundColor:Green -NoNewline
      Write-Host "SUCCESS =>  " -ForegroundColor:DarkGreen -NoNewline
      Write-Host $line "`n"
    }
    'task' {
      Write-Host "`n$seperator TASK =>  " -ForegroundColor:DarkGreen -NoNewline
      Write-Host $line "`n"
    }
    'warning' {
      Write-Host "$seperator WARNING =>  " -ForegroundColor:Yellow -NoNewline
      Write-Host $line "`n"
    }
    'exception' {
      Write-Host "$seperator X " -ForegroundColor:Red -NoNewline
      Write-Host "EXCEPTION =>  " -ForegroundColor:DarkGreen -NoNewline
      Write-Host $line "`n"
    }
    'blank' {
      Write-Host "->  " -ForegroundColor:Green -NoNewline
      Write-Host $line "`n"
    }
  }
}
