USE [GISData]
GO
/****** Object:  View [dbo].[getclaimscontract]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*
VIEW NAME: getclaimscontract
PURPOSE: Select contract information based on contract number for CARS program

AUTHOR:	Junaid Ahmed
DATE CREATED: 2002 Feb 26
USED BY: Enter Vehicle Accident Screen

MOD HISTORY:
Name 		Date		Comments

*/

CREATE VIEW [dbo].[getclaimscontract]
AS

SELECT   
                      dbo.Contract.Last_Name, dbo.Contract.First_Name, dbo.Contract.Birth_Date, dbo.Contract.Gender, 
                      --dbo.Contract.Phone_Number,
                      (isnull(dbo.Contract.Phone_Number,'') +'/' + isnull(dbo.contract.Company_Phone_Number,'') + '/' + isnull(dbo.contract.Local_Phone_Number,'')) as Phone_Number, 
                      dbo.Contract.Address_1, dbo.Contract.City, dbo.Contract.Postal_Code, dbo.Contract.Company_Name, dbo.Contract.Country, 
                      dbo.Contract.Contract_Number, dbo.Contract.Address_2,vehicle_on_contract.unit_number, dbo.contract.Province_State

FROM   
contract,vehicle_on_contract
where
contract.contract_number=vehicle_on_contract.contract_number











GO
