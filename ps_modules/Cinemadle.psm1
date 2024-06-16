function Invoke-Build() {
    <#
        .DESCRIPTION
            Updates packages and builds a flutter project

        .SYNOPSIS
            Builds a flutter project

        .PARAMETER SkipBuildRunner
            Skips the dart build_runner
            step of the build

        .PARAMETER Release
            Indicates this should be a release build
    #>
    [CmdletBinding()]
    [OutputType()]
    param(
        [switch]$SkipBuildRunner,
        [switch]$Release
    )

    Process {
        flutter pub get

        if (-not $SkipBuildRunner) {
            dart run build_runner clean
            dart run build_runner build --delete-conflicting-outputs
        }

        if ($Release) {
            flutter build web --release --source-maps
        } else {
            flutter build web --source-maps
        }

        if (Test-Path -Path '.\build\web\flutter.js' -PathType Leaf) {
            $content = Get-Content -Path '.\build\web\flutter.js'
            $newFile = [string]::Empty
            $content | ForEach-Object {
                if (-not ($_ -Match "//# source*")) {
                    $newFile += $_ + [Environment]::NewLine
                }
            }

            $newFile | Out-File -FilePath '.\build\web\flutter.js'
        }
    }
}

function Test-StartingDirectory() {
    <#
        .DESCRIPTION
            Ensures the current directory is
            the project root and returns false
            if the directory is incorrect

        .SYNOPSIS
            Ensures the current directory is
            the project root
    #>

    [CmdletBinding()]
    [OutputType([bool])]
    param()

    Begin {
        $folder = [IO.Path]::GetFilename((Get-Location).Path)
        $valid = $true
    }

    Process {
        if ($folder -ne 'cinemadle') {
            $valid = $false
        }
    }

    End {
        return $valid
    }
}

function Test-CanSetStartingDirectory() {
    <#
        .DESCRIPTION
            Determines if the script can
            set the correct starting directory,
            returning the path if it can

        .SYNOPSIS
            Determines if the script can
            set the correct starting directory
    #>

    [CmdletBinding()]
    [OutputType([string])]
    param()

    Begin {
        $folder = (Get-Location).Path
        $valid = [string]::Empty
    }

    Process {
        while ($null -ne $folder) {
            if ([IO.Path]::GetFilename($folder) -eq 'cinemadle') {
                $valid = $folder
                break
            } else {
                $folder = [IO.Directory]::GetParent($folder)
            }
        }
    }

    End {
        return $valid
    }
}

function Test-NecessaryCommands() {
    <#
        .DESCRIPTION
            Ensures the flutter and dart
            commands are available on the system
            and returns false if they are not

        .SYNOPSIS
            Ensures the necessary commands
            are available
    #>

    [CmdletBinding()]
    [OutputType([bool])]
    param()

    Begin {
        $dart = Get-Command -Name dart -ErrorAction SilentlyContinue
        $flutter = Get-Command -Name flutter -ErrorAction SilentlyContinue
        $valid = $true
    }

    Process {
        if (($null -eq $dart) -or ($null -eq $flutter)) {
            $valid = $false
        }
    }

    End {
        return $valid
    }
}

function Invoke-BuildProject() {
    <#
        .DESCRIPTION
            Builds the project,
            including the nested packages
            if desired and a clean

        .SYNOPSIS
            Builds the project

        .PARAMETER IncludePackages
            Indicates the nested packages
            should be built

        .PARAMETER SkipBuildRunner
            Skips the dart build_runner
            step

        .PARAMETER IncludeClean
            Includes the flutter clean step

        .PARAMETER Release
            Generate a release build
    #>

    [CmdletBinding()]
    [OutputType()]
    param(
        [switch]$IncludePackages,
        [switch]$SkipBuildRunner,
        [switch]$IncludeClean,
        [switch]$Release
    )

    Begin {
        $startingDirectory = (Get-Location).Path
        $valid = Test-StartingDirectory
        $projectRoot = Test-CanSetStartingDirectory

        if (-not $valid) {
            if ([string]::IsNullOrEmpty($projectRoot)) {
                Write-Output -InputObject 'Please run this command from the cinemadle project root'
                return
            }

            Set-Location -Path $projectRoot
        }

        $valid = Test-NecessaryCommands

        if (-not $valid) {
            Write-Output -InputObject 'Please install flutter before attempting to build.'
        }
    }

    Process {
        if ($IncludeClean) {
            flutter clean
        }

        if ($IncludePackages -and (Test-Path -Path '.\packages' -PathType Container)) {
            Set-Location -Path '.\packages'

            foreach ($package in Get-ChildItem) {
                Set-Location -Path $package.Name
                if ($IncludeClean) {
                    flutter clean
                }

                flutter pub get

                if (-not $SkipBuildRunner) {
                    dart run build_runner clean
                    dart run build_runner build --delete-conflicting-outputs
                }

                Set-Location -Path '..\'
            }

            Set-Location '..\'
        }

        Invoke-Build -Release:$Release -SkipBuildRunner:$SkipBuildRunner
    }

    End {
        Set-Location -Path $startingDirectory
    }
}

function Invoke-HostBuild() {
    <#
        .DESCRIPTION
            Hosts the built web project
            locally

        .SYNOPSIS
            Hosts the built web project
            locally

        .PARAMETER Port
            Which port to host on
    #>

    [CmdletBinding()]
    [OutputType()]
    param(
        [string]$Port = '8080'
    )

    Begin {
        $valid = Test-StartingDirectory
        $projectRoot = Test-CanSetStartingDirectory

        if (-not $valid) {
            if ([string]::IsNullOrEmpty($projectRoot)) {
                Write-Output -InputObject 'Please run this command from the cinemadle project root'
                return
            }

            Set-Location -Path $projectRoot
        }

        $p2 = Get-Command -Name python -ErrorAction SilentlyContinue
        $p3 = Get-Command -Name python3 -ErrorAction SilentlyContinue
        if (($null -eq $p2) -and ($null -eq $p3)) {
            Write-Output -InputObject 'Please install python.'
            return
        }
    }

    Process {
        if ($null -ne $p2) {
            python -m http.server $Port -d '.\build\web'
        } else {
            python3 -m http.server $Port -d '.\build\web'
        }
    }
}

function Get-ReleaseVersion() {
    <#
        .SYNOPSIS
            Picks the next release version

        .DESCRIPTION
            Increments the release version by one
            and returns it
    #>

    [CmdletBinding()]
    [OutputType([string])]
    param()

    Begin {
        $ghCli = Get-Command -Name gh -ErrorAction SilentlyContinue
        if ($null -eq $ghCli) {
            Write-Error -Message 'This cmdlet requires the gh cli tool.'
            exit 1
        }

        $valid = Test-StartingDirectory
        $projectRoot = Test-CanSetStartingDirectory

        if (-not $valid) {
            if ([string]::IsNullOrEmpty($projectRoot)) {
                Write-Error -InputObject 'Please run this command from the cinemadle project root'
                exit 1
            }

            Set-Location -Path $projectRoot
        }

        [string]$releaseVersion = [string]::Empty
    }

    Process {
        [string]$lastRelease = (gh release list --json tagName | ConvertFrom-Json | Select-Object -First 1).tagName
        [string[]]$releaseParts = $lastRelease -Split '\.'

        [int]$lastNumber = $releaseParts | Select-Object -Last 1
        $lastNumber += 1
        $releaseParts[$releaseParts.Length - 1] = $lastNumber

        $releaseVersion = $releaseParts -Join '.'

        Set-PubspecVersion -Version $releaseVersion
    }

    End {
        return $releaseVersion
    }
}

function Set-PubspecVersion() {
    <#
        .SYNOPSIS
            Updates the pubspec.yaml
            version

        .DESCRIPTION
            Updates the pubsepec.yaml
            file to contain the
            new version

        .PARAMETER Version
            Version to set
    #>

    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [string]$Version
    )

    Begin {
        $git = Get-Command -Name git -ErrorAction SilentlyContinue
        if ($null -eq $git) {
            Write-Error -Message 'This cmdlet requires the git cli.'
            exit 1
        }

        $valid = Test-StartingDirectory
        $projectRoot = Test-CanSetStartingDirectory

        if (-not $valid) {
            if ([string]::IsNullOrEmpty($projectRoot)) {
                Write-Error -InputObject 'Please run this command from the cinemadle project root'
                exit 1
            }

            Set-Location -Path $projectRoot
        }

        [string]$v = $releaseVersion

        if ($v.StartsWith('v')) {
            $v = $v.Substring(1)
        }
    }

    Process {
        [string[]]$pubspec = [IO.File]::ReadAllLines('pubspec.yaml')
        [string[]]$modified = @()
        [bool]$dirty = $False
        foreach($line in $pubspec) {
            if ($line -Like 'version: *' -and (-not ($line -like "version: $v+0*"))) {
                $modified += "version: $v+0"
                $dirty = $True
            } else {
                $modified += $line
            }
        }

        if ($dirty) {
            [IO.File]::WriteAllLines('pubspec.yaml', $modified)
        }
    }

    End {

    }
}

function Get-ReleaseNotes() {
    <#
        .SYNOPSIS
           Gets the latest release notes

        .DESCRIPTION
            Gets the latest release notes
            from release_notes.txt
    #>

    [CmdletBinding()]
    [OutputType([string])]
    param()

    Begin {
        [string]$releaseNotes = [string]::Empty
    }

    Process {
        while($True) {
            $addition = Read-Host -Prompt 'Enter release addition (''exit'' to end)'

            if ($addition -eq 'exit' -or [string]::IsNullOrEmpty($addition)) {
                break
            }

            $releaseNotes += "- $addition$([Environment]::NewLine)"
        }
    }

    End {
        return $releaseNotes
    }
}

function New-Release() {
    <#
        .SYNOPSIS
            Creates a new release on GitHub

        .DESCRIPTION
            Creates a new release on GitHub
            using the GitHub cli

        .PARAMETER Version
            The version to create

        .PARAMETER ReleaseNotes
            The content of the release notes

        .PARAMETER Prerelease
            Marks this release as a prerelease
    #>

    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(Mandatory = $False)]
        [string]$Version,

        [Parameter(Mandatory = $False)]
        [string]$ReleaseNotes = $null,

        [Parameter(Mandatory = $False)]
        [switch]$Prerelease
    )

    Begin {
        $ghCli = Get-Command -Name gh -ErrorAction SilentlyContinue
        if ($null -eq $ghCli) {
            Write-Error -Message 'This cmdlet requires the gh cli tool.'
            exit 1
        }

        [string]$v = $Version
        if ([string]::IsNullOrEmpty($v)) {
            $v = Get-ReleaseVersion
        }


        [string]$notes = $ReleaseNotes
        [string]$prependToFile = [string]::Empty
        if ([string]::IsNullOrEmpty($notes)) {
            $notes = Get-ReleaseNotes
            [string]$n = [Environment]::NewLine
            $notes = "Cinemadle $v$n${n}Additions:$n${n}$notes$n${n} - ${(Get-Date)}"
            $prependToFile = "$notes-------------------$n$n"
        }

        Write-Output -InputObject "Creating release with notes: $notes"
    }

    Process {
        if (-not ([string]::IsNullOrEmpty($prependToFile))) {
            [string]$oldNotes = [IO.File]::ReadAllText('release_notes.txt')
            $oldNotes = "$prependToFile$oldNotes"

            [IO.File]::WriteAllText('release_notes.txt', $oldNotes)
        }

        git add .
        git commit -m "[skip ci] Creating release $v"
        git push

        if ($Prerelease) {
            gh release create "$v" --latest --notes "$notes" --prerelease
        } else {
            gh release create "$v" --latest --notes "$notes"
        }
    }

    End {

    }
}