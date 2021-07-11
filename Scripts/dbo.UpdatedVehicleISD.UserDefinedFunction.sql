USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[UpdatedVehicleISD]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[UpdatedVehicleISD] 
(
  @pUnitNumber Int
)

RETURNS DateTime
AS
BEGIN
Declare @ISD DateTime
Declare @GISISD DateTime
Declare @manufacturerISD DateTime

Select @manufacturerISD=dbo.FA_Repurchase_Eligibility.ISD from  Vehicle V Inner Join dbo.FA_Repurchase_Eligibility ON V.Serial_Number = dbo.FA_Repurchase_Eligibility.Vin
Where V.Unit_Number=@pUnitNumber And V.Program=1

Select @GISISD=  dbo.VehicleISD(@pUnitNumber)
 

Select @ISD=
	(Case --When V.ISD Is not Null Then V.ISD
             When @manufacturerISD Is not Null  and @GISISD Is Null Then @manufacturerISD
			 When @GISISD Is Not Null  and @manufacturerISD is Null Then @GISISD
			 When @GISISD Is Not Null  and @manufacturerISD is Not Null Then 
					(Case When @GISISD>=@manufacturerISD Then @GISISD Else @manufacturerISD End)
               When @GISISD Is   Null  and @manufacturerISD is   Null Then Null
   End) From Vehicle V
   where V.Unit_Number=@pUnitNumber 

Return @ISD

End

GO
