USE [GISData]
GO
/****** Object:  View [dbo].[ViewIncentiveUpsellChecking]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[ViewIncentiveUpsellChecking]
AS
SELECT     CSR_Name, Contract_number, Contract_Revenue - Reservation_Revenue AS UpSell, Pick_Up_Location_ID
FROM         dbo.RP_Acc_12_CSR_Incremental_Yield_L2
WHERE     (RBR_Date BETWEEN '2003-09-01' AND '2003-09-30') AND (Contract_Revenue > Reservation_Revenue) AND (Pick_Up_Location_ID IN (20, 23, 26, 31))







GO
