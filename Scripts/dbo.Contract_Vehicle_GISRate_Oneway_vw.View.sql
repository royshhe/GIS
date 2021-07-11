USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Vehicle_GISRate_Oneway_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create View [dbo].[Contract_Vehicle_GISRate_Oneway_vw]
as
SELECT     
					 dbo.Contract.Contract_Number, 
					 dbo.Contract.Foreign_Contract_Number, 
					 dbo.Contract.First_Name, 
					  dbo.Contract.Last_Name, 
					 PULoc.Location as PickupLoc, 
					  DOLOC.Location AS DropOffLoc, 
					  dbo.RP__Last_Vehicle_On_Contract.Unit_Number,
					  dbo.Vehicle.Current_Licence_Plate, 
                      dbo.Owning_Company.Name as Owning_Company, 
					  dbo.Vehicle_Class.Vehicle_Class_Name, 
					 dbo.RP__Last_Vehicle_On_Contract.Checked_Out, 
					  dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In, 
					  dbo.RP__Last_Vehicle_On_Contract.Km_Out, 
					  dbo.RP__Last_Vehicle_On_Contract.Km_In, 
					   DATEDIFF(mi, dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0 AS Contract_Rental_Days,
					  dbo.Reservation.Confirmation_Number,
                      dbo.Reservation.BCD_Number,   
                      dbo.Contract.FF_Member_Number,   
					  dbo.Contract.IATA_Number,
					  dbo.RT_Rate_Amount.Rate_Name, 
					  dbo.RT_Rate_Amount.Rate_Level,
					  Daily_rate = sum(case when (RT_Rate_Amount.Time_Period = 'Day' and RT_Rate_Amount.Time_Period_Start = 1)
								then RT_Rate_Amount.Amount  
								else 0.0
						end),				       
          
						Addnl_Daily_rate = max(case when (RT_Rate_Amount.Time_Period = 'Day' and RT_Rate_Amount.Time_Period_Start != 1) 
								then RT_Rate_Amount.Amount  
								else 0.0
						end),
						
						Weekly_rate = sum(case RT_Rate_Amount.Time_Period
								when 'Week'
								then RT_Rate_Amount.Amount
								else 0.0
						end),
						
					   Hourly_rate = sum(case RT_Rate_Amount.Time_Period
								when 'Hour'
								then RT_Rate_Amount.Amount
								else 0.0
						end),

					   Monthly_rate = sum(case RT_Rate_Amount.Time_Period 
								when 'Month'
								then RT_Rate_Amount.Amount
								else 0.0
						end),

						'GIS' As Rate_Type

/*FROM           dbo.Owning_Company INNER JOIN
                      dbo.Contract INNER JOIN
                      dbo.RT_Rate_Amount ON dbo.Contract.Vehicle_Class_Code = dbo.RT_Rate_Amount.Vehicle_Class_Code AND 
                      dbo.Contract.Rate_ID = dbo.RT_Rate_Amount.Rate_ID AND dbo.Contract.Rate_Level = dbo.RT_Rate_Amount.Rate_Level INNER JOIN
	         dbo.Vehicle_Class ON Convert(Varchar(1), dbo.Contract.Vehicle_Class_Code) = Convert(Varchar(1),dbo.Vehicle_Class.Vehicle_Class_Code) INNER JOIN
                      dbo.Location AS PULoc ON dbo.Contract.Pick_Up_Location_ID = PULoc.Location_ID INNER JOIN
                      dbo.Location AS DOLOC ON dbo.Contract.Drop_Off_Location_ID = DOLOC.Location_ID INNER JOIN
                      dbo.Vehicle INNER JOIN
                      dbo.RP__Last_Vehicle_On_Contract ON dbo.Vehicle.Unit_Number = dbo.RP__Last_Vehicle_On_Contract.Unit_Number ON 
                      dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number ON 
                      dbo.Owning_Company.Owning_Company_ID = dbo.Vehicle.Owning_Company_ID LEFT OUTER JOIN
                      dbo.Reservation ON dbo.Contract.Confirmation_Number = dbo.Reservation.Confirmation_Number

*/

FROM         dbo.Location DOLOC INNER JOIN
                      dbo.Contract INNER JOIN
                      dbo.RT_Rate_Amount ON dbo.Contract.Vehicle_Class_Code = dbo.RT_Rate_Amount.Vehicle_Class_Code AND 
                      dbo.Contract.Rate_ID = dbo.RT_Rate_Amount.Rate_ID AND dbo.Contract.Rate_Level = dbo.RT_Rate_Amount.Rate_Level INNER JOIN
                      dbo.Vehicle_Class ON CONVERT(Varchar(1), dbo.Contract.Vehicle_Class_Code) = CONVERT(Varchar(1), dbo.Vehicle_Class.Vehicle_Class_Code) 
                      INNER JOIN
                      dbo.Location PULoc ON dbo.Contract.Pick_Up_Location_ID = PULoc.Location_ID INNER JOIN
                      dbo.Vehicle INNER JOIN
                      dbo.RP__Last_Vehicle_On_Contract ON dbo.Vehicle.Unit_Number = dbo.RP__Last_Vehicle_On_Contract.Unit_Number ON 
                      dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number INNER JOIN
                      dbo.Owning_Company ON dbo.Vehicle.Owning_Company_ID = dbo.Owning_Company.Owning_Company_ID ON 
                      DOLOC.Location_ID = dbo.RP__Last_Vehicle_On_Contract.Actual_Drop_Off_Location_ID LEFT OUTER JOIN
                      dbo.Reservation ON dbo.Contract.Confirmation_Number = dbo.Reservation.Confirmation_Number


 where --dbo.Contract.Pick_Up_On>'2008-04-05' and 

 (dbo.Contract.Rate_Assigned_Date between dbo.RT_Rate_Amount.VREffectiveDate and  dbo.RT_Rate_Amount.VRTerminationDate) and 
        (dbo.Contract.Rate_Assigned_Date between dbo.RT_Rate_Amount.RCAEffectiveDate and dbo.RT_Rate_Amount.RCATerminationDate) and 
	(dbo.Contract.Rate_Assigned_Date between dbo.RT_Rate_Amount.RTPEffectiveDate and dbo.RT_Rate_Amount.RTPTerminationDate) and 
	(dbo.Contract.Rate_Assigned_Date between  dbo.RT_Rate_Amount.RVCEffectiveDate and dbo.RT_Rate_Amount.RVCTerminationDate) --and (dbo.Contract.Confirmation_Number is null)
--and  dbo.Contract.Pick_Up_On>'2005-12-25'

Group by 
  dbo.Contract.Contract_Number, 
  dbo.Contract.Foreign_Contract_Number, dbo.Contract.First_Name, dbo.Contract.Last_Name, 
  PULoc.Location , DOLOC.Location, dbo.RP__Last_Vehicle_On_Contract.Unit_Number,
  dbo.Vehicle.Current_Licence_Plate, dbo.Owning_Company.Name , dbo.Vehicle_Class.Vehicle_Class_Name,
dbo.Contract.Pick_Up_On,
  dbo.RP__Last_Vehicle_On_Contract.Checked_Out,   dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In, 
  dbo.RP__Last_Vehicle_On_Contract.Km_Out, dbo.RP__Last_Vehicle_On_Contract.Km_In,   
  dbo.Reservation.Confirmation_Number,dbo.Reservation.BCD_Number,  dbo.Contract.FF_Member_Number,   dbo.Contract.IATA_Number,
  dbo.RT_Rate_Amount.Rate_Name, 	 dbo.RT_Rate_Amount.Rate_Level
GO
