USE [GISData]
GO
/****** Object:  View [dbo].[ViewContractOpen]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[ViewContractOpen]
AS
SELECT Vehicle_On_Contract.Contract_Number, 
    Vehicle_On_Contract.Unit_Number, Contract.Last_Name, 
    Contract.First_Name, Vehicle_Class.Vehicle_Class_Name, 
    Contract.Pick_Up_On AS [Check Out Time], 
    Contract.Drop_Off_On AS [Expected Checkin Time]
FROM Contract INNER JOIN
    Vehicle_On_Contract ON 
    Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
     INNER JOIN
    Vehicle_Class ON 
    Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
GO
