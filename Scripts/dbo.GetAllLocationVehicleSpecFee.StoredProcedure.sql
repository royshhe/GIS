USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllLocationVehicleSpecFee]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create Procedure [dbo].[GetAllLocationVehicleSpecFee]
	@LocID As varchar(5)
AS
Select 	LocationVC_Specific_Fee_ID,
		VF.Vehicle_Class_Code,
		V.Vehicle_Class_Name,
		Fee_Type,
		Fee_Description,
          Type = Case when Flat_Fee is not null 
		Then 'Flat'
		Else Case when percentage_fee is not null 
			Then 'Percent'
			Else 'Per Day'
			End
		End,
	Amount = Case when Flat_Fee is not null 
		Then Flat_Fee
		Else Case when percentage_fee is not null 
			Then Percentage_fee
			Else Per_Day_Fee
			End
		End,
	Valid_From,
	Valid_To,
	Location_ID	
From LocationVC_Specific_Fee VF
Left join Vehicle_Class V on VF.Vehicle_Class_Code = V.Vehicle_Class_Code
Where Location_ID = @LocID
GO
