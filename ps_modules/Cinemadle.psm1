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
            flutter build web --release --source-maps --web-renderer canvaskit
        } else {
            flutter build web --web-renderer canvaskit --source-maps
        }

        if (Test-Path -Path '.\build\web\flutter.js' -PathType Leaf) {
            $content = Get-Content -Path '.\build\web\flutter.js'
            $lines = ($content | Measure-Object -Line).Lines
            $i = 1
            $newFile = [string]::Empty
            foreach($line in $content) {
                if ($i -ne ($lines - 1)) {
                    $newFile += $line
                    $newFile += [Environment]::NewLine
                }

                $i += 1
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