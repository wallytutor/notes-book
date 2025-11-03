# Text user interface (TUI)


## Setup of a case


### Configuration


```scheme
/file/set-batch-options
    no ; Do you want to confirm overwrite? [yes]
    no ; Do you want to exit on error? [no]
    no ; Do you want to hide questions? [no]
```


### Loading and checking a mesh


```scheme
; This is a comment (starting by a semi-colon).
/file/read-case "domain/tunnel.msh.h5" ()
/mesh/check
/mesh/mesh-info 0

; Write the case (or overwrite if existing)
/file/write-case "tunnel-model.cas.h5" ()
```


### Handling named expressions


```scheme
/define/named-expressions/add "diam"  definition "0.01 [m]"       parameter yes ()
/define/named-expressions/add "dens"  definition "1.29 [kg/m^3]"  parameter no  ()
/define/named-expressions/add "visc"  definition "1.84 [Pa*s]"    parameter no  ()
/define/named-expressions/add "theta" definition "25 [deg]"       parameter no  ()
/define/named-expressions/export-to-tsv "expressions.tsv" ()
```


### Defining operating conditions

```scheme
/define/operating-conditions/gravity yes
    "0 [m/s^2]"
    "-cos(theta) * 9.81 [m/s^2]"
    "-sin(theta) * 9.81 [m/s^2]"
```


### Setting up some models


```scheme
; Select a viscous model
/define/models/viscous/ke-realizable yes
/define/models/viscous/kw-sst yes

; Activate DPM calculations
/define/models/dpm/interaction/coupled-calculations yes
/define/models/dpm/interaction/dpm-iteration-interval 10
/define/models/dpm/options/two-way-coupling yes
```


### Modify materials


```scheme
/define/materials/change-create "air" "air"
    yes                  ; change Density? [no]
    expression "gas_rho" ; Density
    no                   ; change Cp (Specific Heat)? [no]
    no                   ; change Thermal Conductivity? [no]
    yes                  ; change Viscosity? [no]
    expression "gas_mu"  ; Viscosity
    no                   ; change Molecular Weight? [no]
    no                   ; change Thermal Expansion Coefficient? [no]
    no                   ; change Speed of Sound? [no]
```


### Setting boundary conditions


```scheme
/define/boundary-conditions/set/mass-flow-inlet
    "inlet"  () mass-flow no 1.0  ()

/define/boundary-conditions/set/mass-flow-inlet
    "inlet"  () mass-flow no "mdot_inlet"  ()

/define/boundary-conditions/set/wall "gluish-wall" ()
    dpm-bc-type yes trap ()

/define/boundary-conditions/modify-zones/zone-type
    "environment-entry" wall ()
```


### Creating a DPM injection


```scheme
/define/models/dpm/injections/create-injection/fibers
    no           ; Particle type [inert]: Change current value? [no]
    yes          ; Injection type [single]: Change current value? [no] yes
    surface      ; Injection type [single]> surface
    no           ; Injection Material [anthracite]: Change current value? [no]
    injection () ; Surface(1) [()] injection ()
    no           ; Scale Flow Rate by Face Area [no] no
    yes          ; Use Face Normal for Velocity Components [no] yes
    yes          ; Stochastic Tracking? [no] yes
    yes          ; Random Eddy Lifetime? [no] yes
    1            ; Number of Tries [1]
    0.15         ; Time Scale Constant [0.15]
    no           ; Modify Laws? [no]
    no           ; Set user defined initialization function? [no]
    no           ; Cloud Tracking? [no]
    no           ; Rosin Rammler diameter distribution? [no]
    0.000976     ; Diameter (in [m]) [0.0001] 0.000976
    20           ; Velocity Magnitude (in [m/s]) [0] 20
    (/ 50 3600)  ; Total Flow Rate (in [kg/s]) [9.999999999999999e-21]

/define/materials/change-create/anthracite "fibers" yes constant 2800 no yes
```

```scheme
/define/models/dpm/injections/properties/set/pick-injections-to-set
    no     ; List all available injections before picking one or more of them?
    fibers ; pick injections:(1) [()]
    ()     ; pick injections:(2) [()]
    no     ; Review list of picked injections?

/define/models/dpm/injections/injection-properties/set/physical-models
    drag-parameters nonspherical 0.1
```


### Report definitions


```scheme
/solve/report-definitions/delete-all yes
```

```scheme
/solve/report-definitions/add/mass-flows surface-massflowrate
    surface-names
        "injection-1"
        "injection-2"
        "extractions" ()
    per-surface yes ()

/solve/report-files/add/report-mass-flows
    file-name   "report-mass-flows-rfile.out"
    report-defs "mass-flows" () ()

/solve/report-files/edit/report-mass-flows
    frequency 10 ()
```

```scheme
/solve/report-definitions/add/mass-extraction injection-escaped-mass
    boundary-zones "extraction" () ()
```


## Solution controls


### Residuals


```scheme
/solve/monitors/residual/convergence-criteria
    1e-9 ; continuity residual convergence criterion [0.001]
    1e-6 ; x-velocity residual convergence criterion [0.001]
    1e-6 ; y-velocity residual convergence criterion [0.001]
    1e-6 ; z-velocity residual convergence criterion [0.001]
    1e-5 ; k residual convergence criterion [0.001]
    1e-5 ; omega residual convergence criterion [0.001]
```


### Solver parameters


```scheme
/solve/set/pseudo-time-method global yes 1 1.0 ()

/solve/set/p-v-controls 0.7 0.3
/solve/set/pseudo-time-method/relaxation-factors/density 0.5

/solve/set/discretization-scheme/k        0 ()
/solve/set/discretization-scheme/omega    0 ()
```


### Initialize flow and iterate


```scheme
/solve/initialize/initialize-flow
/solve/initialize/hyb-initialization yes
/solve/iterate 100
```


### Parallel settings


```scheme
; /parallel/check
; /parallel/partition/auto
; /parallel/timer/usage
```


## Postprocessing


### Figures in graphical mode only


```scheme
/display/display-states/create state-right
    "disable"      ; Front face transparent ("enable" "disable" "dont-save")
    "orthographic" ; Projection ("perspective" "orthographic" "dont-save")
    "enable"       ; Axes ("enable" "disable" "dont-save")
    "disable"      ; Ruler ("enable" "disable" "dont-save")
    "disable"      ; Title ("enable" "disable" "dont-save")
    "enable"       ; Boundary markers ("enable" "disable" "dont-save")
    "enable"       ; Anti-aliasing ("enable" "disable" "dont-save")
    "disable"      ; Reflections ("enable" "disable" "dont-save")
    "disable"      ; Static shadows ("enable" "disable" "dont-save"
    "disable"      ; Dynamic shadows  ("enable" "disable" "dont-save")
    "disable"      ; Grid plane ("enable" "disable" "dont-save")
    "on"           ; Headlights ("on" "off" "automatic" "dont-save")
    "automatic"    ; Lighting ("automatic" "flat" "gouraud" "phong" "dont-save" "off")
    "right"        ; View name ("active" "dont-save" "wf-view" "front" "back"
                   ;            "right" "left" "top" "bottom" "isometric" "view-0")
    "0"            ; (dont-save 0) ["0"]


; Produces an .stt file (do not add exension in the command!).
/display/display-states/write "journaling/display-states" state-right ()
```

```scheme
/display/objects/create/mesh wire
    options
        edges? yes
        faces? no ()
    edge-type outline
    coloring uniform edges black ()
    display-state-name state-right ()
```

```scheme
/display/objects/create/contour contour-total-pressure
    surfaces-list "plane-name" ()
    field total-pressure
    range-option autorange-off
        minimum -200
        maximum  200
        clip-to-range? no ()
    color-map
        title-elements "Variable Only"
        color          "field-pressure"
        position       0
        format         "%.0f" ()
    display-state-name state-right ()
```

```scheme
/display/objects/create/scene scene-total-pressure
    graphics-objects
        add  "wire" ()
        add "contour-total-pressure" () ()
    display-state-name state-right ()
```


### Exporting for external processing


```scheme
/surface/plane-surface plane-symmetry
    yz-plane ; (yz-plane zx-plane xy-plane point-and-normal three-points)
    0.01     ; x (in [m])
```

```scheme
/file/export/ascii "results.csv"
    plane-symmetry ()  ; Surfaces ()
    yes                ; Delimiter/Comma?
    total-pressure
    dynamic-pressure
    velocity-magnitude ()
    no
```

```scheme
/file/export/cgns "results"
    surface-select     ; Scope: (full-domain volume-select surface-select)
    plane-symmetry ()  ; Surfaces ()
    no                 ; Cell-Centered [no]
    yes                ; Format/HDF5?, if HDF5 not chosen, ADF format is set [yes]
    total-pressure     ; CGNS scalar(1)> ...
    dynamic-pressure
    viscosity-ratio
    velocity-magnitude ()
    () ()
```

```scheme
; XXX: `history` seems to be broken!
; XXX: options change depending on the export type!
/file/export/particle-history-data
    fieldview             ; cfdpost, fieldview, history, ensight, geometry
    "results-particles"   ; File name
    "fibers" ()           ; Injections ()
    particle-time-step () ; Variables ()
    20                    ; Skip tracks
    2000                  ; Coarsen path by
```


## Saving results


```scheme
/file/write-case-data "model-final.cas.h5" yes
```
