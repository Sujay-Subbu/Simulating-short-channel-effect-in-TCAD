File {
* input files:
Grid = "@tdr@"
* output files:
Plot = "@tdrdat@"
Current = "@plot@"
}
Electrode {
{ Name="source" Voltage=0.0 }
{ Name="drain" Voltage=0.0}
{ Name="gate" Voltage=0.0 }
{ Name="body" Voltage=0.0 }
}
Physics {
Fermi
Mobility (DopingDependence HighFieldSat Enormal)
Recombination( SRH(DopingDependence) ) 
}
Plot {
eDensity hDensity eCurrent hCurrent
Potential SpaceCharge ElectricField
eMobility hMobility eVelocity hVelocity
Doping DonorConcentration AcceptorConcentration
}
Math {
Extrapolate
RelErrControl
}

Solve {
#-initial solution:
Poisson
Coupled { Poisson Electron }
#-ramp gate:
Quasistationary ( MaxStep=0.5
Goal{ Name="drain" Voltage=5 } )
{ Coupled { Poisson Electron } }

Quasistationary ( MaxStep=0.1
Goal{ Name="gate" Voltage=5 } )
{ Coupled { Poisson Electron } }
}

