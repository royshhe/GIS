USE [GISData]
GO
/****** Object:  View [dbo].[ViewXContractRevenue]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--***********************************************************
-- Created By Roy He
-- Date: 2003-12-18
--**********************************************************

CREATE VIEW [dbo].[ViewXContractRevenue]
AS
SELECT    Contract_Number, 
dbo.ViewXChargeTypes.Alias AS ChargeCode, Charge_description AS Description, Charge_Type, Quantity AS Qty,
case 
	when    (Unit_Type = 'Item Day') or    (Unit_Type = 'Day')then
		Quantity
	when (Unit_Type = 'Week') or (Unit_Type = 'Item Week') then
		Quantity*7
	when (Unit_Type = 'Hour') then
                Quantity/24
        When (Unit_Type = 'AM') or (Unit_Type = 'PM') or (Unit_Type = 'OV') then
                Quantity/2               
	      	
	else
	0
end  AS [Number of Days], 
                      Unit_Amount AS [Per Unit Cost], GST_Amount + PST_Amount + PVRT_Amount AS [Tax Rates], Amount, '' AS [Calc Parms], '' AS [Calc Order], 
                      '' AS ScVerify, '' AS ScEdit, '' AS ScDelete, '' AS ScCalc, '' AS RevStat, '' AS devDate, '' AS mgmtRef, '' AS Empid
FROM         dbo.Contract_Charge_Item INNER JOIN
                dbo.ViewXChargeTypes ON dbo.Contract_Charge_Item.Charge_Type = dbo.ViewXChargeTypes.Code



--SELECT     dbo.ViewXChargeTypes.[Value], dbo.Contract_Charge_Item.Charge_description, dbo.Contract_Charge_Item.Contract_Number
--FROM         dbo.Contract_Charge_Item INNER JOIN
 --                     dbo.ViewXChargeTypes ON dbo.Contract_Charge_Item.Charge_Type = dbo.ViewXChargeTypes.Code

GO
