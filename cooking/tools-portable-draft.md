# Kompanion

A portable toolbox setup for working in Scientific Computing under Windows.

**NOTE:** before using this, please be aware that your company/university probably forbids the use of portable tools outside sandboxed systems. It is your responsability to use this toolbox only in systems where you are allowed to. The developper does not hold any resposibility on your failure to respect your local regulations.

Please notice that for teaching purposes there is also a simpler [Julia101](https://github.com/wallytutor/julia101) environment setup. This repository is mostly focused on the conception of a production working environment.

## How does it work?

*Kompanion* is intended to be used as a portable environment with *almost* all batteries included. Applications are placed under `bin/` directory and all configuration of paths and other required environment variables are provided by *batch scripts*. Everything revolves around [VS Code](https://code.visualstudio.com/download); you launch the editor through a dedicated script and everything else is available in its terminal. That said, the whole of the ecosystem is command line based, but this is scientific computing, if you don't know command line you are in the wrong job. It is intended to leave minimal track on host system (probably a few files and directories on your user home directory or under *AppData*), but this is not enforced in its development, so take care if you are not allowed to execute some software in a given computer.

**NOTE:** by *almost* all batteries included it is meant that all target applications can be deployed by the user with one exception, [Microsoft MPI ](https://learn.microsoft.com/en-us/message-passing-interface/microsoft-mpi). That requires administration rights and unless you have it you will need to ask your local IT for installing it. If your applications do not require parallel computing, then you have everything you need here.

## Known limitations

- As already stated, MPI support still requires admin rights.

- You cannot pin the editor to the taskbar (because of how sourcing environment works), but you can create a shortcut to `kode.vbs` in your desktop.

## Tested packages

The above was tested with the following versions:

| Group    | Software       | Version               |
|:--------:|----------------|:----------------------|
| Base     | VS Code        | 1.96.4                |
| Base     | Neovim         | 0.10.4                |
| Base     | Notepad++      | 8.7.8                 |
| Base     | Git            | 2.47.1.2              |
| Base     | MSYS2          | 20250221              |
| Language | Julia          | 1.11.3                |
| Language | WinPython      | 3.13.1.0slim          |
| Language | Octave         | 9.3.0                 |
| Language | Ruby           | 3.3.7-1               |
| Language | Rust           | 1.85                  |
| Language | Quarto         | 1.6.42                |
| Language | LISP (Portacle)| 1.5.0.2712            |
| Extra    | MiKTeX         | 24.1                  |
| Extra    | JabRef         | 5.15                  |
| Extra    | pandoc         | 3.6.2                 |
| Extra    | inkscape       | 1.4                   |
| Extra    | Fiji           | 1.54p (Java 1.8.0_322)|
| Extra    | FreeCAD        | 1.0.0                 |
| Extra    | Blender        | 4.3.2                 |
| Extra    | SALOME         | 9.13.0                |
| Extra    | gmsh           | 4.13.1                |
| Extra    | MeshLab        | 2023.12d              |
| Extra    | ParaView       | 5.13.2-MPI            |
| Extra    | gnuplot        | 6.0.0                 |
| Extra    | Elmer          | 9.0                   |
| Extra    | Scilab         | 2025.1.0              |
| Extra    | SU2            | 8.1.0-mpi             |
| Extra    | RadCal         | 2.0                   |
| Extra    | iperf          | 3.18                  |
| Extra    | MFiX           | 24.4.1                |
| Extra    | Zettlr         | 3.4.3                 |
| Extra    | Cantera        | Upcoming...           |
| Extra    | CasADi         | Upcoming...           |
| Extra    | DualSPHysics   | Upcoming...           |
| Extra    | DWSIM          | Upcoming...           |
| Extra    | FreeFEM++      | Upcoming...           |
| Extra    | LAMMPS         | Upcoming...           |
| Extra    | OpenModelica   | Upcoming...           |

# General setup

First of all, [download](https://github.com/wallytutor/Kompanion/archive/refs/heads/main.zip) or clone this repository somewhere in the target computer. You can consider using [GitHub Desktop](https://github.com/apps/desktop) at this stage, assuming you do not have Git yet or you lack the skills to use it. Unless stated otherwise, everything that follows here is performed under `bin/` directory, so we refer to its sub-directoires directly, *i.e.* `downloads/` means `bin/downloads/`.

**IMPORTANT:** After installing `VS Code`, do **NOT** enable its [portable mode](https://code.visualstudio.com/docs/editor/portable) because the VBS file for launching it will point to a specific user-data folder.

**NOTE:** After finishing the configuration in the following sub-sections, you can test the setup by launching VS Code with prototype launcher `code.bat`. If everything is properly set, the above applications will be available in the command prompt of the editor. This script is provided only for testing (because it will show all the startup logs). The production version is `kode.vbs` in the repository root directory.

## Workflow explained

This section illustrates the generalities of how do integrate portable software in the toolbox. Before proceding with any installation, make sure to read all the elements provided below; simply trying to follow instructions in a step-by-step fashion will certainly lead to failure and frustration.

**IMPORTANT:** You need to be aware that there are two common practices of compressing a portable software: (1) some editors place everything in a directory and compress the directory, while others (2) pack everything under the root of the compressed file. Windows built-in system allows your to navigate compressed files as part of the filesystem, so inspect which of the above methods was used. If the later is detected, take care to select the right option to ensure the contents are extracted to a new directory. Several packages are stored directly at *zip* root and that may be messy to clean if extracted without the above precautions.

**IMPORTANT:** Since setting up the environment requires editing [batch scripts](https://www.tutorialspoint.com/batch_script/index.htm), be aware that to open them you cannot *click* the file, but *right-click* and *edit*, as Windows see these as executables. In these files, lines starting by `@REM` are seem as comments and generally explain something about what follow them.

For each of the applications you will install, make sure to perform the following generic steps:

1. Download the portable version of the application, generally a `.zip` compressed file, and save it to `downloads/`. Sometimes the normal installer of an application already supports portable mode.

2. Extract the compressed file to a dedicated folder under `apps/` directory.

3. Configure the application in a dedicated script under `scripts/` directory.

4. For non-base applications, you might need to add the script to `activate.bat`, which is responsible by making sure all the executables may be found in your environment.

## Initial setup

These are the required steps to get your system working for the first time:

1. Go to VS Code [download page](https://code.visualstudio.com/download) and get the `.zip` version for `x64` system (`Arm64` is not supported here). Extract it to `apps/` and copy the name of VS Code directory to edit `scripts/base-vscode.bat` variable `VSCODE_DIR`.

2. Go to Git [download page](https://git-scm.com/download/win) and select *64-bit Git for Windows Portable*, download it and move the file to `downloads`. Notice that this is not a compressed file *per se*, but it is desguised as an executable. Double-click it and accept the default `PortableGit` installation directory. After extraction finishes, move it to `apps/`; there is nothing left to configure, but you can inspect `scripts/base-git.bat`.

3. (optional) Go to Neovim [download page](https://github.com/neovim/neovim/releases) and select the zip version for Windows. Follow the standard extration-installation procedure explained above. **Note:** the automation of configuration path for `.vim/` directory is yet to be done.

## MSYS2

MSYS2 environment is useful for developing native Windows applications and programming in languages as C, C++, Fortran, and Rust. Kompanion VS Code configuration will automatically include this environment to its available terminal lists, what might fail if you do not install it. To get it working do the following:

- Go to MSYS2 [page](https://www.msys2.org/) and save the installer to `downloads`.

- Run the installer and change installation path to point to `apps/msys64` instead of the default `C:/msys64` (requiring admin rights).

- Once finished, launch an [UCRT64](https://www.msys2.org/docs/environments/) environment as proposed in the installation guide. Install at least the following:

```bash
pacman -S \
    mingw-w64-ucrt-x86_64-toolchain \
    mingw-w64-ucrt-x86_64-binutils \
    mingw-w64-ucrt-x86_64-gcc \
    mingw-w64-ucrt-x86_64-gcc-fortran
```

- Full package list is provided [here](https://packages.msys2.org/queue).

# Programming languages

The following provides instructions for some languages you might wish to have fully integrated to your environment. For lower level languages, please consider using MSYS2 as described in its dedicated section.

It is strongly recommended to install [Quarto](https://quarto.org/docs/download/) as a supporting tool for publishing reports from Julia and Python. Please notice that Jupyter environment handled automatically by Python post-installation. Upon the first time you launch Julia, it will globally install IJulia and Pluto for the same end.

**Warning:** for now having both Rust and Octave fully operational in command-line is not working. This should not be a problem as Octave can be launched with its user-interface and that remain the most popular/recommended way of using it.

**Warning:** For a fully operational *Jupyter notebook* environment, other the LaTeX support discussed in its dedicatet section, you also need both `pandoc` and `inkscape`.

## Julia

Go to Julia [download page](https://julialang.org/downloads/) and select the latest stable Windows 64-bit portable version. Move the file to `downloads` and extract it, then move the resulting folder to `apps`. You might need to edit `scripts/base-julia.bat`. Notice that in this file it is not the extracted directory name that must be provided, but Julia semantic version.

## Python

Go to WinPython [download page](https://github.com/winpython/winpython/releases) and find the latest version taged with a *Latest* green flag (avoir *Pre-release* versions on top). Expand the *Assets* and download the `.exe` version (also a disguised compressed file). Follow steps similar to Git above, but notice that WinPython will extract directly to `downloads`. After moving the directory to `apps`, set the directory variable in `scripts/base-python.bat`.

## Octave

Go to Octave [download page](https://octave.org/download) and identify the `.zip` package for `w64`. Proceed with edition of `scripts/base-octave.bat` as you have done so far.

## Ruby

Go to Ruby [download page](https://rubyinstaller.org/downloads/) and identify the `Devkit` package for `x64`. During installation change the path to point to `apps/` and unselect the options to associate extensions and adding to the path. Proceed with edition of `scripts/base-octave.bat` as you have done so far.

## Rust

To use Rust you must have followed the instllation instructions for [MSYS2](setup-general.md); package `mingw-w64-x86_64-binutils` must have been installed. Next, download the static GNU [Rust MSI installer](https://static.rust-lang.org/dist/rust-1.85.1-x86_64-pc-windows-gnu.msi) and execute it; chose advanced options to be able to select installation for the current user only. Select to install under `apps\rust-stable-gnu-1.85` directory. Check `base-rust.bat` for environment setup.

## LISP

LISP is supported through [Portacle](https://portacle.github.io/). Instead of right-clicking and installing the executable, Shift-click and select to extract the contents; place the resulting `portacle` directory under `bin` and verify the batch scripts are properly configured for your version.

## LaTeX and related

Although LaTeX is not mandatory, it is highly encouraged; otherwise, what is the point of doing any scientific computing and not publishing its results?

- Start by following the instructions provided [here](https://miktex.org/howto/portable-edition) to install MikTeX. Point the installation to a directory `miktex-portable` under `apps` and select *on-the-fly* installation of new packages.

- Consider installing the following additional software:

    - [JabRef](https://www.fosshub.com/JabRef.html)
    - [pandoc](https://github.com/jgm/pandoc/releases)
    - [inkscape](https://inkscape.org/release/1.4/windows/64-bit/)

- Globally install [`pip install Pygments`](https://pygments.org/) for enabling syntax highlight in LaTeX using `minted`; that is the most flexible highlighting method for adding code snippets to your documents.

- Also consider installing extension [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) for automatic compilation in editor with built-in PDF visualization.

To append to `TEXMF` variable one can use the MiKTeX Console graphical interface and under `Settings > Directories` navigate and select the local path.

<!-- Alternativelly on can add to the `[Paths]` section of  `bin/apps/miktex-portable/texmfs/install/miktex/config/miktexstartup.ini` a line as `CommonRoots=C:/Path/To/Kompanion/bin/data/texmf` pointing to a directory implementing the project [TeX Directory Structure](https://miktex.org/kb/tds). You might need to add the section to the file, as `[Paths]` is not present in the as-installed condition. -->

If you prefer a dedicated LaTeX editor, you may wish to install [texstudio](https://www.texstudio.org/#download); some configuration of paths with the application may be required as it is not directly integrated to this environment.

# Software specific instructions

### DualSPHysics

For [DualSPHysics](https://dual.sphysics.org/downloads/) one might also want to install [this FreeCAD addon](https://github.com/DualSPHysics/DesignSPHysics) and [this Blender addon](https://github.com/EPhysLab-UVigo/VisualSPHysics).

### MFiX

This package is [installed](https://mfix.netl.doe.gov/products/mfix/download/) in a separate environment and not added to the toolbox path; that is because other Python environments could interact with each other and lead to unpredictable behavior. The following instructions are provided:

- Install [miniforge3](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Windows-x86_64.exe) under the `apps/` directory.

- Launch miniforge console by running:

```shell
%windir%\system32\cmd.exe "/K" ^
    %~dp0\miniforge3\Scripts\activate.bat ^
    %~dp0\miniforge3
```

- Go to the [downloads](https://mfix.netl.doe.gov/mfix/download-mfix) page, login and copy the personal installation command that looks like the following:

```shell
conda create -n mfix-<version> ^
    mfix==<version>            ^
    mfix-doc==<version>        ^
    mfix-gui==<version>        ^
    mfix-solver==<version>     ^
    mfix-src==<version>        ^
    -c conda-forge -c          ^
    https://mfix.netl.doe.gov/s3/<personal-token>//conda/dist
```

- To run the software activate the created environment and call its executable:

```shell
conda activate mfix-<version>
mfix
```

# Troubleshooting

## Julia

For the proper functioning of Kompanion, both [Pluto](https://plutojl.org/) and [IJulia](https://julialang.github.io/IJulia.jl/stable/) need to be available. Generally they should be automatically installed when first launching Julia, but that may fail for many reasons and you might need to manually install them.

## Jupyter lab

Using `WPY64-31310` some warnings/errors were found when launching Jupyterlab. Apparently some packages are missing so that it can work with its full capabilities. You may overcome this by manually installing:

- ipyparallel
- nbclassic
- voila

## gmsh

Because it was chosen that SDK version of gmsh was more adapted to integrate Kompanion, if you want to be able to pin the executable to your taskbar you need to copy the DLL from its `lib/` directory to `bin/`. If you think you will not need Python/Julia interfaces of gmsh, then you can move the DLL instead to save ~80MB of disk.

## Graphviz

If the first time you run `dot` you get a message as

```text
There is no layout engine support for "dot"
Perhaps "dot -c" needs to be run (with installer's privileges) to register the plugins?
```

Simply run `dot -c` as suggested and it should work fine (without admin privileges).

## VS Code

- If installing local extensions (such as elmer-sif provided herein), consider using [Developer: Install Extension from Location](https://github.com/microsoft/vscode/issues/178667#issuecomment-1495625943) instead of placing it under `.vscode/extensions` manually.

- For installing extensions from within a VSCode terminal, rather than the main executable one must use `%VSCODE_HOME%\bin\Code.cmd`. Currently, Visual Studio Code's command-line interface doesn't directly support installing extensions from a local directory without packaging them into .vsix files. The recommended method is to package your extension into a .vsix file using vsce and then install it.
