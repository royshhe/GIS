USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_OWRES]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





CREATE PROCEDURE [dbo].[RP_SP_OWRES] --'2005-11-01', '2005-12-20'
	@StartDateInput varchar(25), 
	@EndDateInput varchar(25) 
AS

declare  @ResTimeStart datetime
declare  @ResTimeEnd datetime
select  @ResTimeStart=CONVERT(DATETIME, @StartDateInput)
select  @ResTimeEnd=CONVERT(DATETIME, @EndDateInput)

declare @CompanyCode int  --remove hardcode code
select @CompanyCode=Code from Lookup_Table where Category = 'BudgetBC Company'

SELECT distinct    
	(case when dbo.Reservation.Foreign_Confirm_Number is NULL then 
		Cast(dbo.Reservation.Confirmation_Number AS Char(20))
		else dbo.Reservation.Foreign_Confirm_Number
	end) AS Res_Number, 
	DropOffLoc.Location AS DropOffLocatioin, 
        PickupLoc.Location AS PickupLocation, dbo.Reservation.Pick_Up_On, dbo.Reservation.Drop_Off_On, dbo.Reservation.First_Name, 
        dbo.Reservation.Last_Name, dbo.Reservation.BCD_Number, dbo.Reservation.Coupon_Code, dbo.Quoted_Vehicle_Rate.Rate_Name, 
        dbo.Quoted_Vehicle_Rate.Authorized_DO_Charge AS DropOffCharge, ResChgHist.ResMadeTime, dbo.Vehicle_Class.Vehicle_Class_Name--, dbo.Pick_Up_Drop_Off_Location.Valid_From, 
        --dbo.Pick_Up_Drop_Off_Location.Valid_To, dbo.Pick_Up_Drop_Off_Location.Authorized, dbo.Pick_Up_Drop_Off_Location.Authorized_Charge, 
        --dbo.Pick_Up_Drop_Off_Location.Unauthorized_Charge
FROM         dbo.Reservation INNER JOIN
             dbo.Location PickupLoc ON dbo.Reservation.Pick_Up_Location_ID = PickupLoc.Location_ID INNER JOIN
             dbo.Location DropOffLoc ON dbo.Reservation.Drop_Off_Location_ID = DropOffLoc.Location_ID INNER JOIN
             dbo.Quoted_Vehicle_Rate ON dbo.Reservation.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID INNER JOIN
	     dbo.Vehicle_Class ON dbo.Reservation.Vehicle_Class_Code =  dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
             dbo.Pick_Up_Drop_Off_Location ON PickupLoc.Location_ID = dbo.Pick_Up_Drop_Off_Location.Pick_Up_Location_ID AND 
             DropOffLoc.Location_ID = dbo.Pick_Up_Drop_Off_Location.Drop_Off_Location_ID LEFT OUTER JOIN
                 (SELECT     dbo.Reservation_Change_History.Confirmation_Number, MIN(dbo.Reservation_Change_History.Changed_On) AS ResMadeTime
                  FROM          dbo.Reservation_Change_History
                  GROUP BY dbo.Reservation_Change_History.Confirmation_Number) ResChgHist ON 
             ResChgHist.Confirmation_Number = dbo.Reservation.Confirmation_Number


WHERE     
(PickupLoc.Owning_Company_ID = @CompanyCode) 
AND  (
(dbo.Pick_Up_Drop_Off_Location.Authorized=1 And (dbo.Pick_Up_Drop_Off_Location.Authorized_Charge<>0)) or ((dbo.Pick_Up_Drop_Off_Location.Authorized=0) and (dbo.Pick_Up_Drop_Off_Location.Unauthorized_Charge<>0))
)
And (dbo.Reservation.Status = 'A' OR dbo.Reservation.Status = 'O') 
--AND (dbo.Reservation.Foreign_Confirm_Number IS NOT NULL) 
AND (ResChgHist.ResMadeTime >= @ResTimeStart AND ResChgHist.ResMadeTime < @ResTimeEnd)


union

/*SELECT DISTINCT 
                      dbo.Reservation.Confirmation_Number, dbo.Reservation.Foreign_Confirm_Number, DropOffLoc.Location AS DropOffLocatioin, 
                      PickupLoc.Location AS PickupLocation, dbo.Reservation.Pick_Up_On, dbo.Reservation.Drop_Off_On, dbo.Reservation.First_Name, 
                      dbo.Reservation.Last_Name, dbo.Reservation.BCD_Number, dbo.Reservation.Coupon_Code, ResChgHist.ResMadeTime, 
                      dbo.Vehicle_Class.Vehicle_Class_Name, dbo.Reservation.Date_Rate_Assigned, dbo.Vehicle_Rate.Effective_Date, dbo.Vehicle_Rate.Termination_Date, 
                      dbo.Pick_Up_Drop_Off_Location.Authorized, dbo.Pick_Up_Drop_Off_Location.Authorized_Charge

*/
select distinct    
	(case when dbo.Reservation.Foreign_Confirm_Number is NULL then 
		Cast(dbo.Reservation.Confirmation_Number AS Char(20))
		else dbo.Reservation.Foreign_Confirm_Number
	end) AS Res_Number, 
	DropOffLoc.Location AS DropOffLocatioin, 
        PickupLoc.Location AS PickupLocation, dbo.Reservation.Pick_Up_On, dbo.Reservation.Drop_Off_On, dbo.Reservation.First_Name, 
        dbo.Reservation.Last_Name, dbo.Reservation.BCD_Number, dbo.Reservation.Coupon_Code, dbo.Vehicle_Rate.Rate_Name, 
        dbo.Pick_Up_Drop_Off_Location.Authorized_Charge AS DropOffCharge, ResChgHist.ResMadeTime, dbo.Vehicle_Class.Vehicle_Class_Name--, dbo.Pick_Up_Drop_Off_Location.Valid_From, 
        --dbo.Pick_Up_Drop_Off_Location.Valid_To, dbo.Pick_Up_Drop_Off_Location.Authorized, dbo.Pick_Up_Drop_Off_Location.Authorized_Charge, 
        --dbo.Pick_Up_Drop_Off_Location.Unauthorized_Charge

FROM         dbo.Reservation INNER JOIN
                      dbo.Location PickupLoc ON dbo.Reservation.Pick_Up_Location_ID = PickupLoc.Location_ID INNER JOIN
                      dbo.Location DropOffLoc ON dbo.Reservation.Drop_Off_Location_ID = DropOffLoc.Location_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Reservation.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      dbo.Pick_Up_Drop_Off_Location ON PickupLoc.Location_ID = dbo.Pick_Up_Drop_Off_Location.Pick_Up_Location_ID AND 
                      DropOffLoc.Location_ID = dbo.Pick_Up_Drop_Off_Location.Drop_Off_Location_ID AND dbo.Reservation.Pick_Up_On BETWEEN 
                      dbo.Pick_Up_Drop_Off_Location.Valid_From AND ISNULL(dbo.Pick_Up_Drop_Off_Location.Valid_To, CONVERT(DateTime, 'Dec 31 2078')) INNER JOIN
                      dbo.Vehicle_Rate ON dbo.Reservation.Rate_ID = dbo.Vehicle_Rate.Rate_ID AND dbo.Reservation.Date_Rate_Assigned BETWEEN 
                      dbo.Vehicle_Rate.Effective_Date AND dbo.Vehicle_Rate.Termination_Date LEFT OUTER JOIN
                      dbo.RP__Reservation_Make_Time ResChgHist ON ResChgHist.Confirmation_Number = dbo.Reservation.Confirmation_Number



WHERE     
(PickupLoc.Owning_Company_ID = 7425) 
AND  (
(dbo.Pick_Up_Drop_Off_Location.Authorized=1 And (dbo.Pick_Up_Drop_Off_Location.Authorized_Charge<>0)) or ((dbo.Pick_Up_Drop_Off_Location.Authorized=0) and (dbo.Pick_Up_Drop_Off_Location.Unauthorized_Charge<>0))
)
And (dbo.Reservation.Status = 'A' OR dbo.Reservation.Status = 'O') 
--AND (dbo.Reservation.Foreign_Confirm_Number IS NOT NULL) 
AND (ResChgHist.ResMadeTime >= @ResTimeStart AND ResChgHist.ResMadeTime < @ResTimeEnd)


/*
WHERE     (PickupLoc.Owning_Company_ID = 7425) AND (dbo.Pick_Up_Drop_Off_Location.Authorized = 1) AND 
                      (dbo.Pick_Up_Drop_Off_Location.Authorized_Charge <> 0) AND (dbo.Reservation.Status = 'A' OR
                      dbo.Reservation.Status = 'O') OR
                      (PickupLoc.Owning_Company_ID = 7425) AND (dbo.Pick_Up_Drop_Off_Location.Authorized = 0) AND (dbo.Reservation.Status = 'A' OR
                      dbo.Reservation.Status = 'O') AND (dbo.Pick_Up_Drop_Off_Location.Unauthorized_Charge <> 0)

*/
GO
