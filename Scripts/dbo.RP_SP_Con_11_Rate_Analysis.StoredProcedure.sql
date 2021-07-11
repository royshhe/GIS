USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_11_Rate_Analysis]    Script Date: 2021-07-10 1:50:50 PM ******/
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


CREATE PROCEDURE [dbo].[RP_SP_Con_11_Rate_Analysis] --'True','True','True','2017-09-01', '2017-09-30','2017-09-01 00:00', '2017-09-29 23:59', '*','*','*','*','*'
(
	
	@paramGISResIncluded varchar(6)='True',
        @paramMaestroResIncluded varchar(6)='True',
        @paramWalkupResIncluded varchar(6)='True',  
        @paramStartPickupDate varchar(20) = '31 Apr 1999',
	@paramEndPickupDate varchar(20) = '31 Jul 1999',
	@paramTransStartDate varchar(20) = '31 Jul 1999',
	@paramTransEndDate varchar(20) = '31 Jul 1999',
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


DECLARE @pickupStartDate varchar(20),
	@pickupEndDate varchar(20),
	@transStartDate varchar(20),
	@transEndDate varchar(20)


SELECT	@pickupStartDate	=  convert(varchar(20),CONVERT(datetime,@paramStartPickupDate),120),
	@pickupEndDate	= convert(varchar(20), CONVERT(datetime, @paramEndPickupDate)+1,120)	

SELECT	@transStartDate	=  convert(varchar(20),CONVERT(datetime,@paramTransStartDate),120),
	@transEndDate	= convert(varchar(20), CONVERT(datetime, @paramTransEndDate),120)	


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



DECLARE @SQLStringWalkup VARCHAR(2000)
DECLARE @SQLStringGISRes VARCHAR(2000)
DECLARE @SQLStringMaestroRes VARCHAR(2000)
DECLARE @SQLStringWhere VARCHAR(500)
DECLARE @SQLString VARCHAR(6000)

select @SQLStringWalkup=''
select @SQLStringGISRes='' 
select @SQLStringMaestroRes=''

--DELETE  RP_Rates_Analysis

SELECT @SQLStringWhere='WHERE ('''+rtrim(ltrim(@paramVehicleTypeID)) +'''= ''*'' OR vc.Vehicle_Type_ID ='''+ @paramVehicleTypeID + ''')AND (''' + @paramVehicleClassCode +'''= ''*'' OR vc.Vehicle_Class_Code ='''+ @paramVehicleClassCode+''') AND (''' +@paramPickupLocationID+''' = ''*'' OR '+  @tmpLocID +' = PickUpLoc.Location_ID)AND ('''+@paramRateName +'''= ''*'' OR Rate_Name LIKE '''+@paramRateName+''') AND('''+@paramHubID +'''= ''*'' or '+@intHubID+' = PickupLoc.Hub_ID)AND (Pick_Up_On >= '''+ @pickupStartDate+''' AND Pick_Up_On < '''+@pickupEndDate+ ''') And (TransTime BETWEEN ''' + @transStartDate + ''' And ''' + @transEndDate +''')'
--print @SQLStringWhere

if @paramWalkupResIncluded='True'  

--Walkup
	select @SQLStringWalkup=
'SELECT CONVERT(varchar(13),Confirmation_Number) as Confirmation_Number, Contract_Number, vc.Vehicle_Class_Name, sub_vc.Vehicle_Class_Name AS Sub_Vehicle_Class,
 PickupLoc.Location AS PickUpLoc, DropOffLoc.Location AS DropOffLoc, Pick_Up_On, Drop_Off_On, TransTime,ResCancelTime, CONVERT(char(1),ResStatus) as ResStatus,  CONVERT(char(2),
 Contract_status) as ContractStatus, Contract_Rental_Days,BCD_number,IsNull(Con_Rate_Org_ID,Res_Rate_Org_ID) Rate_Org_ID, IATA_Number, Rate_Name, CONVERT(char(1),Rate_Level) as Rate_Level, Daily_rate,  Addnl_Daily_rate, Weekly_rate, Hourly_rate, Monthly_rate, Rate_Type, Last_Name, First_Name,Book_Source, (Case when (select mask_required from credit_card_type where upper(maestro_code) = upper(left(CID,2)))=1 then NULL else CID end) as CID,
 Coupon_Code,
 Coupon_Description, 
 Flex_Discount,
 Flat_Discount,
 Discount_ID,
 Program_Number	 
 FROM dbo.RP_Con_11_Rates_Analysis_GIS_Walkup WalkupCon 
	INNER JOIN dbo.Vehicle_Class vc
		ON WalkupCon.Vehicle_Class_Code = vc.Vehicle_Class_Code 	
	INNER JOIN dbo.Location PickupLoc ON WalkupCon.Pick_Up_Location_ID = PickupLoc.Location_ID INNER JOIN dbo.Location DropOffLoc ON WalkupCon.Drop_Off_Location_ID = DropOffLoc.Location_ID
LEFT JOIN dbo.Vehicle_Class  sub_vc 
		ON WalkupCon.Sub_Vehicle_Class_Code = sub_vc.Vehicle_Class_Code' + ' ' + @SQLStringWhere

--print @SQLStringWalkup

if @paramGISResIncluded='True'

	select @SQLStringGISRes=
   'SELECT CONVERT(varchar(13),Confirmation_Number) as Confirmation_Number, Contract_Number, vc.Vehicle_Class_Name,Sub_vc.Vehicle_Class_Name AS Sub_Vehicle_Class, PickupLoc.Location AS PickUpLoc, DropOffLoc.Location AS DropOffLoc, Pick_Up_On, Drop_Off_On, TransTime,ResCancelTime, CONVERT(char(1),ResStatus) as ResStatus, CONVERT(char(2),Contract_status) as ContractStatus, Contract_Rental_Days, BCD_number,IsNull(Con_Rate_Org_ID,Res_Rate_Org_ID) Rate_Org_ID, IATA_Number,Rate_Name, CONVERT(char(1),Rate_Level) as Rate_Level, Daily_rate, Addnl_Daily_rate, Weekly_rate, Hourly_rate, Monthly_rate, Rate_Type, Last_Name, First_Name,Book_Source , (Case when (select mask_required from credit_card_type where upper(maestro_code) = upper(left(CID,2)))=1 then NULL else CID end) as CID,
	Coupon_Code,
	Coupon_Description, 
	Flex_Discount,
	Flat_Discount,
	Discount_ID,
	Program_Number 
	FROM dbo.RP_Con_11_Rates_Analysis_GIS_Res GISRes 
	INNER JOIN dbo.Vehicle_Class vc ON GISRes.Vehicle_Class_Code = vc.Vehicle_Class_Code 
	INNER JOIN dbo.Location PickupLoc ON GISRes.Pick_Up_Location_ID = PickupLoc.Location_ID 
	INNER JOIN dbo.Location DropOffLoc ON GISRes.Drop_Off_Location_ID = DropOffLoc.Location_ID
	LEFT JOIN dbo.Vehicle_Class Sub_vc
			ON GISRes.Sub_Vehicle_Class_Code = Sub_vc.Vehicle_Class_Code' + ' ' + @SQLStringWhere

--print @SQLStringWhere
--print @SQLStringGISRes

if @paramMaestroResIncluded='True'

	select @SQLStringMaestroRes=
'SELECT CONVERT(varchar(13),Foreign_confirm_number) as Confirmation_Number, Contract_Number, vc.Vehicle_Class_Name, sub_vc.Vehicle_Class_Name AS Sub_Vehicle_Class,
 PickupLoc.Location AS PickUpLoc, DropOffLoc.Location AS DropOffLoc, Pick_Up_On, Drop_Off_On, TransTime,ResCancelTime, CONVERT(char(1),ResStatus) as ResStatus,  CONVERT(char(2),Contract_status) as ContractStatus, Contract_Rental_Days, BCD_number,IsNull(Con_Rate_Org_ID,Res_Rate_Org_ID) Rate_Org_ID, IATA_Number,Rate_Name, CONVERT(char(1),Rate_Level) as Rate_Level, Daily_rate, Addnl_Daily_rate, Weekly_rate, Hourly_rate, Monthly_rate, Rate_Type, Last_Name, First_Name, Book_Source, (Case when (select mask_required from credit_card_type where upper(maestro_code) = upper(left(CID,2)))=1 then NULL else CID end) as CID,
 Coupon_Code,
 Coupon_Description,
 Flex_Discount,
 Flat_Discount,
 Discount_ID,
 Program_Number  
 FROM dbo.RP_Con_11_Rates_Analysis_Maestro_Res MaestroRes INNER JOIN dbo.Vehicle_Class vc ON MaestroRes.Vehicle_Class_Code = vc.Vehicle_Class_Code 
 INNER JOIN dbo.Location PickupLoc ON MaestroRes.Pick_Up_Location_ID = PickupLoc.Location_ID INNER JOIN dbo.Location DropOffLoc ON MaestroRes.Drop_Off_Location_ID = DropOffLoc.Location_ID 
 LEFT JOIN dbo.Vehicle_Class  sub_vc	ON MaestroRes.Sub_Vehicle_Class_Code = sub_vc.Vehicle_Class_Code' + ' ' + @SQLStringWhere

--print @SQLStringMaestroRes

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

--SELECT CONVERT(varchar(13),WalkupCon.Confirmation_Number) as Confirmation_Number, WalkupCon.Contract_Number, dbo.Vehicle_Class.Vehicle_Class_Name, PickupLoc.Location AS PickUpLoc, DropOffLoc.Location AS DropOffLoc, WalkupCon.Pick_Up_On, WalkupCon.Drop_Off_On, CONVERT(datetime,WalkupCon.TransTime) as TransTime, CONVERT(char(1),WalkupCon.ResStatus) as ResStatus,  CONVERT(char(2),WalkupCon.Contract_status) as ContractStatus, WalkupCon.Contract_Rental_Days, WalkupCon.Rate_Name, CONVERT(char(1),WalkupCon.Rate_Level) as Rate_Level, WalkupCon.Daily_rate,  WalkupCon.Addnl_Daily_rate, WalkupCon.Weekly_rate, WalkupCon.Hourly_rate, WalkupCon.Monthly_rate  FROM dbo.RP_Con_11_Rates_Analysis_GIS_Walkup WalkupCon INNER JOIN dbo.Vehicle_Class ON WalkupCon.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN dbo.Location PickupLoc ON WalkupCon.Pick_Up_Location_ID = PickupLoc.Location_ID INNER JOIN dbo.Location DropOffLoc ON WalkupCon.Drop_Off_Location_ID = DropOffLoc.Location_ID where 1<>1
--SELECT @SQLString='INSERT into  #Rates_Analysis_Rpt ' + @SQLString
--PRINT @SQLString
--SELECT CONVERT(varchar(13),WalkupCon.Confirmation_Number) as Confirmation_Number, WalkupCon.Contract_Number, dbo.Vehicle_Class.Vehicle_Class_Name, PickupLoc.Location AS PickUpLoc, DropOffLoc.Location AS DropOffLoc, WalkupCon.Pick_Up_On, WalkupCon.Drop_Off_On, WalkupCon.TransTime, CONVERT(char(1),WalkupCon.ResStatus) as ResStatus,  CONVERT(char(2),WalkupCon.Contract_status) as ContractStatus, WalkupCon.Contract_Rental_Days, WalkupCon.Rate_Name, CONVERT(char(1),WalkupCon.Rate_Level) as Rate_Level, WalkupCon.Daily_rate,  WalkupCon.Addnl_Daily_rate, WalkupCon.Weekly_rate, WalkupCon.Hourly_rate, WalkupCon.Monthly_rate FROM dbo.RP_Con_11_Rates_Analysis_GIS_Walkup WalkupCon INNER JOIN dbo.Vehicle_Class ON WalkupCon.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN dbo.Location PickupLoc ON WalkupCon.Pick_Up_Location_ID = PickupLoc.Location_ID INNER JOIN dbo.Location DropOffLoc ON WalkupCon.Drop_Off_Location_ID = DropOffLoc.Location_ID where 1<>1


CREATE TABLE #RP_Rates_Analysis(
	[Confirmation_Number] [varchar](13) NULL,
	[Contract_Number] [int] NULL,
	[Vehicle_Class_Name] [varchar](25) NOT NULL,
	[Sub_Vehicle_Class] [varchar](25) NULL,
	[PickUpLoc] [varchar](25) NOT NULL,
	[DropOffLoc] [varchar](25) NOT NULL,
	[Pick_Up_On] [datetime] NULL,
	[Drop_Off_On] [datetime] NULL,
	[TransTime] [datetime] NULL,
	[ResCancelTime] [datetime] NULL,
	[ResStatus] [char](1) NULL,
	[ContractStatus] [char](2) NULL,
	[Contract_Rental_Days] [numeric](17, 6) NULL,
	[BCD_Number] [varchar](25) NULL,
	[Rate_Org_ID] int NULL,	
	[IATA_Number] [varchar](10) NULL,
	[Rate_Name] [varchar](25) NULL,
	[Rate_Level] [char](1) NULL,
	[Daily_rate] [decimal](38, 2) NULL,
	[Addnl_Daily_rate] [decimal](38, 2) NULL,
	[Weekly_rate] [decimal](38, 2) NULL,
	[Hourly_rate] [decimal](38, 2) NULL,
	[Monthly_rate] [decimal](38, 2) NULL,
	[Rate_Type] [varchar](20) NULL,
	[Last_Name] [varchar](25) NULL,
	[First_Name] [varchar](25) NULL,
	[Book_Source] [varchar](25) NULL,
	[CID] [Varchar](25) NULL,	 
	[Coupon_Code]  [Varchar](25) NULL, 
	[Coupon_Description]  [Varchar](150) NULL, 	 
	[Flex_Discount]  [Decimal](9,2) NULL,
	[Flat_Discount]  [Decimal](9,2) NULL,
	[Discount_ID]  [Varchar](25) NULL,
	[BCN_Number] [varchar](25) NULL
	--[Upgrade_Charge] [decimal](38, 2) NULL,
	
	
) ON [PRIMARY]
--CREATE NONCLUSTERED INDEX IX_RP_Rates_Analysis_Rate_Org_ID
--	ON [dbo].[#RP_Rates_Analysis](Rate_Org_ID)
	
--CREATE NONCLUSTERED INDEX IX_RP_Rates_Analysis_bcd_number
--	ON [dbo].[#RP_Rates_Analysis](bcd_number)

--CREATE NONCLUSTERED INDEX IX_RP_Rates_Analysis_Coupon_Code
--	ON [dbo].[#RP_Rates_Analysis](Coupon_Code)

--CREATE NONCLUSTERED INDEX IX_RP_Rates_Analysis_Discount_ID
--	ON [dbo].[#RP_Rates_Analysis](Discount_ID)


if @SQLString<>''
	select @SQLString= 'INSERT INTO #RP_Rates_Analysis Select RA.*  from ('+ @SQLString + ') RA'
--select @SQLString= 'Select RA.* INTO RP_Rates_Analysis from ( '+ @SQLString + ') RA'
 PRINT @SQLString
exec (@SQLString)

SELECT Confirmation_Number, 
RA.Contract_Number, 
Vehicle_Class_Name,        
Sub_Vehicle_Class,         
PickUpLoc,                 
DropOffLoc,                
Pick_Up_On,              
Drop_Off_On,             
TransTime,               
ResCancelTime,           
ResStatus, 
ContractStatus, 
Contract_Rental_Days,                    
(Case When RA.Rate_Org_ID is not null then RateOrg.BCD_Number Else RA.BCD_Number End ) BCD_Number ,                

IATA_Number, 
Rate_Name,                 
Rate_Level, 
Daily_rate,                              
Addnl_Daily_rate,                        
Weekly_rate,                             
Hourly_rate,                             
Monthly_rate,                            
Rate_Type,            
Last_Name,                 
First_Name,                
Book_Source,               
CID,
(Case 
	When RA.Rate_Org_ID is not null then RateOrg.organization 
	Else BCDOrg.organization 
 End ) organization,
 Coupon_Code,
 Coupon_Description,
 Flex_Discount,
 Flat_Discount,
 Discount.Discount Member_Discount,
 Discount.Percentage Member_Discount_Percentage, 
 cci.Upgrade,  
 cci.All_Level_LDW, 
 cci.PAI PAE, 
 cci.RSN, 
 cci.ELI, 
 cci.Snow_Tire,  
 ISNULL(cci.FPO,0)+ ISNULL(cci.Fuel,0) FuleFPO, 
 cci.Additional_Driver_Charge, 
 cci.All_Seats, 
 cci.Driver_Under_Age, 
 cci.Our_Of_Area, 
 cci.GPS,
               
 BCN_Number,
 WOC.User_ID                

FROM #RP_Rates_Analysis RA left outer join organization BCDOrg on RA.bcd_number=BCDOrg.bcd_number
left outer join organization RateOrg on RA.Rate_Org_ID=RateOrg.Organization_ID
--LEFT JOIN Reservation_Coupon
--	On	RA.Coupon_Code = Reservation_Coupon.Coupon_Number
 --Left JOIN
 --  (SELECT SUM(Amount) AS UpgradeCharge, Contract_number
	--FROM   dbo.Contract_Charge_Item
	--WHERE (Charge_Type = '20')
	--Group by Contract_number
	--) AS cci  On  RA.Contract_Number	= cci.Contract_Number
Left Join  dbo.Contract_Charge_Sum_vw AS cci 
	On  RA.Contract_Number	= cci.Contract_Number
Left Join Discount 
	on RA.Discount_ID = Discount.Discount_ID
	
Left Join RP__CSR_Who_Opened_The_Contract WOC
    ON   RA.Contract_Number	= WOC.Contract_Number

order by Rate_Type,PickUpLoc,TransTime, Pick_Up_On
  
Drop Table #RP_Rates_Analysis


GO
