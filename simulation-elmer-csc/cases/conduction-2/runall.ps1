$name = "domain"
$varGeo = "$name/$name.geo"
$varMsh = "$name/$name.msh"

if (Test-Path $varMsh) {
    Write-Host "Mesh already created..."
} else {
    gmsh - $varGeo
    ElmerGrid 14 2 $varMsh -autoclean -merge 1.0e-05 -out $name
}

Write-Host "Running case 'monophase'..."
cd monophase;  ElmerSolver > log.solver; cd ..

Write-Host "Running case 'multiphase'..."
cd multiphase; ElmerSolver > log.solver; cd ..
