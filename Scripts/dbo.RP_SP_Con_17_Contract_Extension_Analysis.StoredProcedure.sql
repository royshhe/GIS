USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_17_Contract_Extension_Analysis]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[RP_SP_Con_17_Contract_Extension_Analysis] --'*','*','2011-10-01','2011-10-25','*'
(
	@paramVehicleTypeID varchar(20) = '*',
	@paramLocationID varchar(20) = '*',
	@ReportFromDate varchar(20) = '20 Jun 2011',
	@ReportToDate varchar(20) = '25 Jun 2011',
	@AllDate varchar(5) = '*'
)
AS

DECLARE  @tmpLocID varchar(20)

if @paramLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramLocationID
	END 

SELECT CON.Contract_Number,
		(CASE WHEN Res.Foreign_Confirm_Number is NULL THEN 
		Cast(Res.Confirmation_Number AS Char(20))
		ELSE Res.Foreign_Confirm_Number
		END) AS Res_Number, 
		CON.Last_Name + ', ' + CON.First_Name AS Customer_Name,
		VC.Vehicle_Class_Name, CON.Pick_Up_On, 
		CON.Drop_Off_On, 
		PULoc.Location,
		DOLoc.Location,
		dbo.Contract_Vehicle_Rate_Detail_vw.Rate_Name, 
		dbo.Contract_Vehicle_Rate_Detail_vw.Rate_Level, 
		dbo.Contract_Vehicle_Rate_Detail_vw.Daily_rate, 
		dbo.Contract_Vehicle_Rate_Detail_vw.Addnl_Daily_rate, 
		dbo.Contract_Vehicle_Rate_Detail_vw.Weekly_rate, dbo.Contract_Vehicle_Rate_Detail_vw.Hourly_rate, 
		dbo.Contract_Vehicle_Rate_Detail_vw.Monthly_rate, dbo.Contract_Vehicle_Rate_Detail_vw.Rate_Type,
		DOH.Changed_On, DOH.Changed_By Extended_By, 
		DOH.Drop_Off_On AS Extended_To, DOH.Reason, Res.ResMadeTime, COBT.RBR_Date, PULoc.Location
FROM  dbo.Contract CON 
	INNER JOIN   dbo.Location PULoc 
		ON CON.Pick_Up_Location_ID = PULoc.Location_ID 
	INNER JOIN dbo.Location DOLoc 
		ON CON.Drop_Off_Location_ID = DOLoc.Location_ID 
	INNER JOIN dbo.Vehicle_Class VC 
		ON CON.Vehicle_Class_Code = VC.Vehicle_Class_Code 
	INNER JOIN
	(Select * from Business_Transaction where Transaction_Description='Check Out') COBT
		On Con.Contract_number=COBT.Contract_Number
			Left JOIN
		dbo.Contract_Vehicle_Rate_Detail_vw ON CON.Contract_Number = dbo.Contract_Vehicle_Rate_Detail_vw.Contract_Number 
			LEFT OUTER JOIN
			( Select dbo.Reservation.Confirmation_Number,Foreign_Confirm_Number,ResBook.ResMadeTime from dbo.Reservation 
			LEFT OUTER JOIN
			dbo.RP__Reservation_Make_Time ResBook ON Reservation.Confirmation_Number = ResBook.Confirmation_Number
			 ) Res  ON CON.Confirmation_Number = Res.Confirmation_Number 
	LEFT JOIN
	( Select * from dbo.Drop_Off_History 
		where dbo.Drop_Off_History.Reason <> 'Original' and dbo.Drop_Off_History.Reason is not null 
		and dbo.Drop_Off_History.Reason<>''
	) DOH ON CON.Contract_Number = DOH.Contract_Number
	where Con.Status='CO'
	and (@paramVehicleTypeID = '*' or VC.Vehicle_Type_Id = @paramVehicleTypeID)
	and (@paramLocationID = '*' or PULoc.Location_ID = @tmpLocID)
	and (@AllDate = '*' or (COBT.RBR_date between @ReportFromDate and @ReportToDate))
	and (COBT.RBR_date > '01 Jan 2010')
	and DOH.Drop_Off_On is not null
RETURN @@ROWCOUNT


GO
