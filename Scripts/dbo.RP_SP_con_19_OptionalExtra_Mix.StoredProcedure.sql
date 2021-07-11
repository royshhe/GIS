USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_con_19_OptionalExtra_Mix]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






 
 



CREATE PROCEDURE [dbo].[RP_SP_con_19_OptionalExtra_Mix] --'Seat', '*','2015-11-01', '2015-11-30'
(
	@paramOpExtraType varchar(18) = 'GPS',
	@paramPULocationID varchar(20) = '16',
	@paramStartDate varchar(20) ='01 jun 2014',
	@paramEndDate varchar(20) ='30 Jun 2014'
	
)
AS

DECLARE  @tmpLocID varchar(20)
 
if @paramPULocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramPULocationID
	END 

select 	Rpt_Date, 
		Optional_Extra, 
		Location, 
		Section, 
		ItemNumber
from 
	(SELECT OEM.Rpt_Date, 
			OEM.Optional_Extra, 
			Loc.Location, 
			'On_Rent' as Section,
			OEM.On_Rent as ItemNumber
	FROM  dbo.Optional_Extra_Mix AS OEM 
	INNER JOIN dbo.Location AS Loc 
		ON OEM.Current_Location_ID = Loc.Location_ID 
	INNER JOIN dbo.Optional_Extra AS OE 
		ON OEM.Optional_Extra_ID = OE.Optional_Extra_ID
	      
	Where  ( OE.Optional_Extra like '%'+@paramOpExtraType+'%' or @paramOpExtraType='*') And 
	(@paramPULocationID = '*' or CONVERT(INT, @tmpLocID) =OEM.Current_Location_ID)
	 
	and OEM.Rpt_Date between @paramStartDate and @paramEndDate

	Union

	SELECT OEM.Rpt_Date, 
			OEM.Optional_Extra, 
			Loc.Location, 
			'Available' as Section,
			OEM.Available as ItemNumber
	FROM  dbo.Optional_Extra_Mix AS OEM 
	INNER JOIN dbo.Location AS Loc 
		ON OEM.Current_Location_ID = Loc.Location_ID 
	INNER JOIN dbo.Optional_Extra AS OE 
		ON OEM.Optional_Extra_ID = OE.Optional_Extra_ID
	      
	Where  ( OE.Optional_Extra like '%'+@paramOpExtraType+'%'  or @paramOpExtraType='*') And 
	(@paramPULocationID = '*' or CONVERT(INT, @tmpLocID) =OEM.Current_Location_ID)
	 
	and OEM.Rpt_Date between @paramStartDate and @paramEndDate

	)  OEItem


order by OEItem.Optional_Extra




RETURN @@ROWCOUNT


--select * from Optional_Extra_Inventory where unit_number='201116D'

--select * from Contract_Optional_Extra where unit_number='201116D'








GO
