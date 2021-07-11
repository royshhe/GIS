USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Accessory_Rental_Lst]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[RP_SP_Accessory_Rental_Lst] --'*', '29 jun 2007'

(
	@paramLocID varchar(20) = '*',
	@RBR_Start_Date varchar(10) 	= '01 JUL 2007',
	@RBR_End_Date 	varchar(10) 	= '01 JUL 2007'
)
AS

-- convert strings to datetime
DECLARE @startDate datetime,
	@endDate datetime

SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @RBR_Start_Date),
	@endDate	= CONVERT(datetime, '23:59:59 ' + @RBR_End_Date)	


DECLARE @tmpLocID varchar(20)
if @paramLocID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramLocID
	END 


SELECT distinct 
	Business_Transaction.RBR_Date, 	
	c.Contract_Number, 
	c.pick_up_on,
	Location1.Location as [Location], 
	c.drop_off_on,
	Location2.Location as [Drop off Location],
    [Appliance Dolly] = sum( CASE WHEN cci.Optional_Extra_ID = 5 THEN coe.Quantity ELSE 0 END), 
    [Child Seat] =sum( CASE WHEN cci.Optional_Extra_ID = 1 THEN coe.Quantity ELSE   0 END), 
    [Blanket] =sum( CASE WHEN cci.Optional_Extra_ID = 7 THEN  coe.Quantity ELSE     0 END), 
    [Booster Seat] = sum( CASE WHEN cci.Optional_Extra_ID = 2 THEN  coe.Quantity ELSE  0 END), 
    [BoxDolly] = sum(CASE WHEN cci.Optional_Extra_ID = 500 THEN  coe.Quantity ELSE 0 END),
    [FlatDolly] =sum( CASE WHEN cci.Optional_Extra_ID = 35 THEN  coe.Quantity ELSE 0 END), 
    [GPS] = sum(CASE WHEN cci.Optional_Extra_ID = 59 THEN coe.Quantity ELSE   0 END), 
    [Ski Rack] = sum(CASE WHEN cci.Optional_Extra_ID = 4 THEN  coe.Quantity ELSE     0 END),
    coe.sold_by
FROM Contract c WITH(NOLOCK) 
INNER JOIN
    Business_Transaction ON c.Contract_Number = Business_Transaction.Contract_Number
    AND Business_Transaction.Transaction_Type = 'Con'
INNER JOIN
    Contract_Charge_Item cci ON 
    c.Contract_Number = cci.Contract_Number
INNER JOIN 
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
    cci.Optional_Extra_ID IN (5, 1, 7, 2, 35, 59, 4))
    AND	(@paramLocID = '*' or CONVERT(INT, @tmpLocID) = c.Pick_Up_Location_ID)
    AND	Business_Transaction.RBR_Date BETWEEN @startDate AND @endDate
group by 
	Business_Transaction.RBR_Date,
	c.Contract_Number, 
	c.pick_up_on,
	Location1.Location,
	c.drop_off_on,
	Location2.Location,
	coe.sold_by


--RETURN @@ROWCOUNT



GO
