# Scientific programming


This page provides access to programming learning materials and related links. If this subject is new to you, to be able to successfully follow the contents you might learn a bit about the environment we will use, [VS Code](https://code.visualstudio.com/) and the minimum about [command prompt](system-windows.md). If you are planning to start a career in scientific computing, there is also a short introduction [here](introduction.md) that might help you find your way through this broad field.


## Coding practices


It is not worth learning any programming before being introduced to the good practices. Many programmers I know write *garbage that works for them only*. It is impossible to have a healthy collaboration if code is not standardized, reason why I place this highly biased introduction here.

One of the reasons [Guido van Rossum](https://en.wikipedia.org/wiki/Guido_van_Rossum) created Python is because he wanted code to be readable. You should be able to guess what some code is doing even without specific technical knowledge about the language. This is probably the mean feature that made its creation so popular in the scientific world.

Although they are applicable to Python, the practices recommended in the famous [PEP8](https://peps.python.org/pep-0008/) can be extended to other languages, including Julia. You should **read PEP8 religiously**. That document describes how to write clean and maintainable Python code. When transposing that to Julia, the minimum you are expected to do is:

- lines are limited to 79 characters
- use spaces around all operators
- consistent indentation with spaces
- blank lines around structural blocks
- lower case variable names
- Pascal-case structure names
- use underscore to separate words
- document functions properly

When you code, remember that most of the time what you are doing will be reviewed/used by somebody else and that person might not be in the mood to decipher the cryptic code you wrote; it that person is myself, **I will promptly refuse to help you** with badly written code. For newcomers, it is always better to talk about this before you write your first lines because once you stick to bad practices you will hardly ever leave them. Before you write something new, check if your ideas are also consistent with [PEP20](https://peps.python.org/pep-0020/).

Julia has its own [stylistic conventions](https://docs.julialang.org/en/v1/manual/variables/#Stylistic-Conventions) that are simpler than PEP8; the main differences are the way to name functions (it recommends to *glue* words and use no underscore) and the *exclamation mark !* indicating a function modifies it(s) argument(s). For function naming you may chose to stick to PEP8 recommendation, what is my personal choice. The detailed document is found [here](https://docs.julialang.org/en/v1/manual/style-guide/).

Python code documentation is generally done with [Sphinx](https://www.sphinx-doc.org/en/master/). Julia has its own [syntax](https://docs.julialang.org/en/v1/manual/documentation/#Syntax-Guide) which can be used to generate package documentation with help of [Documenter.jl](https://documenter.juliadocs.org/stable/).

**Important:** Julia supports [Unicode input](https://docs.julialang.org/en/v1/manual/unicode-input/), but its use is highly discouraged in modules. Unicode characters are better suited to write application scripts such as notebooks (in Pluto or Jupyter).


## Scientific publishing


The following tools might be of interest for creating scientific content with embedded code.

- [Jupytext documentation](https://jupytext.readthedocs.io/en/latest/)
- [Jupyter Book](https://jupyterbook.org/en/stable/intro.html)
- [Weave.jl - Scientific Reports Using Julia](https://weavejl.mpastell.com/stable/)
- [Franklin - Building static websites in Julia](https://franklinjl.org/)
- [Pluto.jl - interactive Julia programming environment](https://plutojl.org/)
- [Quarto](https://quarto.org/)


## Visual Studio Code


If you are reading this, you are probably using [VS Code](https://code.visualstudio.com/) for the first time or need a refresher! VS Code is Microsoft's open source text editor that has become the most popular editor in the past decade. It is portable (meaning it works in Windows, Linux, and Mac) and relatively light-weight (it won't use all you RAM as some proprietary tools would do). There are a few shortcuts you might want to keep in mind for using this tool in an efficient manner:

- `Ctrl+J`: show/hide the terminal
- `Ctrl+B`: show/hide the project tree
- `Ctrl+Shift+V`: display this file in rendered mode
- `Ctrl+Shift+P`: access the command pallet
- `Ctrl+K Ctrl+T`: change color theme
- `Alt+Z`: toggle column wrapping

A few more tips concerning the terminal:

- `Ctrl+L` gives you a clean terminal (also works inside Julia prompt)
- `Ctrl+D` breaks a program execution (*i.e.* use to quit Julia prompt)

If you copied a command from a tutorial, you **CANNOT** use `Ctrl+V` to paste it into the terminal; in Windows simply right-click the command prompt and it will paste the copied contents. Linux users can `Ctrl+Shift+V` instead.

Notice that `Ctrl+M` will toggle the visibility of the integrated terminal; if you accidentally press it, autocompletion will stop working in terminal. Just press it again and normal behavior will be recovered.

VS Code supports a number of extensions to facilitate coding and data analysis, among other tasks. Local (user-created) extensions can be manually installed by placing their folder under `%USERPROFILE%/.vscode/extensions` or in the equivalent directory documented [here](https://code.visualstudio.com/docs/editor/extension-marketplace#_where-are-extensions-installed). Below you find my recommended extensions for different purposes and languages.


## VS Code extensions


The following extensions are recommended.

- General purpose:

    - [ms-vscode.PowerShell](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
    - [ms-vscode-remote.remote-ssh](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)
    - [GitHub.copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
    - [ukoloff.win-ca](https://marketplace.visualstudio.com/items?itemName=ukoloff.win-ca)
    - [vscode-icons-team.vscode-icons](https://marketplace.visualstudio.com/items?itemName=vscode-icons-team.vscode-icons)
    - [ritwickdey.LiveServer](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer)
    - [dnut.rewrap-revived](https://marketplace.visualstudio.com/items?itemName=dnut.rewrap-revived)

- Python development:

    - [ms-python.python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
    - [ms-toolsai.jupyter](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter)
    - [tamasfe.even-better-toml](https://marketplace.visualstudio.com/items?itemName=tamasfe.even-better-toml)

- Other languages support

    - [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
    - [Erlang](https://marketplace.visualstudio.com/items?itemName=pgourlain.erlang)
    - [Gmsh](https://marketplace.visualstudio.com/items?itemName=Bertrand-Thierry.vscode-gmsh)
    - [Julia](https://marketplace.visualstudio.com/items?itemName=julialang.language-julia)
    - [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop)
    - [Matlab](https://marketplace.visualstudio.com/items?itemName=MathWorks.language-matlab)
    - [Modern Fortran](https://marketplace.visualstudio.com/items?itemName=fortran-lang.linter-gfortran)
    - [Quarto](https://marketplace.visualstudio.com/items?itemName=quarto.quarto)
    - [Ruby](https://marketplace.visualstudio.com/items?itemName=Shopify.ruby-extensions-pack)

- Data inspection:

    - [Data Wrangler](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.datawrangler)
    - [Excel Viewer](https://marketplace.visualstudio.com/items?itemName=GrapeCity.gc-excelviewer)
    - [Rainbow CSV](https://marketplace.visualstudio.com/items?itemName=mechatroner.rainbow-csv)

- VS Code themes:

    - [lakshits11.ayu-monokai](https://marketplace.visualstudio.com/items?itemName=lakshits11.ayu-monokai)
    - [cameronbieganek.julia-color-themes](https://marketplace.visualstudio.com/items?itemName=cameronbieganek.julia-color-themes)
    - [GitHub.github-vscode-theme](https://marketplace.visualstudio.com/items?itemName=GitHub.github-vscode-theme)

I have also developed a few (drag-and-drop) extensions; in the future I plan to provided them through the extension manager.

- [wallytutor/elmer-sif-vscode: VS Code extension for Elmer Multiphysics SIF](https://github.com/wallytutor/elmer-sif-vscode)
