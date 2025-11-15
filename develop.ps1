<#
.SYNOPSIS
Provides building and publishing capabilities for the Jupyter Book project.

.DESCRIPTION
This script sets up a development environment for the Jupyter Book project, including
creating a virtual environment, installing dependencies, and building the project. It also
supports publishing the built documentation to GitHub Pages.

.PARAMETER Build
Builds the Jupyter Book documentation.
.PARAMETER Rebuild
Cleans and rebuilds the Jupyter Book documentation.
.PARAMETER Clean
Cleans the build directory.
.PARAMETER Publish
Publishes the built documentation to GitHub Pages.

.EXAMPLE
.\develop.ps1 -Build -Publish

.NOTES
Author: Walter Dal'Maz Silva
Date: November 2025
#>

param (
    [switch]$Build,
    [switch]$Rebuild,
    [switch]$Clean,
    [switch]$Publish
)

##############################################################################
# Globals
##############################################################################

$PROJECT_PATH = "$PSScriptRoot"
$PROJECT_VENV = "$PROJECT_PATH\.venv"
$PYTHON_MIN   = 12

$env:BOOK_DATA = "$PROJECT_PATH\data"

##############################################################################
# Handles Python version
##############################################################################

function Check-HasPython {
    try {
        python --version | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

function Get-PythonMajorVersion {
    return python -c "import sys; print(sys.version_info.major)"
}

function Get-PythonMinorVersion {
    return python -c "import sys; print(sys.version_info.minor)"
}

function Check-HasValidPython {
    if (-not (Check-HasPython)) {
        return $false
    }

    $major = Get-PythonMajorVersion
    $minor = Get-PythonMinorVersion

    if ($major -lt 3) {
        return $false
    }

    if ($major -eq 3 -and $minor -lt $PYTHON_MIN) {
        return $false
    }

    return $true
}

##############################################################################
# Handles environment setup
##############################################################################

function Start-PipInstall() {
    param ( [string[]]$arguments )
    $command = "$PROJECT_VENV\Scripts\python.exe"
    $options = @("-m", "pip", "install") + $arguments
    Start-Process -FilePath $command -ArgumentList $options -NoNewWindow -Wait
}

function Enable-DevelVenv() {
    . "$PROJECT_VENV\Scripts\Activate.ps1"
}

function New-DevEnvironment() {
    python -m venv $PROJECT_VENV

    if (-not (Test-Path $PROJECT_VENV)) {
        Write-Error "Failed to create virtual environment in $PROJECT_VENV"
        exit 1
    }

    Enable-DevelVenv
    Start-PipInstall @("--upgrade", "pip")
    Start-PipInstall @("-r", "pinned.txt")

    try {
        Start-PipInstall @("-e", "..[pdftools,extras]")
    }
    catch {
        Write-Error "Not working under Majordome."
    }
}

##############################################################################
# Main
##############################################################################

function Main() {
    if (-not (Check-HasValidPython)) {
        Write-Error "Python >= 3.$PYTHON_MIN is required but not found"
        exit 1
    }

    if (-not (Test-Path $PROJECT_VENV)) {
        New-DevEnvironment
        Write-Output "Virtual environment created in $PROJECT_VENV"
    }
    else {
        Enable-DevelVenv
    }

    $buildDir = "$PROJECT_PATH\_build"

    if ((Test-Path $buildDir) -and ($Rebuild -or $Clean)) {
        Remove-Item -Path $buildDir -Recurse -Force
    }

    if ($Build -or $Rebuild) {
        $options = @("build", "$PROJECT_PATH", "--builder", "html")
        Start-Process -FilePath jupyter-book -ArgumentList $options -NoNewWindow -Wait
    }

    if ((Test-Path $buildDir) -and $Publish) {
        $options = @("-n", "-p", "-f", "$buildDir/html")
        Start-Process -FilePath ghp-import -ArgumentList $options -NoNewWindow -Wait
    }
}

Main

##############################################################################
# EOF
##############################################################################