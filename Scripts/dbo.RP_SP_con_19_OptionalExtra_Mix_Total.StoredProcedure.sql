USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_con_19_OptionalExtra_Mix_Total]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



 
 

--[RP_SP_con_19_OptionalExtra_Mix_Total]  'GPS', '*','2015-04-01', '2015-04-14'

create PROCEDURE [dbo].[RP_SP_con_19_OptionalExtra_Mix_Total]--  '*', '*','2015-04-13', '2015-04-14'
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



	SELECT OEM.Rpt_Date, 
			OEM.Optional_Extra, 
			'Utilization' as Location, 
			'Summary' as Section,
			sum(OEM.On_Rent) On_Rent,
			sum(OEM.Available)+sum(OEM.On_Rent) as Total	
	FROM  dbo.Optional_Extra_Mix AS OEM 
	INNER JOIN dbo.Location AS Loc 
		ON OEM.Current_Location_ID = Loc.Location_ID 
	INNER JOIN dbo.Optional_Extra AS OE 
		ON OEM.Optional_Extra_ID = OE.Optional_Extra_ID
	      
	Where  ( OE.Optional_Extra=  @paramOpExtraType or @paramOpExtraType='*') And 
	(@paramPULocationID = '*' or CONVERT(INT, @tmpLocID) =OEM.Current_Location_ID)
	 
	and OEM.Rpt_Date between @paramStartDate and @paramEndDate
	group by OEM.Rpt_Date,OEM.Optional_Extra



RETURN @@ROWCOUNT


--select * from Optional_Extra_Inventory where unit_number='201116D'

--select * from Contract_Optional_Extra where unit_number='201116D'





GO
