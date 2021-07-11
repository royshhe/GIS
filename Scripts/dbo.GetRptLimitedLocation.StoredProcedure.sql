USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptLimitedLocation]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





















/****** Object:  Stored Procedure dbo.GetRptLimitedLocation    Script Date: 2/18/99 12:11:57 PM ******/
/****** Object:  Stored Procedure dbo.GetRptLimitedLocation    Script Date: 2/16/99 2:05:42 PM ******/
/*
PROCEDURE NAME: GetRptLimitedLocation
PURPOSE: To retrieve a list of locations that users at a given
	location are allowed to see.
AUTHOR: Don Kirkby
DATE CREATED: Jan 27, 1999
CALLED BY: ReportParams
MOD HISTORY:
Name    Date        Comments
Don K	Apr 13 1999 Added @LocalOnly & @RentalFlag, stop checking resnet flag
*/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetRptLimitedLocation] --'B-08 McDonald Road'
	@LocName	varchar(25),
	@LocalOnly	varchar(1) = '1',
	@RentalFlag	varchar(1) = '1'
AS
	DECLARE @LocId smallint,
		@bLocalOnly bit,
		@bRentalFlag bit,
		@hub_id smallint,
                @LocalHubOnly bit

	SELECT	@LocName = NULLIF(@LocName, '')

	SELECT	@LocId =(
			SELECT	location_id
			  FROM	location
			 WHERE	location = @LocName
			),
		@bLocalOnly = CAST(@LocalOnly AS bit)

         SELECT @hub_id=(SELECT	Hub_id
			  FROM	location
			 WHERE	location_ID = @LocId)

         SELECT @LocalHubOnly=(SELECT	LocalHubOnly
			  FROM	location
			 WHERE	location_ID = @LocId

         )

	IF @RentalFlag != 'E' -- Either
		SELECT @bRentalFlag = CAST(@RentalFlag AS bit)

	SELECT	location,
		location_id,
--		case location_id
--			when '16' then '17_Acc_CSR_Incentive_Revenue_LDW.rpt'
--			when '20' then '17_Acc_CSR_Incentive_Revenue_Upgrade.rpt'
--			when '59' then '17_Acc_CSR_Incentive_Revenue_Upgrade.rpt'
--			else  '17_Acc_CSR_Incentive_Revenue_Upgrade.rpt'
--		end 
		'17_Acc_CSR_Incentive_Revenue.rpt'
			as ReportName,
		case when location=@LocName then  '1'
				when @LocName='B-03 Downtown' and location='B-11 Cruise Ship' then '1'
				when  @LocName='B-08 McDonald Road'  then '1'-- and (location='B-01 YVR Airport'or location='B-03 Downtown' or location='B-11 Cruise Ship')
				else '0'
		end as DispLocation
		
	  FROM	location loc
	 WHERE	(  owning_company_id =
			(
			SELECT	loc2.owning_company_id
			  FROM	location loc2
			 WHERE	loc2.location_id = @LocId
			)
		OR @bLocalOnly = 0
		)
	   AND	(  rental_location = @bRentalFlag
		OR @RentalFlag = 'E'
		)
	   AND	delete_flag = 0
		/* if the requested location is not a rental location,
		 * then return all rental locations in the company.
		 * Otherwise, just return the requested location.
		 */
	   AND  (  
			(SELECT loc3.rental_location
			  FROM location loc3
			 WHERE loc3.location_id = @LocId
	   	   	) = 0
			OR (
				(location_id in ( SELECT     dbo.AllowedPickupLocation.AllowedPickUPLocationID
				FROM         dbo.AllowedPickupLocation INNER JOIN
				                      dbo.Location ON dbo.AllowedPickupLocation.LocationID = dbo.Location.Location_ID
				where  dbo.Location.Location_ID=@LocId))
	                        or 
	                        (location_id=@LocID)
			   )
             	)

            And (@LocalHubOnly=0 or Hub_id=@hub_id)
	 ORDER   BY	location



















GO
