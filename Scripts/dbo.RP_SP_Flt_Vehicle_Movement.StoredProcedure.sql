USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_Vehicle_Movement]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




CREATE PROCEDURE [dbo].[RP_SP_Flt_Vehicle_Movement] --'*', '*', '01 oct 2005', '31 oct 2005'
	@LocationOut	varchar(25),
	@LocationIn	varchar(25),
	@OutFrom	varchar(25),
	@OutTo		varchar(25)
AS

DECLARE @locOutid SMALLINT,
	@locInid SMALLINT,
	@OutDateFrom datetime, 
	@OutDateTo datetime

if @LocationOut <> '*' 
	SELECT @locOutid =@LocationOut
if @LocationIn <> '*' 
	SELECT @locInid =@LocationIn

SELECT  @OutDateFrom=CONVERT(DATETIME, @OutFrom )
SELECT  @OutDateTo=CONVERT(DATETIME, @OutTo )

declare @CompanyCode int        --remove hardcode code
select @CompanyCode=Code from Lookup_Table where Category = 'BudgetBC Company'

SELECT 	--Unit_Number,
	(case when Vehicle.Foreign_Vehicle_Unit_Number <> '' then Vehicle.Foreign_Vehicle_Unit_Number
		else Convert(Varchar(12),Vehicle.Unit_Number)
	end) as Unit_Number,
	Owning_Company.Name,
	(select top 1 L.location from
		(select Receiving_Location_ID as PrevIn_ID, Movement_Out as Prev_Out from Vehicle_Movement 
			where Unit_Number = VM.Unit_Number and Movement_Out < VM.Movement_Out
		union
		select Actual_Drop_Off_Location_ID as PrevIn_ID, Checked_Out as Prev_Out from Vehicle_On_Contract
			where Unit_Number = VM.Unit_Number and Checked_Out < VM.Movement_Out)
	t, Location L where L.location_id = t.PrevIn_ID order by t.Prev_Out desc)	
	as PrevLoc_In,
	LocOut.Location Loc_Out,
	LocIn.Location Loc_In,
	VM.Movement_Out,
	VM.Km_Out, 
      	VM.Movement_In, 
	VM.Km_In, 
      	VM.Movement_Type,
	--Vehicle.Last_Update_By,
	VM.Remarks_out + ' -- ' + VM.Remarks_In Comments
FROM 	Vehicle_Movement VM
JOIN Location LocOut
ON VM.Sending_Location_ID = LocOut.Location_ID
JOIN Location LocIn
ON VM.Receiving_Location_ID = LocIn.Location_ID
INNER JOIN
	Vehicle
ON 	VM.Unit_Number = Vehicle.Unit_Number
INNER JOIN
	Owning_Company
ON	Owning_Company.Owning_Company_ID = Vehicle.Owning_Company_ID

WHERE 
	(VM.Sending_Location_ID = @locOutid 
	or (@LocationOut = '*' and VM.Sending_Location_ID
		in (SELECT Location_ID
		FROM Location
		WHERE Owning_Company_ID <> @CompanyCode)))
	and
	(VM.Receiving_Location_ID = @locInid
	or (@LocationIn = '*' and VM.Receiving_Location_ID
		in (SELECT Location_ID
		FROM Location
		WHERE Owning_Company_ID = @CompanyCode)))
	and
	(VM.Movement_Out BETWEEN @OutDateFrom AND @OutDateTo)
Order by Loc_In, Loc_Out, Movement_Out
GO
