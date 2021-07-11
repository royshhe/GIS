USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[VehiclePFDDays]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[VehiclePFDDays] 
(
  @pUnitNumber Int,
  @pStartDate DateTime,
  @pEndDate DateTime
)

RETURNS Int
AS
BEGIN

Declare @VehPFDFrom DateTime
Declare @VehPFDTo DateTime
Declare @Days Int


select @VehPFDFrom=PFDFrom, @VehPFDTo=PFDTo
from Vehicle_PullForDisposal_Periods_vw
where  unit_number  =@pUnitNumber
and (PFDFrom>=@pStartDate and PFDFrom <=@pEndDate
		or PFDTo<=@pEndDate and PFDTo>=@pStartDate)


Select @Days= 
		(Case 
			When  @VehPFDFrom is  Not Null And @VehPFDFrom> @pStartDate and @VehPFDTo<=@pEndDate
					 Then datediff(day,@VehPFDFrom,@VehPFDTo)
			When   @VehPFDFrom is  Not Null And @VehPFDFrom> @pStartDate and @VehPFDTo>@pEndDate
					 Then datediff(day,@VehPFDFrom,@pEndDate)
			When  @VehPFDTo is  Not Null And @VehPFDTo<=@pEndDate and @VehPFDTo>=@pStartDate and @VehPFDFrom<=@pStartDate
					 Then datediff(day,@pStartDate,@VehPFDTo)
	            
			else 0
	END)






Return @Days

End
GO
