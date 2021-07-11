USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptLocation]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO














/****** Object:  Stored Procedure dbo.GetRptLocation    Script Date: 2/18/99 12:11:57 PM ******/
/****** Object:  Stored Procedure dbo.GetRptLocation    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRptLocation    Script Date: 1/11/99 1:03:17 PM ******/
/*
PROCEDURE NAME: GetRptLocation
PURPOSE: To retrieve a list of locations for an owning company
AUTHOR: Don Kirkby
DATE CREATED: Jan 5, 1999
CALLED BY: ReportParams
PARAMS:
  CompanyId	If it is '' we return locations for all companies.
  RentalOnly	If it is '0' we ignore the rental_location and resnet flags.
  LocalOnly	If it is '1' and CompanyId is '' we use the local owning company
		(i.e., BRAC BC)
MOD HISTORY:
Name    Date        Comments
Don K	Feb 12 1999 Handle @CompanyId = '' as all companies
Don K	Feb 15 1999 Added @RentalOnly
Don K	Apr 13 1999 Added @ResnetFlag and @RentalFlag
*/
CREATE PROCEDURE [dbo].[GetRptLocation]
	@CompanyId	varchar(6),
	@RentalOnly	varchar(1),
	@LocalOnly	varchar(1),
	@ResnetFlag	varchar(1) = '1',
	@RentalFlag	varchar(1) = '1',
	@HubID                varChar(6)='*'
AS
	DECLARE @bResnet bit,
		@bRental bit

IF @CompanyId = '' AND @LocalOnly = '1'
	SELECT	@CompanyId =
		(
		SELECT	code
		  FROM	lookup_table
		 WHERE	category = 'BudgetBC Company'
		)

IF @RentalOnly = '1'
	SELECT	@ResnetFlag = '1',
		@RentalFlag = '1'
ELSE IF (@RentalOnly = '0' or @RentalOnly = '')
	SELECT	@ResnetFlag = 'E',
		@RentalFlag = 'E'

IF @ResnetFlag != 'E'
	SELECT	@bResnet = CAST(@ResnetFlag AS bit)

IF @RentalFlag != 'E'
	SELECT	@bRental = CAST(@RentalFlag AS bit)

if @HubID='' 
	SELECT       @HubID='*'

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @intHubID varchar(6)

if @HubID = '*'
	BEGIN
		SELECT @intHubID='0'
        END
else
	BEGIN
		SELECT @intHubID = @HubID
	END 
-- end of fixing the problem

	SELECT	location,
		location_id
	  FROM	location
	 WHERE	(  @CompanyId = ''
		OR owning_company_id =
			CONVERT(smallint, @CompanyId)
		)
	   AND	(  rental_location = @bRental
		OR @RentalFlag = 'E'
		)
	   AND	(  resnet = @bResnet
		OR @ResnetFlag = 'E'
		)
	   AND	delete_flag = 0
	   AND( (Hub_ID=CONVERT(smallint, @intHubID)) or @HubID='*')
	 ORDER
	    BY	location




set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
