USE [GISData]
GO
/****** Object:  View [dbo].[RP__Vehicle_Status_Dates]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[RP__Vehicle_Status_Dates]
as
SELECT     Unit_Number, 
CONVERT(Datetime, Max((CASE WHEN Status = 'Owned' THEN CONVERT(numeric(10, 4), Effective_On) ELSE NULL END))) AS OwnedDate, 
CONVERT(Datetime, Max((CASE WHEN Status = 'Sold' THEN CONVERT(numeric(10, 4), Effective_On) ELSE NULL END))) AS SoldDate,
CONVERT(Datetime, Max((CASE WHEN Status = 'Drop Ship' THEN CONVERT(numeric(10, 4), Effective_On) ELSE NULL END))) AS DropShipDate,
CONVERT(Datetime, Max((CASE WHEN Status = 'Held' THEN CONVERT(numeric(10, 4), Effective_On) ELSE NULL END))) AS HeldDate,
CONVERT(Datetime, Max((CASE WHEN Status = 'Lease' THEN CONVERT(numeric(10, 4), Effective_On) ELSE NULL END))) AS LeaseDate,
CONVERT(Datetime, Max((CASE WHEN Status = 'Pulled For Disposal' THEN CONVERT(numeric(10, 4), Effective_On) ELSE NULL END))) AS PulledForDisposalDate,
CONVERT(Datetime, Max((CASE WHEN Status = 'Rental' THEN CONVERT(numeric(10, 4), Effective_On) ELSE NULL END))) AS RentalDate,
CONVERT(Datetime, Max((CASE WHEN Status = 'Signed Off' THEN CONVERT(numeric(10, 4), Effective_On) ELSE NULL END))) AS SignedOffDate,
CONVERT(Datetime, Max((CASE WHEN Status = 'Stolen' THEN CONVERT(numeric(10, 4), Effective_On) ELSE NULL END))) AS StolenDate,
CONVERT(Datetime, Max((CASE WHEN Status = 'Written Off' THEN CONVERT(numeric(10, 4), Effective_On) ELSE NULL END))) AS WrittenOffDate
FROM         dbo.RP__Vehicle_Status_History
GROUP BY Unit_Number

         

GO
