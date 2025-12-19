proj_load  @plot@ LIN
cv_createDS IdVg "LIN gate OuterVoltage" "LIN drain TotalCurrent" y

load_library EXTRACT

set Vt [ExtractVti Vt IdVg 1e-7]
set Ioff [ExtractValue Ioff IdVg 0]
set Ion [ExtractValue Ion IdVg 1.5]
set gmmax [ExtractGm gmmax IdVg]
