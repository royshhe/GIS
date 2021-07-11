USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateLevelByBCDNum]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[GetRateLevelByBCDNum] -- 'A162000','2011-06-07 12:00', 'c','20','20', '01I'
	@BCDNum varchar(10),
	@PickupDate varchar(20),
	@VehClassCode	Varchar(1),	
	@PULocId	VarChar(15),
	@DOLocID varchar(15),
	@MaestroRate varchar(10)=''
AS

DECLARE	@dPickup datetime
-- truncate time portion from pick up date/time
SELECT	@dPickup =convert (datetime,@PickupDate)
 
 
	SELECT distinct  ORGR.Rate_ID, ORGR.Rate_Level
	FROM    dbo.Organization AS Org 
			INNER JOIN dbo.Organization_Rate AS ORGR 
				ON Org.Organization_ID = ORGR.Organization_ID 
			INNER JOIN dbo.Rate_Charge_Amount AS RCA 
				ON ORGR.Rate_ID = RCA.Rate_ID 
			INNER JOIN dbo.Rate_Vehicle_Class AS RVC 
				ON RCA.Rate_Vehicle_Class_ID = RVC.Rate_Vehicle_Class_ID AND RCA.Rate_ID = RVC.Rate_ID 
			INNER JOIN dbo.Rate_Time_Period AS RTP 
				ON RCA.Rate_ID = RTP.Rate_ID AND RCA.Rate_Time_Period_ID = RTP.Rate_Time_Period_ID
			INNER JOIN dbo.Vehicle_Rate VR
				On ORGR.Rate_ID=VR.Rate_ID
			INNER JOIN dbo.Rate_Purpose 
				On VR.Rate_Purpose_ID=dbo.Rate_Purpose.Rate_Purpose_ID
			INNER JOIN
                      dbo.Rate_Availability AS VRA ON VR.Rate_ID = VRA.Rate_ID
				
			--INNER JOIN dbo.Rate_Location_Set_Member AS RLSM 		
			--    ON RCA.Rate_ID = RLSM.Rate_ID
	Where Org.BCD_Number = @BCDNum
	And ORGR.Termination_Date = 'Dec 31 2078 11:59PM'
	And @dPickup BETWEEN ORGR.Valid_From AND ISNULL(ORGR.Valid_To, @dPickup)
	And RVC.Vehicle_Class_Code=@VehClassCode And  ISNULL(RVC.Termination_Date, '2078-12-31 23:59')>GETDATE()	
	And @dPickup BETWEEN VRA.Valid_From AND ISNULL(VRA.Valid_To, @dPickup) And ISNULL(VRA.Termination_Date, '2078-12-31 23:59')>GETDATE()
	and (@MaestroRate='' or ORGR.Maestro_Rate='' or ORGR.Maestro_Rate is null or ORGR.Maestro_Rate like '%'+rtrim(ltrim(@MaestroRate))+'%')	
	
	And 
		(
		ORGR.Rate_ID in (
		SELECT     RLS.Rate_ID
		FROM         dbo.Rate_Location_Set AS RLS INNER JOIN
					 dbo.Rate_Location_Set_Member AS RLSM ON RLS.Rate_ID = RLSM.Rate_ID AND RLS.Rate_Location_Set_ID = RLSM.Rate_Location_Set_ID INNER JOIN
					 dbo.Rate_Drop_Off_Location AS RDL ON RLS.Rate_ID = RDL.Rate_ID AND RLS.Rate_Location_Set_ID = RDL.Rate_Location_Set_ID
		Where	 
				--(@dPickup BETWEEN RLS.Effective_Date AND  ISNULL(RLS.Termination_Date, '2078-12-31 23:59')) 
			 --And (@dPickup BETWEEN RLSM.Effective_Date AND  ISNULL(RLSM.Termination_Date, '2078-12-31 23:59'))
				 ISNULL(RLS.Termination_Date, '2078-12-31 23:59')>getdate()
			 And ISNULL(RLSM.Termination_Date, '2078-12-31 23:59')>getdate()
			 And (RLSM.location_id = @PULocId)
			 And (RDL.Location_ID=@DOLocID)
		 )
		 Or
		 (
			dbo.Rate_Purpose.Rate_Purpose <>'Tour Pkg'			
			AND 
			ORGR.Rate_ID
			In		     
			(
			SELECT     RLS.Rate_ID
			FROM         dbo.Rate_Location_Set AS RLS INNER JOIN
						 dbo.Rate_Location_Set_Member AS RLSM ON RLS.Rate_ID = RLSM.Rate_ID AND RLS.Rate_Location_Set_ID = RLSM.Rate_Location_Set_ID 				 
			Where	
				 --(@dPickup BETWEEN RLS.Effective_Date AND  ISNULL(RLS.Termination_Date, '2078-12-31 23:59')) 
				 --And (@dPickup BETWEEN RLSM.Effective_Date AND ISNULL(RLSM.Termination_Date, '2078-12-31 23:59'))
					 ISNULL(RLS.Termination_Date, '2078-12-31 23:59')>getdate()
				 And ISNULL(RLSM.Termination_Date, '2078-12-31 23:59')>getdate()
				 And (RLSM.location_id = @PULocId)
				 And (Allow_All_Auth_Drop_Off_Locs = 1)
				 And RLSM.location_id in
				  (
					SELECT      Pick_Up_Location_ID --, Valid_From, Valid_To, Authorized
					FROM         dbo.Pick_Up_Drop_Off_Location
					Where (@dPickup BETWEEN Valid_From AND  ISNULL(Valid_To, '2078-12-31 23:59')) 
						and (Authorized=1) 
						And (Pick_Up_Location_ID =@PULocId)
						And (Drop_Off_Location_ID=@DOLocID or (Pick_Up_Location_ID=Drop_Off_Location_ID))
				  )
				 
				 
			 )
		)
		
		Or
		 (
			dbo.Rate_Purpose.Rate_Purpose ='Tour Pkg'			
			AND 
			ORGR.Rate_ID
			In		     
			(
			SELECT     RLS.Rate_ID
			FROM         dbo.Rate_Location_Set AS RLS INNER JOIN
						 dbo.Rate_Location_Set_Member AS RLSM ON RLS.Rate_ID = RLSM.Rate_ID AND RLS.Rate_Location_Set_ID = RLSM.Rate_Location_Set_ID 				 
			Where	
					-- (@dPickup BETWEEN RLS.Effective_Date AND  ISNULL(RLS.Termination_Date, '2078-12-31 23:59')) 
				 --And (@dPickup BETWEEN RLSM.Effective_Date AND ISNULL(RLSM.Termination_Date, '2078-12-31 23:59'))
				 	 ISNULL(RLS.Termination_Date, '2078-12-31 23:59')>getdate()
				 And ISNULL(RLSM.Termination_Date, '2078-12-31 23:59')>getdate()
				 And (RLSM.location_id = @PULocId)
				 And (Allow_All_Auth_Drop_Off_Locs = 1)
				 And RLSM.location_id in
				  (
					SELECT      Pick_Up_Location_ID --, Valid_From, Valid_To, Authorized
					FROM         dbo.Tour_Drop_Off_Charge
					Where (@dPickup BETWEEN Valid_From  AND  ISNULL(Valid_To, '2078-12-31 23:59')) 
						and (Authorized=1) 
						And (Pick_Up_Location_ID =@PULocId)
						And (Drop_Off_Location_ID=@DOLocID or (Pick_Up_Location_ID=Drop_Off_Location_ID))
				  )
				 
				 
			 )
		)
	)

				
				--select * from Rate_Location_Set_Member
GO
