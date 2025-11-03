# +
# # %pip install -e ../../../
# -

import cantera as ct
import majordome as mj

ct.add_directory(mj.common.DATA)

species = ct.Species.list_from_file("materials.yaml")
species

species[0].thermo.cp(1000) / 1000, species[0].molecular_weight

solids = ct.Solution("materials.yaml", "aszo")
solids.TP = 1000, None

solids.cp_mass * (species[0].molecular_weight / 1000)

solids.mass_fraction_dict()

solids.species_names
