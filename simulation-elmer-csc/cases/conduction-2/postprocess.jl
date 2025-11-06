# -*- coding: utf-8 -*-
using CairoMakie
using DelimitedFiles
using DataFrames
using Taskforce.Elmer


function workflow()
    data1 = load_saveline_table("monophase/results")
    data2 = load_saveline_table("multiphase/results")

    x1 = 1000data1[:, "coordinate 1"]
    x2 = 1000data2[:, "coordinate 1"]

    y1 = data1[:, "temperature"]
    y2 = data2[:, "temperature"]

    with_theme() do
        f = Figure()
        ax = Axis(f[1, 1])

        lines!(ax, x1, y1; color = :black, label = "Reference")
        lines!(ax, x2, y2; color = :red,   label = "Phase change")

        ax.xlabel = "Position [mm]"
        ax.ylabel = "Temperature [K]"

        ax.xticks = 0:10:100
        # ax.yticks = 0:10:100

        xlims!(ax, extrema(ax.xticks.val))
        # ylims!(ax, extrema(ax.yticks.val))

        f
    end
end
