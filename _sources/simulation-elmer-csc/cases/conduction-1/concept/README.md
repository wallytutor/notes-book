# Concept with GUI

Although the recommended way to deal with Elmer setup is through [SIF](../../../README.md) files, creating them by hand is sort of cumbersome if you do not dispose of a similar case to modify. Here we provide a guided workflow to create a case that we will later modify by hand. This will allow us to quickly produce a working version of the base operating version of SIF file.

In what follows we assume you have generated the computational grid with `gmsh` under the [2d](../2d/README.md) directory. To do so, navigate to that folder in a terminal and run

```shell
gmsh - domain.geo
```

A file `domain.msh` in `gmsh` format will be generated. That said, what we will create here is essentially the 2D case since it is conceived with its mesh. In what follows we will perform the following steps:

1. Create a base case with the referred mesh and add additional tools to the UI.
2. Add a set of equations with all the models associated to the loaded body.
3. Create a material and attribute it to the body.
4. Set initial and boundary conditions.

## Raw case preparation

It is important that the non-default solvers be added at this stage, otherwise they will not appear in the model selection tabs (and you might need to delete already configured models to be able to use them). From the `File` menu entry perform the following steps:

- File > Open > *select 2D mesh file*
- File > Definitions > Append > *fluxsolver.xml*
- File > Definitions > Append > *saveline.xml*
- File > Save Project > *navigate to concept directory*

Now on the object tree, expand `Body`, open `Body Property 1`, rename it `Hollow Cylinder`. You can save project again here (and as often as you wish) to keep track of modifications.

## Creation equations

In Elmer not everything that is called equation represents an actual *physical equation*. It is important to add all [models](https://www.nic.funet.fi/pub/sci/physics/elmer/doc/ElmerModelsManual.pdf) that apply to a body at the same equation, as follows:

- Equation > [Add...]:
    - Rename it `Model`
    - Apply to bodies: check `Hollow Cylinder`
    - Check `Active` in tabs:
        - `Heat equation`
        - `Flux and Gradient`
        - `SaveLine`

As you may notice, in the above we have actually one physical model (heat equation) and a pair of processing utilities. As in FEM we perform projections to solve for these processed quantities, they need to be extracted at runtime. To get the heat flux at system boundary and extracting solution over a given line during calculation we perform the following configurations.

- Edit Solver Settings in `Model` tab `Flux and Gradient`:
    - Tab `Solver specific options`:
        - Target Variable `Temperature`
        - Flux Coefficient `Heat Conductivity`
        - Check `Calculate Flux`
    - Tab `General`:
        - Execute solver `After timestep`

In steady state simulations the flux is generally computed *after all* calculations are performed (at converged solution); for transient simulations this is generally done after each time step. Failing to configure this properly may lead to an overhead of useless intermediate computations. 

- Edit Solver Settings in `Model` tab `SaveLine`:
    - Tab `Solver specific options`:
        - Polyline Coordinates `Size(2, 2);  0.005 0.025  0.100 0.025`
        - Polyline Divisions `25`
    - Tab `General`:
        - Execute solver `After simulation`

Saving data could be done on a time basis, but for this case we have decided to extract only a profile of the final solution *after simulation*.

## Setting up material

For being able to eventually verify this case against analytical solutions,  the simplest set of material properties are introduced below; everything is held constant.

- Material > [Add...]:
    - Rename it `Solid`
    - Apply to bodies: check `Hollow Cylinder`
    - Density `3000`
    - Heat Capacity `1000`
    - Tab `Heat equation`:
        - Heat Conductivity `10`

## Configuring conditions

Next we initialize the body to be at 1000 K:

- Initial condition > [Add...]:
    - Rename it `Initial Temperature`
    - Apply to bodies: check `Hollow Cylinder`
    - Tab `Heat equation`:
        - Temperature `1000`

Both the whole (left side) and ends (top/bottom) are set as adiabatic:

- Boundary condition > [Add...]:
    - Rename it `Hole`
    - Apply to boundaries: check `Boundary 1`
    - Tab `Heat equation`:
        - Heat Flux `0`

- Boundary condition > [Add...]:
    - Rename it `Ends`
    - Apply to boundaries: check `Boundary 3`
    - Tab `Heat equation`:
        - Heat Flux `0`

Finally a Robin boundary condition is provided for environment (radius/right side):

- Boundary condition > [Add...]:
    - Rename it `Environment`
    - Apply to boundaries: check `Boundary 2`
    - Tab `Heat equation`:
        - Heat Transfer Coeff. `10`
        - External Temperature `300`

So far the model is built with the default steady-state solver. This might be useful for testing *if it runs* towards the trivial solution (equilibrium with external environment), what should be pretty fast. So save, generate, and run the model for testing.

## Final setup

Back to menu `Model > Setup...`, tune a few parameters as follows:

- Results directory `results`
- Coordinate system `Axi Symmetric`
- Simulation type `Transient`
- Output intervals `10`
- Timestep intervals `120`
- Timestep sizes `10`

Now save, generate, and run. It should be up and running as desired by here!
