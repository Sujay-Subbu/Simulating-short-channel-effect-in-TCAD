;------ 2D TCAD NMOSFET structure for ECE 441 Spring 2021 ----------------------------------------------------------------
;------Input file For SWB---------
;----------------------------------------------------------------------------------------------------------------------
; Adjustable Parameters

(define Lgate 1)	   		; Gate Length in micron
(define Tox_nm 3)			; Tox in nm
(define N_body 2e+18)		; Channel doping in cm^-3
;----------------------------------------------------------------------------------------------------------------------
; Fixed Parameters

;- Horizontal -;
(define SrcL 0)
(define SrcCL 0)
(define SrcCR 0.1)
(define SrcR 0.15)
(define GateL SrcR)
(define GateR (+ GateL Lgate))
(define DrnL GateR)
(define DrnCL (+ GateR 0.05))
(define DrnCR (+ DrnCL 0.1))
(define DrnR DrnCR)

;- Vertical -;
(define Tox (/ Tox_nm 1000.0))
(define SiTop 0)
(define OxTop (- 0 Tox))
(define GTop (- OxTop 0.05))
(define Depth 0.3)

;- Doping Deginitions -;
(define N_sd 1e+20)
(define VA_sd 0.035)
(define LA_sd 0.0001)
(define SP_sd 0)
;----------------------------------------------------------------------------------------------------------------------
; Overlap: New replaces old
(sdegeo:set-default-boolean "ABA")
;----------------------------------------------------------------------------------------------------------------------
; Create Structures

(sdegeo:create-rectangle (position SrcL SiTop 0.0 )  (position DrnR Depth 0.0 ) "Silicon" "RSi" )
(sdegeo:create-rectangle (position GateL SiTop 0.0 )  (position GateR OxTop 0.0 ) "SiO2" "ROx" )
(sdegeo:create-rectangle (position GateL OxTop 0)  (position GateR GTop 0) "PolySi" "RGate" )

(sdegeo:insert-vertex (position SrcCR SiTop 0))
(sdegeo:insert-vertex (position DrnCL SiTop 0))
;----------------------------------------------------------------------------------------------------------------------
; Create Contacts

(sdegeo:define-contact-set "gate" 4  (color:rgb 1 0 0 ) "##" )
(sdegeo:define-contact-set "source" 4  (color:rgb 1 0 0 ) "##" )
(sdegeo:define-contact-set "drain" 4  (color:rgb 1 0 0 ) "##" )
(sdegeo:define-contact-set "body" 4  (color:rgb 1 0 0 ) "##" )

(sdegeo:define-2d-contact (list (car (find-edge-id (position (+ GateL 0.001) GTop 0)))) "gate")
(sdegeo:define-2d-contact (list (car (find-edge-id (position (+ SrcCL 0.001) SiTop 0)))) "source")
(sdegeo:define-2d-contact (list (car (find-edge-id (position (+ DrnCL 0.001) SiTop 0)))) "drain")
(sdegeo:define-2d-contact (list (car (find-edge-id (position (+ SrcL 0.001) Depth 0)))) "body")
;----------------------------------------------------------------------------------------------------------------------
; Define Doping Profiles

(sdedr:define-refeval-window "BGDopWin" "Rectangle"  (position SrcL 0 0.0)  (position DrnR Depth 0.0) )
(sdedr:define-constant-profile "BGDopProf" "BoronActiveConcentration" N_body)
(sdedr:define-constant-profile-placement "BGDop" "BGDopProf" "BGDopWin")

(sdedr:define-refeval-window "PolyDopWin" "Rectangle"  (position GateL OxTop 0.0)  (position GateR GTop 0.0) )
(sdedr:define-constant-profile "PolyDopProf" "ArsenicActiveConcentration" 1e+21)
(sdedr:define-constant-profile-placement "PolyDop" "PolyDopProf" "PolyDopWin")

(sdedr:define-refeval-window "SrcDopLine" "Line"  (position SrcL 0.0 0.0)  (position (- GateL SP_sd) 0.0 0.0) )
(sdedr:define-analytical-profile-placement "SrcDop" "SrcDopProf" "SrcDopLine" "Both" "NoReplace" "Eval")
(sdedr:define-gaussian-profile "SrcDopProf" "ArsenicActiveConcentration" "PeakPos" 0.05  "PeakVal" N_sd "StdDev" VA_sd "Gauss"  "StdDev" LA_sd)

(sdedr:define-refeval-window "DrnDopLine" "Line"  (position DrnR 0.0 0.0)  (position (+ GateR SP_sd) 0.0 0.0) )
(sdedr:define-analytical-profile-placement "DrnDop" "DrnDopProf" "DrnDopLine" "Both" "NoReplace" "Eval")
(sdedr:define-gaussian-profile "DrnDopProf" "ArsenicActiveConcentration" "PeakPos" 0.05  "PeakVal" N_sd "StdDev" VA_sd "Gauss"  "StdDev" LA_sd)
;----------------------------------------------------------------------------------------------------------------------
; Define Meshing Stretagies

(sdedr:define-refinement-size "GOXMeshDef"  	(/ Lgate 10) (/ Tox 2)	(/ Lgate 20) (/ Tox 4) )
(sdedr:define-refinement-size "GPolyMeshDef" 	(/ Lgate 10) 0.025		(/ Lgate 20) 0.01 )
(sdedr:define-refinement-size "BodyMeshDef" 	(/ Lgate 10) 0.015		0.0025 0.0025 )
(sdedr:define-refinement-size "ChMeshDef" 		(/ Lgate 20) 0.005		0.0025 0.001 )

(sdedr:define-refeval-window "GOXMeshWin" "Rectangle" (position GateL 0 0)  (position GateR OxTop 0) )
(sdedr:define-refinement-placement "GOXMesh" "GOXMeshDef" "GOXMeshWin" )

(sdedr:define-refeval-window "GPolyMeshWin" "Rectangle" (position GateL OxTop 0)  (position GateR GTop 0) )
(sdedr:define-refinement-placement "GPolyMesh" "GPolyMeshDef" "GPolyMeshWin" )

(sdedr:define-refeval-window "BodyMeshWin" "Rectangle" (position SrcL 0 0)  (position DrnR Depth 0) )
(sdedr:define-refinement-placement "BodyMesh" "BodyMeshDef" "BodyMeshWin" )
(sdedr:define-refinement-function "BodyMeshDef" "DopingConcentration" "MaxTransDiff" 1)

(sdedr:define-refeval-window "ChMeshWin" "Rectangle"  (position SrcCR 0 0)  (position DrnCL 0.05 0) )
(sdedr:define-refinement-placement "ChMesh" "ChMeshDef" "ChMeshWin" )
(sdedr:define-refinement-function "ChMeshDef" "DopingConcentration" "MaxTransDiff" 1)

;----------------------------------------------------------------------------------------------------------------------
; Build Mesh

(sdeaxisaligned:set-parameters 
  "maxAngle" 90
  "xCuts" (list GateL GateR)
  "yCuts" (list 0)
)
(sde:build-mesh "snmesh" "-a" "n@node@_msh")
;----------------------------------------------------------------------------------------------------------------------



