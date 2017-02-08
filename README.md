## Overview
**PowerRails - A module to generate your scripts folder structure.**
![PowerRails logo](http://res.cloudinary.com/gatec21/image/upload/v1486397147/powerrails_ppxobl.svg)

## Why?
Most scripts/modules have a similar directory structure.
You shouldn't waste your time creating it. Just use this module to
get a head start and add to your new structure as needed.

![PowerRails in action](http://res.cloudinary.com/gatec21/image/upload/v1486526550/2017-02-07_23-00-04_h75jvf.gif)

**PowerRails will also helps you to become a better developer.**

## How?
We include the following helpers to keep you on track 🚆 (pun intended).

- [Script Analyzer](https://github.com/PowerShell/PSScriptAnalyzer/tree/development/RuleDocumentation) is a set of rules that are based on guidance from the PowerShell team. By default we enforce these rules.
- [Pester](https://github.com/pester/Pester/wiki) is a framework for running unit tests to execute and validate PowerShell commands. You should test your code. Pester helps you with that. Sample tests included.
- [PSake](http://psake.readthedocs.io/en/latest) is a build automation tool written in PowerShell. Builds glue everything together. Analyze your script, run your unit testing and deploy!
- [PSDeploy](http://ramblingcookiemonster.github.io/PSDeploy/) is a quick and dirty module that simplifies deploymentsis a quick and dirty module that simplifies deployments. If everything checks out, deploy our script to where ever you'd like.

---

## Using PowerRails
There is only 1 cmdlet to learn. **New-PowerRailsItem**
PowerRails is semi-opinioned in the tabs vs spaces discussion. We prefer spaces but I've included
a switch to use tabs if you prefer.


### Create a new script
```powershell
PS> New-PowerRailsItem -name 'GitHubScrapper' -type 'script' -path '.'
```

### Create a new module (type is module by default)
```powershell
PS> New-PowerRailsItem -name 'MakeMyLifeEasier' -path 'c:\scripts\'
```

### Learn more
```powershell
PS> Get-Help New-PowerRailsItem
```

---

### Build Operations
* Test the script via Pester and Script Analyzer
```powershell
PS> .\build.ps1
```

* Test the script with Pester only
```powershell
PS> .\build.ps1 -Task Test
```

* Test the script with Script Analyzer only
```powershell
PS> .\build.ps1 -Task Analyze
```

* Deploy the script via PSDeploy (runs all tests)
```powershell
PS> .\build.ps1 -Task Deploy
```
---


This module was inspired by the post by [Dev Black Ops](https://devblackops.io/building-a-simple-release-pipeline-in-powershell-using-psake-pester-and-psdeploy/)
Great read. Highly recommended.

Big thanks to FreePik for the [logo]('http://www.freepik.com/free-photos-vectors/logo').

## Don't forget to star this project if you like it!