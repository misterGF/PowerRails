function test-$name {
  <#
  .SYNOPSIS
    Write a synopsis here
  .DESCRIPTION
    Write a description here
  .EXAMPLE
    C:\PS> test-$name
  .NOTES
    Author: $author
    CreateDate: $date
  #>
  [cmdletbinding()]
  [OutputType([String])]
  param()

  Write-Output "Reporting from test-$name function!"
}

# Export functions
Export-ModuleMember -Function *
