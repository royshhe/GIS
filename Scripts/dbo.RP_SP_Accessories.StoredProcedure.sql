USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Accessories]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RP_SP_Accessories] AS

SELECT c.Contract_Number, 
	Location1.Location as [Pick up Location],
	Location2.Location as [Drop off Location],	 
    [Child Seat] = CASE WHEN cci.Optional_Extra_ID = 1 THEN 1 ELSE
     0 END, 
    [Booster Seat] = CASE WHEN cci.Optional_Extra_ID = 2 THEN 1 ELSE
     0 END, 
    [Infant Seat] = CASE WHEN cci.Optional_Extra_ID = 3 THEN 1 ELSE
     0 END, 
    [Appliance Dolly] = CASE WHEN cci.Optional_Extra_ID = 5 THEN
     1 ELSE 0 END, 
    [Dolly] = CASE WHEN cci.Optional_Extra_ID = 6 THEN 1 ELSE 0 END,
     [Dolly - Flat] = CASE WHEN cci.Optional_Extra_ID = 35 THEN 1 ELSE
     0 END, 
    [Blanket] = CASE WHEN cci.Optional_Extra_ID = 7 THEN 1 ELSE
     0 END, 
    [Ski Rack] = CASE WHEN cci.Optional_Extra_ID = 4 THEN 1 ELSE
     0 END
FROM Contract c WITH(NOLOCK) 
INNER JOIN
    Contract_Charge_Item cci ON 
    c.Contract_Number = cci.Contract_Number
LEFT JOIN
    Location1 ON 
    c.Pick_Up_Location_ID = Location1.Location_ID
LEFT JOIN
    Location2 on
    c.Drop_off_Location_ID = Location2.Location_ID
WHERE (c.Status = 'co') AND (cci.Charge_Type = 12 AND 
    cci.Optional_Extra_ID IN (1, 2, 3, 4, 5, 6, 7, 35))
GO
