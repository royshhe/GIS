USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResVehClasses]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetResVehClasses]  --'1','06 Dec 2011','7'
	@LocId Varchar(5),
	@CurrDate Varchar(24),
	@ResVehClassCode Varchar(3) =null
AS
	DECLARE	@dLastDatetime Datetime
	DECLARE @nLocId SmallInt
	DECLARE	@dCurrDate DateTime
	--ECLARE 	@VehClassCode varchar(3)

	SELECT	@nLocId = Convert(SmallInt, NULLIF(@LocId,''))
	SELECT	@dCurrDate = Convert(DateTime, NULLIF(@CurrDate,''))

	--if @ResVehClassCode = ''
		--select @VehClassCode = null
	--else
		--select  @ResVehClassCode = @VehClassCode
	
	IF @CurrDate = ''
		SELECT @CurrDate = Convert(Varchar(24), Getdate(), 113)
	SELECT @dLastDatetime = Convert(Datetime, '31 Dec 2078 23:59')


	-- return list of all vehicle classes valid for @LocId on @CurrDate	
	SELECT	A.Vehicle_Class_Name, B.Vehicle_Class_Code,
		A.Vehicle_Type_ID, A.Minimum_Age, A.Deposit_Amount, 
		(Case When A.Passenger_Vehicle=0 Then '1' Else '0' End) AS PVRT_Exempt, A.PST, A.Alias, A.Description,
        A.ImageName,A.AddenDum,A.DisplayOrder,
        (Case When A.Vehicle_Type_ID='Car' Then A.Maestro_Code Else Null End), A.SIPP,
        (case when A.vehicle_type_id='Car' then 
					(select Value from Lookup_Table where Category='Underage Charge' and Code='Car Optional ID')
			  when A.vehicle_type_id='Truck' then
					(select Value from Lookup_Table where Category='Underage Charge' and Code='Truck Optional ID')
				else null
			end) as Default_Underage_Code,
        (select Value from Lookup_Table where Category='Underage Charge' and Code='Age') as Underage_Charge_Age,
        (Case When A.Vehicle_Type_ID='Truck' Then A.Maestro_Code Else Null End)	as TK_Maestro_Code,
        A.CC_Auth_Flat, A.CC_Auth_Minimum, A.CC_Auth_Under_Age, A.CC_Auth_Under_Age_Minimum

	FROM	Vehicle_Class A
		JOIN Location_Vehicle_Class B
		  ON A.Vehicle_Class_Code = B.Vehicle_Class_Code
		--LEFT OUTER JOIN Lookup_Table LT
		--  ON A.Vehicle_Class_Code = LT.Code
		-- AND LT.Category = 'PVRT Exempt'
	WHERE	@dCurrDate
			BETWEEN Valid_From AND ISNULL(Valid_To, @dLastDatetime)
	AND	B.Location_ID = @nLocId

	UNION

	-- if @ResVehClassCode provided, include veh class info for @ResVehClassCode which 
	-- was selected for a reservation in case @ResVehClassCode is not returned in
	-- previous list
	SELECT	A.Vehicle_Class_Name, A.Vehicle_Class_Code,
		A.Vehicle_Type_ID, A.Minimum_Age, A.Deposit_Amount, 
		(Case When A.Passenger_Vehicle=0 Then '1' Else '0' End) AS PVRT_Exempt, A.PST, A.Alias, A.Description,
        A.ImageName,A.AddenDum,a.DisplayOrder,
        (Case When A.Vehicle_Type_ID='Car' Then A.Maestro_Code Else Null End), A.SIPP,
        (case when A.vehicle_type_id='Car' then 
					(select Value from Lookup_Table where Category='Underage Charge' and Code='Car Optional ID')
			  when A.vehicle_type_id='Truck' then
					(select Value from Lookup_Table where Category='Underage Charge' and Code='Truck Optional ID')
				else null
			end) as Default_Underage_Code,
        (select Value from Lookup_Table where Category='Underage Charge' and Code='Age') as Underage_Charge_Age,
        (Case When A.Vehicle_Type_ID='Truck' Then A.Maestro_Code Else Null End)	as TK_Maestro_Code,
         A.CC_Auth_Flat, A.CC_Auth_Minimum, A.CC_Auth_Under_Age, A.CC_Auth_Under_Age_Minimum

	FROM	Vehicle_Class A
		--LEFT OUTER JOIN Lookup_Table LT
		--  ON A.Vehicle_Class_Code = LT.Code
		-- AND LT.Category = 'PVRT Exempt'
	WHERE	A.Vehicle_Class_Code = @ResVehClassCode
	ORDER BY A.DisplayOrder
	RETURN @@ROWCOUNT
GO
