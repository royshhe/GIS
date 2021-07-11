USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_10_Build_Up_On_Rent]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
PROCEDURE NAME: RP_SP_Res_10_Build_Up_On_Rent
PURPOSE: Select all information needed for Reservation Build Up On Rent Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY:  Reservation Build Up On Rent Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	Sep 4 1999	add filtering to improve performance
*/

CREATE PROCEDURE [dbo].[RP_SP_Res_10_Build_Up_On_Rent] --'car','*', '*','*', 'roy he'    
  
(
	@paramVehicleTypeID varchar(18) = 'car',
	@paramVehicleClassID char(1) = '*',
	@paramPickUpLocationID varchar(20) = '*',
	@paramHubID varchar(6)='*',
	@userID varchar(20)='roy he'
)
AS

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(20)
DECLARE @iCounter int
 
SELECT @iCounter=Count(*)
		FROM  dbo.RP_Run_Loc_Restriction INNER JOIN
               dbo.GISUsers ON dbo.RP_Run_Loc_Restriction.User_ID = dbo.GISUsers.user_id
               where dbo.GISUsers.user_name=@userID

if @paramPickUpLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramPickUpLocationID
	END 


DECLARE  @intHubID varchar(6)

if @paramHubID = ''
	select @paramHubID = '*'

if @paramHubID = '*'
	BEGIN
		SELECT @intHubID='0'
        END
else
	BEGIN
		SELECT @intHubID = @paramHubID
	END 

-- end of fixing the problem


SELECT 	
	Rpt_Date,
	RP_Res_10_Build_Up_On_Rent_Summary_L3_Main.Location_ID,
	RP_Res_10_Build_Up_On_Rent_Summary_L3_Main.Location_Name,
    	Vehicle_Type_ID,
	Vehicle_Class_Code,
    	Vehicle_Class_Name,
    	Vehicle_Class_Code_Name,
	Cdt_Cnt,
    	Cor1_Cnt,
	Cor2_Cnt,
	Cor3_Cnt,
    	Od_Cnt,
	Rdt1_Cnt,
	Rdt2_Cnt,
	Rpu1_Cnt,
    	Rpu2_Cnt,
	DisplayOrder

FROM 	RP_Res_10_Build_Up_On_Rent_Summary_L3_Main inner join Location on RP_Res_10_Build_Up_On_Rent_Summary_L3_Main.Location_id=Location.Location_id

WHERE
	(@paramVehicleTypeID = '*' OR Vehicle_Type_ID = @paramVehicleTypeID)
	AND
 	(@paramVehicleClassID = '*' OR Vehicle_Class_Code = @paramVehicleClassID)
	AND
	(@paramPickUpLocationID = '*' or CONVERT(INT, @tmpLocID) = Location.Location_ID)
	AND
	(@paramHubID = '*' or CONVERT(INT, @intHubID) = Location.Hub_ID)
	And 
	(	@iCounter=0 or
		Location.Location_ID In 
		(SELECT dbo.RP_Run_Loc_Restriction.Location_ID 
			FROM  dbo.RP_Run_Loc_Restriction INNER JOIN
            dbo.GISUsers ON dbo.RP_Run_Loc_Restriction.User_ID = dbo.GISUsers.user_id
            where dbo.GISUsers.user_name=@userID
		)
	)
GO
