# Water evaporation kinetics


In this tutorial we make use of Cantera's `ExtensibleReactor` model as described [here](https://cantera.org/stable/userguide/extensible-reactor.html) to simulate the evaporation of water in an open system.

This aims at representing a first step towards a thermogravimetry analysis (TGA) simulation using Cantera.


## Model statement


Our goal is to model the following reaction while tracking the state of the condensed matter as in TGA; we need nonetheless to track the mass transfer rate to be able to couple with gas phase in more complex systems.

$$
\text{H}_2\text{O}_{(l)} \rightarrow \text{H}_2\text{O}_{(g)}
\qquad\text{where}\qquad\Delta{}H>0
$$


The rate is assumed proportional to the remaining mass of liquid water $m_{(l)}=Y_{(l)}m$ at any given instant, where $k(T)$ assumes an Arrhenius representation.

$$
\dot{r} = k(T) m_{(l)}
$$


As liquid water is the sole species in the system, it is worthless solving for species conservation equation and overall mass balances simplifies to:

$$
\dfrac{dm}{dt}=-\dot{r}
\qquad\text{or}\qquad
\dfrac{dm}{dt}=-k(T)m_{(l)}
$$


## Preparing toolbox


Selecting the base class based on:

- `ExtensibleReactor` will solve for volume and internal energy
- `ExtensibleConstPressureReactor` will solve for enthalpy

Relevant references:

- [API docs: ExtensibleReactor](https://cantera.org/stable/python/zerodim.html#extensiblereactor)
- [User guide: ExtensibleReactor](https://cantera.org/stable/userguide/extensible-reactor.html)
- [Examples: implementing wall inertia](https://cantera.org/stable/examples/python/reactors/custom2.html)
- [Examples: porous media burner](https://cantera.org/stable/examples/python/reactors/PorousMediaBurner.html)

```python
from cantera import ExtensibleConstPressureReactor
import cantera as ct
import majordome as mj
import numpy as np
```

```python
ct.add_directory(mj.common.DATA)
```

## Creating the model

```python
class WaterReactor(ExtensibleConstPressureReactor):
    __slots__ = (
        "y",
        "_vapor",
        "_rate_const",
        "_heat_rate",
        "_var_names",
        "_mass_tol",
    )

    def __init__(self, solution, mass_liq, vapor, heat_rate,  **kwargs):
        # One cannot directly modify the mass of the reactor through
        # self.mass; one workaround this is to compute the volume
        # before creating the super() instance.
        kwargs["volume"] = mass_liq / solution.density

        super().__init__(solution, **kwargs)

        self._vapor = vapor
        self._heat_rate = heat_rate
        self._rate_const = ct.ArrheniusRate(5.0e+07, 0, 78.0e+06)
        self._mass_tol = kwargs.get("mass_tol", 0.01 * mass_liq)
        
    def replace_eval(self, t, LHS, RHS) -> None:
        """ Evaluate problem equations for mass, enthalpy, composition. """
        m = self.mass
        h = self.thermo.enthalpy_mass
        Y = self.thermo.Y

        if m < self._mass_tol:
            raise StopIteration()

        # Get provided heat [W]:
        Q = self._heat_rate
    
        # Evaluate current reaction rate [kg/s]:
        rr = self._rate_const(self.T) * m * Y[0]

        # Heat of reactions [J/kg * kg/s = W]:
        self._vapor.TP = self.thermo.T, None
        delta_h = (h - self._vapor.enthalpy_mass)
        Q += delta_h * rr

        RHS[0] = -rr
        RHS[1] = Q - h * rr
        RHS[2] = 0.0

    @property
    def variable_names(self) -> list[str]:
        """ Provides access to the names of internal variables. """
        if not hasattr(self, "_var_names"):
            f = self.component_name
            n = range(self.n_vars)
            self._var_names = list(map(f, n))
        return self._var_names

    def state_dict(self) -> dict[str, np.float64]:
        """ Provides access to the current state dictionary. """
        return dict(zip(self.variable_names, self.get_state()))
```

```python
def simulate(n_pts, t_end, reactor):
    times = np.linspace(0, t_end, n_pts)
    results = ct.SolutionArray(reactor.thermo, shape=(n_pts,),
                               extra={"t": 0.0, "m": reactor.mass})
    
    network = ct.ReactorNet([reactor])
    network.initialize()
    
    for i, t in enumerate(times[1:], 1):
        try:
            network.advance(t)
            results[i].TPY = reactor.thermo.TPY
            results[i].t = t
            results[i].m = reactor.mass
        except:
            break

    df = results.to_pandas()
    return df.iloc[:i].copy()
```

## Running a simulation

```python
water_liq = ct.Solution("materials.yaml", "water_liq")
water_gas = ct.Solution("materials.yaml", "water_gas")

# Heat rate [W]
rate = 3000

n_pts = 1001
t_end = 1000

reactor = WaterReactor(water_liq, mass_liq=1.0, heat_rate=rate, vapor=water_gas)

df = simulate(n_pts, t_end, reactor)

ax = df.plot(x="t", y="T")
# _ = ax.axhline(373.15, color="k", linestyle=":")
```
