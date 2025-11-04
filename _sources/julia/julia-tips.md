# Julia tips


## Going further


- [Julia Documentation](https://docs.julialang.org/en/v1/): in this page you find the whole documentation of Julia.

    - Generally after taking this short course you should be able to navigate and understand a good part of the [Manual](https://docs.julialang.org/en/v1/manual/getting-started/).

    - It is also interesting to check-out [Base](https://docs.julialang.org/en/v1/base/base/) to explore what is built-in to Julia and avoid reinventing the wheel!

    - Notice that not everything *built-in* to Julia is available under `Base` and some functionalities are available in the [Standard Library](https://docs.julialang.org/en/v1/stdlib/ArgTools/) which consists of *built-in* packages that are shipped with Julia.

- [Julia Academy](https://juliaacademy.com/): you can find a few courses conceived by important Julia community members in this page. The [Introduction to Julia](https://juliaacademy.com/p/intro-to-julia) is a longer version of what you learned here.

- [Python](https://www.python.org/): Julia does not replace Python (yet) because it is much younger. We have seen how to call Python from Julia and the computational scientist should be well versed in both languages as of today.

- [Julia Packages](https://juliapackages.com/): the ecosystem of Julia is reaching a good maturity level and you can explore it to find packages suiting your needs in this page.

- [Exercism Julia Track](https://exercism.org/tracks/julia): this page proposes learning through exercises, it is good starting point to get the fundamentals of algorithmic thinking.

- [Julia Data Science](https://juliadatascience.io/): a very straightforward book on Data Science in Julia; you can learn more about tabular data and review some plotting with Makie here.

- [Introduction to Computational Thinking](https://computationalthinking.mit.edu/Fall24/): this MIT course by Julia's creator [Dr. Alan Edelman](https://math.mit.edu/~edelman/) gives an excellent overview of how powerful the language can be in several scientific domains.

- [SciML Book](https://book.sciml.ai/): this course enters more avanced topics and might be interesting as a final learning resource for those into applied mathematics and numerical simulation.

- [JuliaHub](https://juliahub.com/): this company proposes a cloud platform (non-free) for performing computations with Julia. In its page you find a few useful and good quality learning materials.


## A few Julia organizations


- [SciML](https://sciml.ai/): don't be tricked by its name, its field of application goes way beyond what we understand by Machine Learning. SciML is probably the best curated set of open source scientific tools out there. Take a look at the list of available packages [here](https://docs.sciml.ai/Overview/stable/overview/). This last link is probably the best place to search for a generic package for Scientific Computing.

- [JuMP](https://jump.dev/): it is a *modeling language* for optimization problems inside Julia. It is known to work well with several SciML packages and allows to state problems in a readable way. Its documentation has its own [Getting started with Julia](https://jump.dev/JuMP.jl/stable/tutorials/getting_started/getting_started_with_julia/) that you may use to review this module.

- [JuliaData](https://github.com/JuliaData): all about tabular data and related manipulations. The parents of [DataFrames.jl](https://dataframes.juliadata.org/stable/).

- [Julia Math](https://github.com/JuliaMath): several math-related packages. Most basic users coming from *spreadsheet hell* might be interested in [Polynomials.jl](https://juliamath.github.io/Polynomials.jl/stable/) from this family.

- [JuliaMolsim](https://juliamolsim.github.io/): molecular simulation in Julia, from DFT to Molecular dynamics.


## Getting help in the wild


- [Julialang Discourse](https://discourse.julialang.org/): instead of Stackoverflow, most Julia discussion threads are hosted in this page.

- [Zulipchat Julialang](https://julialang.zulipchat.com/): some discussion (specially regarding development) is hold at Zulipchat.


## Selected Julia packages


### General


- [Julia Programming](https://docs.julialang.org/en/v1/)
- [Graphs.jl](https://juliagraphs.org/Graphs.jl/dev/)
- [Mustache.jl](https://jverzani.github.io/Mustache.jl/dev/)
- [PackageCompiler.jl](https://julialang.github.io/PackageCompiler.jl/stable/index.html)
- [Revise.jl](https://timholy.github.io/Revise.jl/stable/)


### Plotting and graphics


- [Makie.jl](https://docs.makie.org/stable/)
- [Plots.jl](https://docs.juliaplots.org/stable/)
- [Winston.jl](https://winston.readthedocs.io/en/latest/)
- [Luxor.jl](https://juliagraphics.github.io/Luxor.jl/stable/)


### Numerical methods


- [Ferrite.jl](https://ferrite-fem.github.io/Ferrite.jl/stable/)
- [Kinetic.jl](https://xiaotianbai.com/Kinetic.jl/dev/)
- [ModelingToolkit.jl](https://docs.sciml.ai/ModelingToolkit/stable/)
- [Roots.jl](https://juliamath.github.io/Roots.jl/stable/)
- [Symbolics.jl](https://symbolics.juliasymbolics.org/stable/)
- [VoronoiFVM.jl](https://j-fu.github.io/VoronoiFVM.jl/dev/)


### Kinetics and Thermodynamics


- [Catalyst.jl](https://docs.sciml.ai/Catalyst/stable/)
- [Clapeyron.jl](https://clapeyronthermo.github.io/Clapeyron.jl/dev/)
- [DFTK.jl](https://docs.dftk.org/stable/)
- [SteamTables.jl](https://github.com/braamvandyk/SteamTables.jl)


### Machine learning


- [Flux.jl](https://fluxml.ai/Flux.jl/stable/)
- [Lux.jl](https://lux.csail.mit.edu/)
- [NeuralPDE.jl](https://docs.sciml.ai/NeuralPDE/stable/)
- [Zygote.jl](https://fluxml.ai/Zygote.jl/stable/)


### GPU Programming


- [CUDA.jl](https://cuda.juliagpu.org/stable/)
- [Adapt.jl](https://github.com/JuliaGPU/Adapt.jl)
