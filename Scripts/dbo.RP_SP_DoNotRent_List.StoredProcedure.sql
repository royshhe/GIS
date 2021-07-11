USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_DoNotRent_List]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RP_SP_DoNotRent_List] 

@StartDateInput varchar(30)='Jun 01 2005', 
@EndDateInput varchar(30)='Jun 30 2005'

AS
SET NOCOUNT ON 

DECLARE @StartDate datetime, @EndDate datetime
SELECT @StartDate = CONVERT(DATETIME, @StartDateInput)
SELECT @EndDate = CONVERT(DATETIME, @EndDateInput)
	
SELECT Customer_ID, Last_Name, First_Name, Address_1, Address_2, City, Province, 
      Country, Postal_Code, Phone_Number, Email_Address, Birth_Date, 
      Driver_Licence_Number, Driver_Licence_Expiry, Jurisdiction, Last_Changed_By, 
      Last_Changed_On, Remarks
FROM dbo.Customer

WHERE (Do_Not_Rent = 1) AND (Last_Changed_By <> 'gistest')
	and Last_Changed_On between @StartDate and @EndDate
GO
