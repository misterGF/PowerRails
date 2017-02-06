# Pester testing. https://github.com/pester/Pester/wiki
$sut = "$PSScriptRoot\$name"

Describe 'Unit Tests' {
  Context 'Run Validation' {
    it 'Should run successfully' {

      if ($sut -like '*ps1') {
        $run = invoke-expression $sut
      } else {
        import-module $sut
        $run = test-$name
      }

      $run | Should Match "Reporting from"
    }
  }
}
