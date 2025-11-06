---
jupytext:
  cell_metadata_filter: -all
  formats: ipynb,md:myst
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.18.0
kernelspec:
  display_name: Python 3 (ipykernel)
  language: python
  name: python3
---

# Converting data to Shomate format

```{code-cell} ipython3
from numpy.typing import NDArray
from majordome import MajordomePlot
import cantera as ct
import numpy as np
import pandas as pd
import yaml
```

## Species data

+++

The following provides a compilation of data from [Schieltz (1964)](https://doi.org/10.1346/CCMN.1964.0130139); please notice that at the time of publication customary units where $\text{cal}\,\text{mol}^{-1}$, so when loading data we will need to multipy data by $4.184\:\text{J}\,\text{cal}^{-1}$.

```{code-cell} ipython3
data = """\
- name: KAOLINITE
  composition: {Al: 2, Si: 2, O : 9, H : 4}
  data: [57.47, 35.30e-03, -7.87e+05, -964940.0, 40.50]

- name: METAKAOLIN
  composition: {Al: 2, Si: 2, O: 7}
  data: [54.85, 8.80e-03, -3.48e+05, -767500.0, 32.78]

- name: AL6SI2O13_MULLITE
  composition: {Al: 6, Si: 2, O: 13}
  data: [84.22, 20.00e-03, -25.00e+05, -1804000.0, 60.00]

- name: AL2O3_GAMMA
  composition: {Al: 2, O: 3}
  data: [16.37, 11.10e-03, 0.0, -395000.0, 12.20]

- name: SIO2_QUARTZ_ALPHA
  composition: {Si: 1, O: 2}
  data: [11.22, 8.20e-03, -2.70e+05, -209900.0, 10.06]

- name: SIO2_QUARTZ_BETA
  composition: {Si: 1, O: 2}
  data: [14.41, 1.94e-03, 0.0, -209900.0, 10.06]

- name: SIO2_GLASS
  composition: {Si: 1, O: 2}
  data: [13.38, 3.68e-03, -3.45e+05, -202000.0, 10.06]

- name: SIO2_CRISTOBALITE_ALPHA
  composition: {Si: 1, O: 2}
  data: [4.28, 21.06e-03, 0.0, -209500.0, 10.06]

- name: SIO2_CRISTOBALITE_BETA
  composition: {Si: 1, O: 2}
  data: [14.40, 2.04e-03, 0.0, -209500.0, 10.06]

- name: SIO2_TRIDYMITE_ALPHA
  composition: {Si: 1, O: 2}
  data: [3.27, 24.80e-03, 0.0, -209400.0, 10.06]

- name: SIO2_TRIDYMITE_BETA
  composition: {Si: 1, O: 2}
  data: [13.64, 2.64e-03, 0.0, -209400.0, 10.06]

- name: H2O_LIQUID
  composition: {H: 2, O: 1}
  data: [18.03, 0.0, 0.0, -68320.0, 16.72]

- name: H2O_STEAM
  composition: {H: 2, O: 1}
  data: [7.17, 2.56e-03, 0.08e+05, -57800.0, 45.13]
"""
```

## Data model

```{code-cell} ipython3
class SchieltzSpecies:
    """ Simple species representation to load data from Schieltz, 1964. """
    __slots__ = ("_name", "_mass", "_coef", "_Tref")

    def __init__(self, data: dict, Tref: float = 298.15) -> None:
        self._name = data["name"]
        self._mass = self.molecular_weight(data["composition"])
        self._coef = 4.184 * np.array(data["data"])
        self._Tref = Tref

    def __repr__(self) -> str:
        """ Unique representation of species. """
        return f"<Species {self._name}>"

    def _c(self, T: float) -> float:
        """ Evaluation by definition. """
        a, b, c = self._coef[:3]
        return a + b * T + c / T**2

    def _h(self, T: float) -> float:
        """ Evaluation by definition. """
        a, b, c = self._coef[:3]
        return a * T + (b / 2) * T**2 - c / T

    def _s(self, T: float) -> float:
        """ Evaluation by definition. """
        a, b, c = self._coef[:3]
        return a * np.log(T) + b * T - c / (2 * T**2)

    def _enthalpy_change(self, T: float) -> float:
        """ Maier-Kelley specific enthalpy change [J/mol]. """
        return self._h(T) - self._h(self._Tref)

    def _entropy_change(self, T: float) -> float:
        """ Maier-Kelley specific entropy change [J/(mol.K)]. """
        return self._s(T) - self._s(self._Tref)

    @staticmethod
    def molecular_weight(composition: dict[str, int]) -> float:
        """ Evaluate molecular weight of species [kg/kmol]. """
        return sum(n * ct.Element(e).weight for e, n in composition.items())

    def specific_heat(self, T: float) -> float:
        """ Maier-Kelley specific heat [J/(mol.K)]. """
        return self._c(T)

    def specific_enthalpy(self, T: float) -> float:
        """ Maier-Kelley specific enthalpy [J/mol]. """
        return self.reference_specific_enthalpy + self._enthalpy_change(T)

    def specific_entropy(self, T: float) -> float:
        """ Maier-Kelley specific entropy [J/(mol.K)]. """
        return self.reference_specific_entropy + self._entropy_change(T)

    @property
    def reference_specific_enthalpy(self) -> float:
        """ Reference state formation enthalpy [J/mol]. """
        return self._coef[-2]

    @property
    def reference_specific_entropy(self) -> float:
        """ Reference state formation entropy [J/(mol.K)]. """
        return self._coef[-1]

    def tabulate(self, T: NDArray[np.float64]) -> pd.DataFrame:
        """ Generate a table for comparison with NIST Web-book of Chemistry. """
        c = self.specific_heat(T)
        s = self.specific_entropy(T)
        h = self._enthalpy_change(T) / 1000
        g = -(h - T * s) / T

        data = np.vstack((T, c, s, g, h)).T
        columns = pd.MultiIndex.from_tuples([
            ("T", "K"),
            ("Cp", "J/(mol.K)"),
            ("S°", "J/(mol.K)"),
            ("-(G°-H°298.15)/T", "J/(mol.K)"),
            ("H°-H°298.15", "kJ/mol")
        ])

        return pd.DataFrame(data, columns=columns)
```

```{code-cell} ipython3
class CanteraSpecies:
    """ Simple wrapper to compute vectorized properties of species. """
    __slots__ = ("_species", "_c", "_h", "_s", "_trng")

    def __init__(self, species: ct.thermo.Species) -> None:
        self._species = species

        # XXX: notice that properties are in *kmol* basis in Cantera
        # https://cantera.org/stable/python/thermo.html#cantera.SpeciesThermo
        self._c = np.vectorize(lambda t: 0.001 * species.thermo.cp(t))
        self._h = np.vectorize(lambda t: 0.001 * species.thermo.h(t))
        self._s = np.vectorize(lambda t: 0.001 * species.thermo.s(t))
        self._trng = species.input_data["thermo"]["temperature-ranges"]

    def specific_heat(self, T: float) -> float:
        """ Cantera species specific heat [J/(mol.K)]. """
        return self._c(T)

    def specific_enthalpy(self, T: float) -> float:
        """ Cantera species specific enthalpy [J/mol]. """
        return self._h(T)

    def specific_entropy(self, T: float) -> float:
        """ Cantera species specific entropy [J/(mol.K)]. """
        return self._s(T)

    @property
    def temperature_ranges(self) -> list[float]:
        """ Temperature ranges for data set [K]. """
        return self._trng
```

```{code-cell} ipython3
database = [SchieltzSpecies(d) for d in yaml.safe_load(data)]
species  = {s.name: CanteraSpecies(s) for s in ct.Species.list_from_file("materials.yaml", "species")}
```

## Validation of calculator

+++

Here we verify the calculations meet results published at [NIST](https://webbook.nist.gov/cgi/cbook.cgi?ID=C14808607&Units=SI&Mask=2&Type=JANAFS&Table=on#JANAFS) for quartz.

```{code-cell} ipython3
spec_ref = species["SIO2_QUARTZ"]
T_ranges = spec_ref.temperature_ranges

sio2_alpha = database[4]
sio2_beta  = database[5]

h0 = sio2_alpha.reference_specific_enthalpy
T_alpha = np.linspace(*T_ranges[:2], 100)
T_beta  = np.linspace(*T_ranges[1:], 100)

df_alpha = sio2_alpha.tabulate(T_alpha)
df_beta  = sio2_beta.tabulate(T_beta)

df = pd.concat([df_alpha, df_beta])
```

```{code-cell} ipython3
@MajordomePlot.new(
    shape  = (2, 2),
    size   = (12, 8),
    xlabel = "Temperature [K]",
    ylabel=[r"$c_p$", r"$s^\circ$", r"-$(G^\circ-H^\circ)/T$", r"$H-H^\circ$"]
)
def plot_properties(spec_ref, h0, df, plot=None):
    data = df.iloc[:, :].to_numpy().T
    _, ax = plot.subplots()

    T = data[0]
    c = spec_ref.specific_heat(T)
    h = spec_ref.specific_enthalpy(T)
    s = spec_ref.specific_entropy(T)
    g = (h + T * s - h0) / T

    ax[0].plot(T, data[1], label="Schieltz (1964)")
    ax[0].plot(T, c, label="Cantera")

    ax[1].plot(T, data[2], label="Schieltz (1964)")
    ax[1].plot(T, s, label="Cantera")

    ax[2].plot(T, data[3], label="Schieltz (1964)")
    ax[2].plot(T, g, label="Cantera")

    # ax[3].plot(T, data[4], label="Schieltz (1964)")
    ax[3].plot(T, h - h0, label="Cantera")

    ax[0].legend(loc=4)
    ax[1].legend(loc=4)
    ax[2].legend(loc=4)
    ax[3].legend(loc=4)
```

```{code-cell} ipython3
plot = plot_properties(spec_ref, h0, df)
```

## Evaluation for fitting

```{code-cell} ipython3

```

```{code-cell} ipython3

```
