# %load_ext autoreload
# %autoreload 2

# +
import functools
import matplotlib.pyplot as plt
import numpy as np

from majordome import MajordomePlot


# +
@MajordomePlot.new()
def test(*args, plot=None, **kwargs):
    fig, ax = plot.subplots()
    ax[0].plot([0, 1], [0, 1])

plot = test()
# -





import cantera as ct
import majordome as mj
import numpy as np

ct.add_directory(mj.common.DATA)


def specific_heat_maier_kelley(T, M, a):
    """ Truncated 3-coefficients specific heat [J/(kg.K)]"""
    return (a[0] + a[1] * T + a[2] * pow(T, -2)) / M


m_mullite = species[5].molecular_weight
a_mullite = [84.22, 20.0e-03, -25.0e+05]
specific_heat_maier_kelley(600, m_mullite, a_mullite)









species = ct.Species.list_from_file("materials.yaml", "species_minerals")
species

species[0].thermo.cp(1000) / 1000, species[0].molecular_weight

solids = ct.Solution("materials.yaml", "aszo")
solids.TP = 1000, None

solids.cp_mass * (species[0].molecular_weight / 1000)

solids.mass_fraction_dict()

solids.species_names
