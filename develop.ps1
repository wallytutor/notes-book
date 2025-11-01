# develop.ps1

param (
    [switch]$Build,
    [switch]$Rebuild,
    [switch]$Clean
)

##############################################################################
# Globals
##############################################################################

$PROJECT_PATH = "$PSScriptRoot"
$PROJECT_VENV = "$PROJECT_PATH\.venv"
$PYTHON_MIN   = 12

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
    Start-PipInstall @("-r", "requirements.txt")
}

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

    $build = "$PROJECT_PATH\_build"

    if ((Test-Path $build) -and ($Rebuild -or $Clean)) {
        Remove-Item -Path $build -Recurse -Force
    }

    if ($Build -or $Rebuild) {
        $options = @("build", ".")
        Start-Process -FilePath jupyter-book -ArgumentList $options -NoNewWindow -Wait
    }
}

Main
