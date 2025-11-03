---
jupyter:
  jupytext:
    cell_metadata_filter: -all
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.18.1
  kernelspec:
    display_name: Julia 1.12.1
    language: julia
    name: julia-1.12
---

# Porosity quantification


In this tutorial we will see how to implement a custom workflow for porosity quantification in materials. The selected tools are those from the [JuliaImages](https://juliaimages.org/latest/) suite.

We start below by importing all required packages.

```julia
using Pkg

requirements = [
    "Images",
    "ImageEdgeDetection",
    "ImageSegmentation",
    "IndirectArrays",
    "Statistics"
]

HERE = dirname(abspath(@__FILE__))
Pkg.activate(HERE)

for pkg ∈ requirements
    Pkg.add(pkg)
end
```

```julia
using Images
using ImageEdgeDetection
using ImageEdgeDetection: Percentile
using ImageSegmentation
using IndirectArrays
using Statistics
```

```julia

```

```julia

```
