USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_Rate_Analysis_old]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*
PROCEDURE NAME: RP_SP_Con_Rate_Analysis
PURPOSE: Select all Res and Contrat and related Rates info for Analysis
AUTHOR:	Roy He
DATE CREATED: 2005/12/30
USED BY:   Revenue Manager
MOD HISTORY:
Name 		Date		Comments
*/


CREATE PROCEDURE [dbo].[RP_SP_Con_Rate_Analysis_old] --0,0,0,'2005-12-01', '2005-12-15', '*','*','*','*','*'
(
	
	@paramGISResIncluded bit=1,
        @paramMaestroResIncluded bit=1,
        @paramWalkupResIncluded bit=1,  
        @paramStartPickupDate varchar(20) = '31 Apr 1999',
	@paramEndPickupDate varchar(20) = '31 Jul 1999',
	@paramVehicleTypeID char(5) = '*',
        @paramVehicleClassCode char(1) = '*',
        @paramHubID varchar(6)='*',
	@paramPickupLocationID varchar(20) = '*',
	@paramRateName varchar(50) = '*'

)


AS

SET ANSI_NULLS OFF
SET CONCAT_NULL_YIELDS_NULL OFF
-- convert strings to datetime


DECLARE @startDate varchar(20),
	@endDate varchar(20)

SELECT	@startDate	=  convert(varchar(20),CONVERT(datetime,@paramStartPickupDate),106),
	@endDate	= convert(varchar(20), CONVERT(datetime, @paramEndPickupDate)+1,106)	

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(20)

if @paramPickupLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramPickupLocationID
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



DECLARE @SQLStringWalkup VARCHAR(1340)
DECLARE @SQLStringGISRes VARCHAR(1340)
DECLARE @SQLStringMaestroRes NVARCHAR(1360)
DECLARE @SQLStringWhere VARCHAR(400)
DECLARE @SQLString VARCHAR(4000)

select @SQLStringWalkup=''
select @SQLStringGISRes='' 
select @SQLStringMaestroRes=''

DELETE  Rates_Analysis_Rpt

SELECT @SQLStringWhere='WHERE ('''+rtrim(ltrim(@paramVehicleTypeID)) +'''= ''*'' OR Vehicle_Type_ID ='''+ @paramVehicleTypeID + ''')AND (''' + @paramVehicleClassCode +'''= ''*'' OR dbo.Vehicle_Class.Vehicle_Class_Code ='''+ @paramVehicleClassCode+''') AND (''' +@paramPickupLocationID+''' = ''*'' OR '+  @tmpLocID +' = PickUpLoc.Location_ID)AND ('''+@paramRateName +'''= ''*'' OR Rate_Name LIKE '''+@paramRateName+''') AND('''+@paramHubID +'''= ''*'' or '+@intHubID+' = PickupLoc.Hub_ID)AND Pick_Up_On >= '''+ @startDate+''' AND Pick_Up_On < '''+@endDate+''''


if @paramWalkupResIncluded=1   

--Walkup
	select @SQLStringWalkup=
'SELECT CONVERT(varchar(13),WalkupCon.Confirmation_Number) as Confirmation_Number, WalkupCon.Contract_Number, dbo.Vehicle_Class.Vehicle_Class_Name, PickupLoc.Location AS PickUpLoc, DropOffLoc.Location AS DropOffLoc, WalkupCon.Pick_Up_On, WalkupCon.Drop_Off_On, WalkupCon.ResMadeTime, CONVERT(char(1),WalkupCon.ResStatus) as ResStatus,  CONVERT(char(2),WalkupCon.Contract_status) as ContractStatus, WalkupCon.Contract_Rental_Days, WalkupCon.Rate_Name, CONVERT(char(1),WalkupCon.Rate_Level) as Rate_Level, WalkupCon.Daily_rate,  WalkupCon.Addnl_Daily_rate, WalkupCon.Weekly_rate, WalkupCon.Hourly_rate, WalkupCon.Monthly_rate FROM dbo.RP_Con_11_Rates_Analysis_GIS_Walkup WalkupCon INNER JOIN dbo.Vehicle_Class ON WalkupCon.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN dbo.Location PickupLoc ON WalkupCon.Pick_Up_Location_ID = PickupLoc.Location_ID INNER JOIN dbo.Location DropOffLoc ON WalkupCon.Drop_Off_Location_ID = DropOffLoc.Location_ID' + ' ' + @SQLStringWhere

if @paramGISResIncluded=1

	select @SQLStringGISRes=
	'SELECT CONVERT(varchar(13),GISRes.Confirmation_Number) as Confirmation_Number, GISRes.Contract_Number, dbo.Vehicle_Class.Vehicle_Class_Name, PickupLoc.Location AS PickUpLoc, DropOffLoc.Location AS DropOffLoc, GISRes.Pick_Up_On, GISRes.Drop_Off_On, GISRes.ResMadeTime, CONVERT(char(1),GISRes.ResStatus) as ResStatus, CONVERT(char(2),GISRes.Contract_status) as ContractStatus, GISRes.Contract_Rental_Days, GISRes.Rate_Name, CONVERT(char(1),GISRes.Rate_Level) as Rate_Level, GISRes.Daily_rate, GISRes.Addnl_Daily_rate, GISRes.Weekly_rate, GISRes.Hourly_rate, GISRes.Monthly_rate FROM dbo.RP_Con_11_Rates_Analysis_GIS_Res GISRes INNER JOIN dbo.Vehicle_Class ON GISRes.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN dbo.Location PickupLoc ON GISRes.Pick_Up_Location_ID = PickupLoc.Location_ID INNER JOIN dbo.Location DropOffLoc ON GISRes.Drop_Off_Location_ID = DropOffLoc.Location_ID' + ' ' + @SQLStringWhere

if @paramMaestroResIncluded=1

	select @SQLStringMaestroRes=
'SELECT CONVERT(varchar(13),MaestroRes.Foreign_confirm_number) as Confirmation_Number, MaestroRes.Contract_Number, dbo.Vehicle_Class.Vehicle_Class_Name, PickupLoc.Location AS PickUpLoc, DropOffLoc.Location AS DropOffLoc, MaestroRes.Pick_Up_On, MaestroRes.Drop_Off_On, MaestroRes.ResMadeTime, CONVERT(char(1),MaestroRes.ResStatus) as ResStatus,  CONVERT(char(2),MaestroRes.Contract_status) as ContractStatus, MaestroRes.Contract_Rental_Days, MaestroRes.Rate_Name, CONVERT(char(1),MaestroRes.Rate_Level) as Rate_Level, MaestroRes.Daily_rate, MaestroRes.Addnl_Daily_rate, MaestroRes.Weekly_rate, MaestroRes.Hourly_rate, MaestroRes.Monthly_rate FROM dbo.RP_Con_11_Rates_Analysis_Maestro_Res MaestroRes INNER JOIN dbo.Vehicle_Class ON MaestroRes.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN dbo.Location PickupLoc ON MaestroRes.Pick_Up_Location_ID = PickupLoc.Location_ID INNER JOIN dbo.Location DropOffLoc ON MaestroRes.Drop_Off_Location_ID = DropOffLoc.Location_ID ' + ' ' + @SQLStringWhere

if @SQLStringWalkup<>'' 
	begin
		SELECT @SQLString=@SQLStringWalkup
		if @SQLStringGISRes<>'' 
			begin
				SELECT @SQLString= @SQLString + ' Union ' +LTRIM(RTRIM(@SQLStringGISRes))
				if @SQLStringMaestroRes<>''
					SELECT @SQLString= @SQLString + ' Union ' + LTRIM(RTRIM(@SQLStringMaestroRes))
			end
		else
		   begin	
	           	if @SQLStringMaestroRes<>'' 
				SELECT @SQLString= @SQLString + ' Union ' + LTRIM(RTRIM(@SQLStringMaestroRes))
		   end
		
        end

else
	begin
		if @SQLStringGISRes<>'' 
			begin
				SELECT @SQLString=  LTRIM(RTRIM(@SQLStringGISRes))
				if @SQLStringMaestroRes<>''
					SELECT @SQLString= @SQLString + ' Union ' + LTRIM(RTRIM(@SQLStringMaestroRes))
			end
		else
		   begin	
	           if @SQLStringMaestroRes<>''
			SELECT @SQLString=  LTRIM(RTRIM(@SQLStringMaestroRes))
		   end

	
	end

--SELECT CONVERT(varchar(13),WalkupCon.Confirmation_Number) as Confirmation_Number, WalkupCon.Contract_Number, dbo.Vehicle_Class.Vehicle_Class_Name, PickupLoc.Location AS PickUpLoc, DropOffLoc.Location AS DropOffLoc, WalkupCon.Pick_Up_On, WalkupCon.Drop_Off_On, WalkupCon.ResMadeTime, CONVERT(char(1),WalkupCon.ResStatus) as ResStatus,  CONVERT(char(2),WalkupCon.Contract_status) as ContractStatus, WalkupCon.Contract_Rental_Days, WalkupCon.Rate_Name, CONVERT(char(1),WalkupCon.Rate_Level) as Rate_Level, WalkupCon.Daily_rate,  WalkupCon.Addnl_Daily_rate, WalkupCon.Weekly_rate, WalkupCon.Hourly_rate, WalkupCon.Monthly_rate into #Rates_Analysis_Rpt FROM dbo.RP_Con_11_Rates_Analysis_GIS_Walkup WalkupCon INNER JOIN dbo.Vehicle_Class ON WalkupCon.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN dbo.Location PickupLoc ON WalkupCon.Pick_Up_Location_ID = PickupLoc.Location_ID INNER JOIN dbo.Location DropOffLoc ON WalkupCon.Drop_Off_Location_ID = DropOffLoc.Location_ID where 1<>1
--SELECT @SQLString='INSERT into  #Rates_Analysis_Rpt ' + @SQLString
--PRINT @SQLString
--SELECT CONVERT(varchar(13),WalkupCon.Confirmation_Number) as Confirmation_Number, WalkupCon.Contract_Number, dbo.Vehicle_Class.Vehicle_Class_Name, PickupLoc.Location AS PickUpLoc, DropOffLoc.Location AS DropOffLoc, WalkupCon.Pick_Up_On, WalkupCon.Drop_Off_On, WalkupCon.ResMadeTime, CONVERT(char(1),WalkupCon.ResStatus) as ResStatus,  CONVERT(char(2),WalkupCon.Contract_status) as ContractStatus, WalkupCon.Contract_Rental_Days, WalkupCon.Rate_Name, CONVERT(char(1),WalkupCon.Rate_Level) as Rate_Level, WalkupCon.Daily_rate,  WalkupCon.Addnl_Daily_rate, WalkupCon.Weekly_rate, WalkupCon.Hourly_rate, WalkupCon.Monthly_rate FROM dbo.RP_Con_11_Rates_Analysis_GIS_Walkup WalkupCon INNER JOIN dbo.Vehicle_Class ON WalkupCon.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN dbo.Location PickupLoc ON WalkupCon.Pick_Up_Location_ID = PickupLoc.Location_ID INNER JOIN dbo.Location DropOffLoc ON WalkupCon.Drop_Off_Location_ID = DropOffLoc.Location_ID where 1<>1
if @SQLString<>''
	select @SQLString= 'INSERT INTO Rates_Analysis_Rpt Select RA.*  from ( '+ @SQLString + ') RA'
--select @SQLString= 'Select RA.* INTO Rates_Analysis_Rpt from ( '+ @SQLString + ') RA'
--PRINT @SQLString
exec (@SQLString)

SELECT * FROM Rates_Analysis_Rpt

--DROP TABLE Rates_Analysis_Rpt
--PRINT @SQLStringWhere


GO
