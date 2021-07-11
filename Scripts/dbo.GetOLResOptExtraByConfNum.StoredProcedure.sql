USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOLResOptExtraByConfNum]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetOLResOptExtraByConfNum]
	@ConfirmNum Varchar(20),
	@VehClassCode char(1),
	@PickupDate varchar(24)
AS 
	SELECT @ConfirmNum = NULLIF(@ConfirmNum,'')
	
	SELECT     dbo.Optional_Extra.Optional_Extra_Name, dbo.Optional_Extra.Optional_Extra_ID,dbo.Optional_Extra.Description, dbo.Optional_Extra_Price.Daily_Rate, 
	                      dbo.Optional_Extra_Price.Weekly_Rate, dbo.Optional_Extra_Price.GST_Exempt,dbo.Optional_Extra_Price.HST2_Exempt, dbo.Optional_Extra_Price.PST_Exempt, 
	                      dbo.Optional_Extra.Maximum_Quantity, dbo.Optional_Extra.Type, dbo.Reserved_Rental_Accessory.Quantity, '' AS RentalPeriod, 
	                      CONVERT(Varchar(10), dbo.LDW_Deductible.LDW_Deductible) AS Deductible
	FROM         dbo.Reserved_Rental_Accessory INNER JOIN
	                      dbo.Optional_Extra ON dbo.Reserved_Rental_Accessory.Optional_Extra_ID = dbo.Optional_Extra.Optional_Extra_ID INNER JOIN
	                      dbo.Optional_Extra_Price ON dbo.Optional_Extra.Optional_Extra_ID = dbo.Optional_Extra_Price.Optional_Extra_ID LEFT OUTER JOIN
	                      dbo.LDW_Deductible ON dbo.Optional_Extra.Optional_Extra_ID = dbo.LDW_Deductible.Optional_Extra_ID And dbo.LDW_Deductible.Vehicle_Class_Code =@VehClassCode
	WHERE	Confirmation_Number = Convert(Int, @ConfirmNum) 
		AND Convert(Datetime, NULLIF(@PickupDate,''))
		BETWEEN Optional_Extra_Price.Optional_Extra_Valid_From  AND ISNULL(Optional_Extra_Price.Valid_To,Convert(Datetime, '31 Dec 2078 23:59'))
		
		RETURN @@ROWCOUNT
GO
