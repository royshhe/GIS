USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_con_16_OE_Tracking]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[RP_SP_con_16_OE_Tracking]  --'*', '*','01 jun 2009','30 jun 2009'
(
	@paramOpExtraType varchar(18) = 'GPS',
	@paramPULocationID varchar(20) = '16',
	@paramStartDate varchar(20) ='01 jun 2009',
	@paramEndDate varchar(20) ='30 Jun 2009'

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


-- Creteria: Pickup Location, Optional Extra Type

 
SELECT	  PULoc.Location AS PickUpLocation, 
(Case When GPS.Owning_Location is Not Null then GPS.Owning_Location Else 'Unspecified' End) Owning_Location ,
 (Case when GPS.Unit_Number is not Null  Then GPS.Unit_Number 
		when dbo.Contract_Optional_Extra.Unit_Number is not Null  Then dbo.Contract_Optional_Extra.Unit_Number  +'(*)'
		Else 'Unspecified'
End) Unit_Number,
Serial_Number,

dbo.Contract.Contract_Number,
dbo.RP__Last_Vehicle_On_Contract.Unit_Number AS VehicleUnitNumber, 
dbo.Contract.First_Name + ' '+ dbo.Contract.Last_Name as CustomerName,
dbo.Optional_Extra.Optional_Extra, 
dbo.Contract_Optional_Extra.Rent_From, 
dbo.Contract_Optional_Extra.Rent_To, 
dbo.Contract_Optional_Extra.Daily_Rate, 
dbo.Contract_Optional_Extra.Weekly_Rate, 
					
dbo.Optional_Extra.Type, 
dbo.Contract_Optional_Extra.Coupon_Code,
 GPS.Deleted_Flag
--Need to add owning Location
--select *
FROM         dbo.Contract INNER JOIN
                      dbo.Contract_Optional_Extra ON dbo.Contract.Contract_Number = dbo.Contract_Optional_Extra.Contract_Number 
				INNER JOIN
                      dbo.Optional_Extra ON dbo.Contract_Optional_Extra.Optional_Extra_ID = dbo.Optional_Extra.Optional_Extra_ID 
						AND   (dbo.Contract_Optional_Extra.Termination_Date='2078-12-31 23:59:00.000') 
					--AND  (dbo.Contract.Status = 'co') 
					AND (dbo.Optional_Extra.Type IN
                          (SELECT     Value
                            FROM          dbo.Lookup_Table
                            WHERE      (Category = 'OptionalExtraTracking')))  
				INNER JOIN
                      dbo.Location AS PULoc ON dbo.Contract.Pick_Up_Location_ID = PULoc.Location_ID INNER JOIN
                      dbo.RP__Last_Vehicle_On_Contract ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number INNER JOIN
                      dbo.Location ON dbo.Contract_Optional_Extra.Sold_At_Location_ID = dbo.Location.Location_ID LEFT OUTER JOIN
                      dbo.Location AS DOLoc ON dbo.RP__Last_Vehicle_On_Contract.Actual_Drop_Off_Location_ID = DOLoc.Location_ID
   left OUTER JOIN
                      (		SELECT     OEI.Unit_Number, OEI.Serial_Number, OEI.Owning_Location AS Owning_Location_id, dbo.Location.Location AS Owning_Location, 
							 OEI.Deleted_Flag
							FROM         dbo.Optional_Extra_Inventory OEI INNER JOIN
							  dbo.Location ON OEI.Owning_Location = dbo.Location.Location_ID
                            --Where OEI.Deleted_Flag=0
					) GPS

ON           dbo.Contract_Optional_Extra.Unit_Number = GPS.Unit_Number 
      AND   (dbo.Contract_Optional_Extra.Termination_Date ='2078-12-31 23:59:00.000') 
      --AND  (dbo.Contract.Status = 'co')
		 AND (dbo.Optional_Extra.Type IN
                          (SELECT     Value
                            FROM          dbo.Lookup_Table
                            WHERE      (Category = 'OptionalExtraTracking')))  
     
    -- AND GPS.Deleted_Flag=0
	
        
WHERE   (@paramPULocationID = '*' or CONVERT(INT, @tmpLocID) = GPS.Owning_Location_id 
	 )   --  GPS.Deleted_Flag=0
     AND (@paramOpExtraType = '*' OR dbo.Optional_Extra.Type = @paramOpExtraType) 
	and dbo.Contract_Optional_Extra.Rent_From between @paramStartDate and @paramEndDate
	and dbo.Contract_Optional_Extra.Rent_From<>dbo.Contract_Optional_Extra.Rent_To

ORDER BY  dbo.Optional_Extra.Type, 
					(Case When GPS.Owning_Location is Not Null then GPS.Owning_Location Else 'Unspecified ' End),
					(Case when GPS.Unit_Number is not Null  Then GPS.Unit_Number 
								when dbo.Contract_Optional_Extra.Unit_Number is not Null  Then dbo.Contract_Optional_Extra.Unit_Number  +'(*)'
								Else ''
  				     End) ,Rent_From


RETURN @@ROWCOUNT
GO
