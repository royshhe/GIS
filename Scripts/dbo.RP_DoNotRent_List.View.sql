USE [GISData]
GO
/****** Object:  View [dbo].[RP_DoNotRent_List]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RP_DoNotRent_List]
AS
SELECT Customer_ID, Last_Name, First_Name, Address_1, Address_2, City, Province, 
      Country, Postal_Code, Phone_Number, Email_Address, Birth_Date, 
      Driver_Licence_Number, Driver_Licence_Expiry, Jurisdiction, Last_Changed_By, 
      Last_Changed_On, Remarks
FROM dbo.Customer
WHERE (Do_Not_Rent = 1) AND (Last_Changed_By <> 'gistest')
GO
