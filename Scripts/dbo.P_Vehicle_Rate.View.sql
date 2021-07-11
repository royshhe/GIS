USE [GISData]
GO
/****** Object:  View [dbo].[P_Vehicle_Rate]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[P_Vehicle_Rate]
AS
SELECT     Rate_ID, Effective_Date, Termination_Date, Rate_Name, Location_Fee_Included, Rate_Purpose_ID, Upsell, Flex_Discount_Allowed, Discount_Allowed, 
                      Referral_Fee_Paid, Commission_Paid, Frequent_Flyer_Plans_Honoured, Km_Drop_Off_Charge, Insurance_Transfer_Allowed, Warranty_Repair_Allowed, 
                      Contract_Remarks, Other_Remarks, Special_Restrictions, Manufacturer_ID, GST_Included, PST_Included, PVRT_Included, Update_Ctrl, Violated_Rate_ID, 
                      Violated_Rate_Level, Last_Changed_By, Last_Changed_On, FPO_Purchased, License_Fee_Included, Amount_Markup, ERF_Included, Calendar_Day_Rate
FROM         svbvm032.Geordydata.dbo.Vehicle_Rate AS Vehicle_Rate
WHERE     (Termination_Date IS NULL) OR
                      (Termination_Date > GETDATE())

GO
