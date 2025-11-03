#!/usr/bin/env bash

##############################################################################
# Globals
##############################################################################

PROJECT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_VENV="$PROJECT_PATH/.venv"
PYTHON_MIN=12

export BOOK_DATA="$PROJECT_PATH/data"

##############################################################################
# Handles Python version
##############################################################################

function check_haspython() {
    if ! command -v python3 &> /dev/null; then
        return 1
    else
        return 0
    fi
}

function get_python_major_version() {
    python -c "import sys; print(sys.version_info.major)"
}

function get_python_minor_version() {
    python -c "import sys; print(sys.version_info.minor)"
}

function check_has_valid_python() {
    if ! check_haspython; then
        return 1
    fi

    local major=$(get_python_major_version)
    local minor=$(get_python_minor_version)

    if [ "$major" -lt 3 ]; then
        return 1
    fi

    if [ "$major" -eq 3 ] && [ "$minor" -lt "$PYTHON_MIN" ]; then
        return 1
    fi

    return 0
}

##############################################################################
# Handles environment setup
##############################################################################

function start_pip_install() {
    "$PROJECT_VENV/bin/python" -m pip install "$@"
}

function enable_devel_venv() {
    . "$PROJECT_VENV/bin/activate"
}

function new_dev_environment() {
    python -m venv $PROJECT_VENV

    if [ ! -d "$PROJECT_VENV" ]; then
        echo "Failed to create virtual environment in $PROJECT_VENV"
        exit 1
    fi

    enable_devel_venv
    start_pip_install --upgrade pip
    start_pip_install -r requirements.txt
}

##############################################################################
# Main
##############################################################################

function main() {
    if [ ! check_has_valid_python ]; then
        echo "Python >= 3.$PYTHON_MIN is required but not found"
        exit 1
    fi

    if [ ! -d "$PROJECT_VENV" ]; then
        new_dev_environment
        echo "Virtual environment created in $PROJECT_VENV"
    else
        enable_devel_venv
    fi

    local buildDir="$PROJECT_PATH/_build"

    local Build=0
    local Rebuild=0
    local Clean=0
    local Publish=0

    for arg in "$@"; do
        case $arg in
            --build)
                Build=1
                ;;
            --rebuild)
                Rebuild=1
                ;;
            --clean)
                Clean=1
                ;;
            --publish)
                Publish=1
                ;;
            *)
                echo "Unknown argument: $arg"
                exit 1
                ;;
        esac
    done

    if [ -d "$buildDir" ] && [ "$Rebuild" -eq 1 ] || [ "$Clean" -eq 1 ]; then
        rm -rf $buildDir
    fi

    if [ "$Build" -eq 1 ] || [ "$Rebuild" -eq 1 ]; then
        jupyter-book build "$PROJECT_PATH" --builder html
    fi

    if [ -d "$buildDir" ] && [ "$Publish" -eq 1 ]; then
        ghp-import -n -p -f "$buildDir/html"
    fi
}

main "$@"

##############################################################################
# EOF
##############################################################################