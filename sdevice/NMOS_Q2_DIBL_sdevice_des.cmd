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

  #########################################################################
  # 1. INITIAL SOLUTION  (VGS = 0 , VDS = 0)
  #########################################################################
  Poisson
  Coupled { Poisson Electron }
  Save(FilePrefix="vgs0_vds0")

  #########################################################################
  # 2. FIRST DIBL CURVE :  VDS = 0.1 V , sweep VG 0 → 5 V
  #########################################################################
  Load(FilePrefix="vgs0_vds0")

  # Set VDS = 0.1V
  Quasistationary (
      InitialStep=0.1 MaxStep=0.1 MinStep=0.01
      Goal { Name="drain" Voltage=0.1 }
  ) { Coupled { Poisson Electron } }

  Save(FilePrefix="vds01_ready")

  # Sweep VGS
  Load(FilePrefix="vds01_ready")
  NewCurrentPrefix="ID_VG_VDS0p1_"
  Quasistationary(
      InitialStep=0.05 MaxStep=0.1 MinStep=0.005
      Goal { Name="gate" Voltage=5.0 }
  ) { Coupled { Poisson Electron } }

  #########################################################################
  # 3. SECOND DIBL CURVE :  VDS = VDD (5 V) , sweep VG 0 → 5 V
  #########################################################################

  Load(FilePrefix="vgs0_vds0")

  # Ramp drain to VDD
  Quasistationary (
      InitialStep=0.1 MaxStep=0.1 MinStep=0.01
      Goal { Name="drain" Voltage=5.0 }
  ) { Coupled { Poisson Electron } }

  Save(FilePrefix="vds5_ready")

  # Sweep VGS at VDS = 5 V
  Load(FilePrefix="vds5_ready")
  NewCurrentPrefix="ID_VG_VDS5_"
  Quasistationary(
      InitialStep=0.05 MaxStep=0.1 MinStep=0.005
      Goal { Name="gate" Voltage=5.0 }
  ) { Coupled { Poisson Electron } }

}





