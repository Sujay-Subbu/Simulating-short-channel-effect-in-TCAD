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
  # 1. INITIAL SOLUTION (VGS = 0)
  #########################################################################
  Poisson
  Coupled { Poisson Electron }

  Save(FilePrefix="vg0")

  #########################################################################
  # 2. RAMP GATE VOLTAGE TO MULTIPLE VALUES
  #    Choose whichever VGS values you want here.
  #########################################################################

  # VGS = 1V
  Quasistationary (
      InitialStep=0.1 MaxStep=0.1 MinStep=0.01
      Goal { Name="gate" Voltage=1.0 }
  ) { Coupled { Poisson Electron } }
  Save(FilePrefix="vg1")

  # VGS = 2V
  Quasistationary (
      InitialStep=0.1 MaxStep=0.1 MinStep=0.01
      Goal { Name="gate" Voltage=2.0 }
  ) { Coupled { Poisson Electron } }
  Save(FilePrefix="vg2")

  # VGS = 3V
  Quasistationary (
      InitialStep=0.1 MaxStep=0.1 MinStep=0.01
      Goal { Name="gate" Voltage=3.0 }
  ) { Coupled { Poisson Electron } }
  Save(FilePrefix="vg3")

  # VGS = 4V
  Quasistationary (
      InitialStep=0.1 MaxStep=0.1 MinStep=0.01
      Goal { Name="gate" Voltage=4.0 }
  ) { Coupled { Poisson Electron } }
  Save(FilePrefix="vg4")

  # VGS = 5V
  Quasistationary (
      InitialStep=0.1 MaxStep=0.1 MinStep=0.01
      Goal { Name="gate" Voltage=5.0 }
  ) { Coupled { Poisson Electron } }
  Save(FilePrefix="vg5")

  #########################################################################
  # 3. FOR EACH GATE VOLTAGE, SWEEP DRAIN VOLTAGE 0 → 5V
  #########################################################################

  # ---- Curve for VGS = 0V ----
  Load(FilePrefix="vg0")
  NewCurrentPrefix="vd_vg0_"
  Quasistationary (
      InitialStep=0.01 MaxStep=0.1 MinStep=0.001
      Goal { Name="drain" Voltage=5.0 }
  ) { Coupled { Poisson Electron } }

  # ---- Curve for VGS = 1V ----
  Load(FilePrefix="vg1")
  NewCurrentPrefix="vd_vg1_"
  Quasistationary (
      InitialStep=0.01 MaxStep=0.1 MinStep=0.001
      Goal { Name="drain" Voltage=5.0 }
  ) { Coupled { Poisson Electron } }

  # ---- Curve for VGS = 2V ----
  Load(FilePrefix="vg2")
  NewCurrentPrefix="vd_vg2_"
  Quasistationary (
      InitialStep=0.01 MaxStep=0.1 MinStep=0.001
      Goal { Name="drain" Voltage=5.0 }
  ) { Coupled { Poisson Electron } }

  # ---- Curve for VGS = 3V ----
  Load(FilePrefix="vg3")
  NewCurrentPrefix="vd_vg3_"
  Quasistationary (
      InitialStep=0.01 MaxStep=0.1 MinStep=0.001
      Goal { Name="drain" Voltage=5.0 }
  ) { Coupled { Poisson Electron } }

  # ---- Curve for VGS = 4V ----
  Load(FilePrefix="vg4")
  NewCurrentPrefix="vd_vg4_"
  Quasistationary (
      InitialStep=0.01 MaxStep=0.1 MinStep=0.001
      Goal { Name="drain" Voltage=5.0 }
  ) { Coupled { Poisson Electron } }

  # ---- Curve for VGS = 5V ----
  Load(FilePrefix="vg5")
  NewCurrentPrefix="vd_vg5_"
  Quasistationary (
      InitialStep=0.01 MaxStep=0.1 MinStep=0.001
      Goal { Name="drain" Voltage=5.0 }
  ) { Coupled { Poisson Electron } }

}


