USE [GISData]
GO
/****** Object:  View [dbo].[ViewChildSeat]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[ViewChildSeat]
AS
SELECT distinct c.Contract_Number, 
	c.pick_up_on,
	Location1.Location as [Location], 
	c.drop_off_on,
	Location2.Location as [Drop off Location],
    [Child Seat] =sum( CASE WHEN cci.Optional_Extra_ID = 1 THEN coe.Quantity ELSE
     0 END), 
    [Booster Seat] = sum( CASE WHEN cci.Optional_Extra_ID = 2 THEN  coe.Quantity ELSE
     0 END), 
    [Infant Seat] = sum(CASE WHEN cci.Optional_Extra_ID = 3 THEN coe.Quantity ELSE
     0 END), 
    [Appliance Dolly] = sum( CASE WHEN cci.Optional_Extra_ID = 5 THEN
      coe.Quantity ELSE 0 END), 
    [Dolly] = sum(CASE WHEN cci.Optional_Extra_ID = 6 THEN  coe.Quantity ELSE 0 END),
     [Dolly - Flat] =sum( CASE WHEN cci.Optional_Extra_ID = 35 THEN  coe.Quantity ELSE
     0 END), 
    [Blanket] =sum( CASE WHEN cci.Optional_Extra_ID = 7 THEN  coe.Quantity ELSE
     0 END), 
    [Ski Rack] = sum(CASE WHEN cci.Optional_Extra_ID = 4 THEN  coe.Quantity ELSE
     0 END)
FROM Contract c WITH(NOLOCK) 
INNER JOIN
    Contract_Charge_Item cci ON 
    c.Contract_Number = cci.Contract_Number
inner join 
    Contract_Optional_Extra coe on
    cci.contract_number = coe.contract_number
    and cci.Optional_Extra_ID = coe.Optional_Extra_ID
LEFT JOIN
    Location Location1 ON 
    c.Pick_Up_Location_ID = Location1.Location_ID
LEFT JOIN
    Location Location2 on
    c.Drop_off_Location_ID = Location2.Location_id
WHERE (c.Status = 'co') AND (cci.Charge_Type = 12 AND 
    cci.Optional_Extra_ID IN (1, 2, 3, 4, 5, 6, 7, 35))
group by c.Contract_Number, 
	c.pick_up_on,
	Location1.Location,
	c.drop_off_on,
	Location2.Location








GO
