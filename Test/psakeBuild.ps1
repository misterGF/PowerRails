properties {
  $powerrailsModule = Join-Path $root "PowerRails.psm1"
}

# Default task includes Analyzing and Testing of script
task default -depends Analyze, Test

# Analyze by running Invoke-ScriptAnalyzer. Check script against best known practices
task Analyze {
  $saResults = Invoke-ScriptAnalyzer -Path "$root\Public" -Severity @('Error', 'Warning') -Recurse -ExcludeRule "PSAvoidUsingWriteHost","PSUseDeclaredVarsMoreThanAssignments" -Verbose:$false
  $saResults += Invoke-ScriptAnalyzer -Path "$root\Private" -Severity @('Error', 'Warning') -Recurse -Verbose:$false

  if ($saResults) {
    $saResults | Format-Table
    Write-Error -Message 'One or more Script Analyzer errors/warnings where found. Build cannot continue!'
  }
}

# Run our test to make sure everything is in line
task Test {
  $testResults = Invoke-Pester -Path "$root\test\PowerRails.test.ps1" -para

  if ($testResults.FailedCount -gt 0) {
    $testResults | Format-List
    Write-Error -Message 'One or more Pester tests failed. Build cannot continue!'
  }
}

# Run a deployment script after appropriate tests are passed
task Deploy -depends Analyze, Test {
  Invoke-PSDeploy -Path "$root\test\PowerRails.psdeploy.ps1" -Force -Verbose:$VerbosePreference
}
