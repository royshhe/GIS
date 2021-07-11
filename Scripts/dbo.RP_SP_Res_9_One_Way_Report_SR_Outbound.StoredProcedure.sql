USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_9_One_Way_Report_SR_Outbound]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Res_9_One_Way_Report_SR_Outbound
PURPOSE: Select all information needed for Outbound Company subreport of Reservation One Way Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/24
USED BY:   Outbound Company subreport of Reservation One Way Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE PROCEDURE [dbo].[RP_SP_Res_9_One_Way_Report_SR_Outbound]
(
	@paramVehicleTypeID char(5) = '*',
	@paramVehicleClassID char(1) = '*',
	@paramInboundCompanyID varchar(20) = '5555',
	@paramInboundLocationID varchar(20) = '*',
	@paramOutboundLocationID varchar(20) = '*'
)
AS

DECLARE @sStartDate varchar(12),
	@sEndDate varchar(12),
	@dStartDate datetime,
	@dEndDate datetime

-- extract the date part of datetime string
SELECT 	@sStartDate	= CONVERT(datetime, CONVERT(varchar(12), getDate(), 112)),
	@sEndDate	= CONVERT(datetime, CONVERT(varchar(12), DATEADD(dd, 6, getDate()), 112))

-- need data starting from Start Date 00:00:00 to End Date 23:59:59
SELECT	@dStartDate	= CONVERT(datetime, '00:00:00 ' + @sStartDate),
	@dEndDate	= CONVERT(datetime, '23:59:59 ' + @sEndDate)	

-- fix upgrading problem (SQL7->SQL2000)
DECLARE 	@tmpInboundLocID varchar(20), 
		@tmpInboundCompanyID varchar(20),
		@tmpOutboundLocID varchar(20)

if @paramInboundLocationID = '*'
	BEGIN
		SELECT @tmpInboundLocID='0'
        	END
else
	BEGIN
		SELECT @tmpInboundLocID = @paramInboundLocationID
	END 

if @paramInboundCompanyID = '*'
	BEGIN
		SELECT @tmpInboundCompanyID = '0'
	END
else 
	BEGIN
		SELECT @tmpInboundCompanyID = @paramInboundCompanyID
	END

if @paramOutboundLocationID ='*'
	BEGIN
		SELECT @tmpOutboundLocID = '0'
	END
else 
	BEGIN
		SELECT @tmpOutboundLocID = @paramOutboundLocationID
	END
-- end of fixing the problem

SELECT 	ID,
    	Outbound_Pick_Up_Date,
    	Outbound__Location_ID,
	Outbound_Location_Name,
    	Outbound_Location_OC_Name,
    	Outbound_Rental_Location_Flag,
    	Inbound_Drop_Off_Date,
    	Inbound__Location_ID,
	Inbound_Location_Name,
    	Inbound_Location_OC_ID,
    	Inbound_Location_OC_Name,
    	Inbound_Rental_Location_Flag,
    	Vehicle_Type_ID,
	Vehicle_Class_Code,
    	Vehicle_Class_Code_Name,
	Status

FROM	RP_Res_9_One_Way_Report_L1_Main  with(nolock) 

WHERE	(@paramVehicleTypeID = "*" OR Vehicle_Type_ID = @paramVehicleTypeID)
	AND
	(@paramVehicleClassID = "*" OR Vehicle_Class_Code = @paramVehicleClassID)
	AND
	(@paramInboundCompanyID = "*" OR CONVERT(INT, @tmpInboundCompanyID) = Inbound_Location_OC_ID)
	AND
	(@paramInboundLocationID = "*" or CONVERT(INT, @tmpInboundLocID) = Inbound__Location_ID)
	AND
	(@paramOutboundLocationID = "*" or CONVERT(INT, @tmpOutboundLocID) = Outbound__Location_ID)
	AND
	Outbound_Pick_Up_Date BETWEEN @dStartDate AND @dEndDate

GO
