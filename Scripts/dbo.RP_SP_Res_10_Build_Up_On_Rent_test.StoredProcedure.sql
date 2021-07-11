USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_10_Build_Up_On_Rent_test]    Script Date: 2021-07-10 1:50:50 PM ******/
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

CREATE PROCEDURE [dbo].[RP_SP_Res_10_Build_Up_On_Rent_test]
(
	@paramVehicleTypeID varchar(18) = 'car',
	@paramVehicleClassID char(1) = '*',
	@paramPickUpLocationID varchar(20) = '*',
	@paramHubID varchar(6)='*'
)
AS

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(20)

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
	BU.Location_ID,
	BU.Location_Name,
    BU.Vehicle_Type_ID ,
	isnull(Vehicle_Class_Code,'A') as Vehicle_Class_Code,
    isnull(Vehicle_Class_Name,'Economy') as Vehicle_Class_Name,
    isnull(Vehicle_Class_Code_Name,'A-Economy') as Vehicle_Class_Code_Name,
	isnull(Cdt_Cnt,'0') as Cdt_Cnt,
    isnull(Cor1_Cnt,'0') as Cor1_Cnt,
	isnull(Cor2_Cnt,'0') as Cor2_Cnt,
	isnull(Cor3_Cnt,'0') as Cor3_Cnt,
    isnull(Od_Cnt,'0') as Od_Cnt,
	isnull(Rdt1_Cnt,'0') as Rdt1_Cnt,
	isnull(Rdt2_Cnt,'0') as Rdt2_Cnt,
	isnull(Rpu1_Cnt,'0') as Rpu1_Cnt,
    isnull(Rpu2_Cnt,'0') as Rpu2_Cnt,
	isnull(DisplayOrder,'10') as DisplayOrder

FROM 	
	( select	base.Rpt_Date,
				base.Location_ID,
				base.Location_Name,
				base.Vehicle_Type_ID ,
				main.Vehicle_Class_Code,
    			main.Vehicle_Class_Name,
    			main.Vehicle_Class_Code_Name,
				main.Cdt_Cnt,
    			main.Cor1_Cnt,
				main.Cor2_Cnt,
				main.Cor3_Cnt,
    			main.Od_Cnt,
				main.Rdt1_Cnt,
				main.Rdt2_Cnt,
				main.Rpu1_Cnt,
    			main.Rpu2_Cnt,
				main.DisplayOrder
				 from  RP_Res_10_Build_Up_On_Rent_Summary_L3_Base_3 Base 
		left join RP_Res_10_Build_Up_On_Rent_Summary_L3_Main main 
			on Base.rpt_date=main.rpt_date and Base.location_id=main.location_id and base.Vehicle_Type_ID=main.Vehicle_Type_ID) BU
		inner join Location on BU.Location_id=Location.Location_id

WHERE
	(@paramVehicleTypeID = '*' OR Vehicle_Type_ID = @paramVehicleTypeID or Vehicle_Type_ID is null)
	AND
 	(@paramVehicleClassID = '*' OR Vehicle_Class_Code = @paramVehicleClassID  )
	AND
	(@paramPickUpLocationID = '*' or CONVERT(INT, @tmpLocID) = Location.Location_ID )
	AND
	(@paramHubID = '*' or CONVERT(INT, @intHubID) = Location.Hub_ID)

	and Vehicle_Class_Code is not null


GO
