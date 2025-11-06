# -*- coding: utf-8 -*-
using DelimitedFiles
using CairoMakie

scalars = readdlm("results/scalars.dat")
sides = readdlm("results/sides.dat")

# Dimensions of the cylinder:
R = 0.10
h = 0.05

# Parameters of the problem:
htc = 10.0
Tinf = 300

# Retrieve time series of the heat flux:
t = scalars[:, 1]
Q = scalars[:, 2]

# Retrieve the final values of the temperature and heat flux:
T = sides[end, 8]
q = sides[end, 9]

# Calculate the heat flux from the analytical solution:
A = 2pi * R * h
q_calc = htc * (T - Tinf)
Q_calc = q_calc * A

fig = with_theme() do
    f = Figure()
    ax = Axis(f[1, 1];
        xgridcolor = :gray20,
        ygridcolor = :gray20,
        xgridstyle = :dot,
        ygridstyle = :dot,
        xgridwidth = 0.8,
        ygridwidth = 0.8,
    )
    lines!(ax, t, Q, color = :blue)
    ax.xlabel = "Time [s]"
    ax.ylabel = "Heat flow [W]"
    ax.xticks = 200:200:1200
    ax.yticks = 195:5:215
    xlims!(ax, extrema(ax.xticks.val))
    ylims!(ax, extrema(ax.yticks.val))
    f
end

save("heat-flow.png", fig)