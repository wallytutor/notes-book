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
from majordome import MajordomePlot
import cantera as ct
import numpy as np
import yaml
```

## Species data

+++

The following provides a compilation of data from [Schieltz (1964)](https://doi.org/10.1346/CCMN.1964.0130139).

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
  composition: {Al: 2, O:3}
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

data = yaml.safe_load(data)
```

## Functions and models

```{code-cell} ipython3
def molecular_weight(composition: dict[str, int]) -> float:
    """ Evaluate molecular weight of species [kg/kmol]. """
    return sum(n * ct.Element(e).weight for e, n in composition.items())
```

```{code-cell} ipython3
# elem_OO = ct.Element("O")
data[0]
```

```{code-cell} ipython3
molecular_weight(data[0]["composition"])
```

```{code-cell} ipython3

```
