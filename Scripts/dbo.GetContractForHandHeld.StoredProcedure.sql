USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetContractForHandHeld]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetContractForHandHeld    Script Date: 2/18/99 12:12:14 PM ******/
/****** Object:  Stored Procedure dbo.GetContractForHandHeld    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: 	To retrieve the contract information, used by handheld unit,  for the given parameters.
MOD HISTORY:
Name    Date         Comments
Roy He 20020923 Modified to use Dynamic SQL, Much faster this way
Sli	20060308	Add MVA number search

*/
CREATE PROCEDURE [dbo].[GetContractForHandHeld] --'','0429052','',''
	@UnitNumber	VarChar(12),
	@MVANumber	VarChar(12),
	@ContractNum	Varchar(11),
	@LicencePlate	VarChar(10)
AS
	/* 10/21/99 - do nullif outside of SQL statements */

	SELECT	@UnitNumber = NULLIF(@UnitNumber, ''),
		@MVANumber = NULLIF(@MVANumber, ''),
		@ContractNum = NULLIF(@ContractNum, ''),
		@LicencePlate = NULLIF(@LicencePlate, '')
	If @MVANumber <> ''
		select @MVANumber = left(@MVANumber,len(@MVANumber)-1)+'-'+right(@MVANumber,1)

            DECLARE @SQLString NVARCHAR(800)


	select @SQLString=N'SELECT	DISTINCT VOC.Unit_Number,CON.Contract_Number,VEH.Current_Licence_Plate,	CON.First_Name + '' '' + CON.Last_Name,	CON.First_Name,CON.Last_Name,
				 VEH.Foreign_Vehicle_Unit_Number, 
				(case when veh.mva_number is null or veh.mva_number="" 
						then ""
						else left(VEH.MVA_Number,len(VEH.MVA_Number)-2)+right(VEH.MVA_Number,1) 
				  end  )as MVA_Number 
				FROM Contract CON,Vehicle_On_Contract VOC,	Vehicle VEH 
				WHERE CON.Contract_number = VOC.Contract_Number and VOC.Unit_Number = VEH.Unit_Number AND VOC.Actual_Check_In IS NULL'

             if @UnitNumber IS not NULL 
		select @SQLString = @SQLString +N' and (VOC.Unit_Number =' + CONVERT(varchar, @UnitNumber)+')'

             if @MVANumber IS not NULL 
		select @SQLString = @SQLString +N' and (VEH.MVA_Number =''' +  @MVANumber+''')'

	     if @ContractNum IS not NULL
		select @SQLString = @SQLString +N' and (CON.Contract_number =' + CONVERT(varchar, @ContractNum)+')'

             if @LicencePlate IS not NULL
		select @SQLString = @SQLString +N' and (VEH.Current_Licence_Plate =''' +@LicencePlate  +''')'

	--print @SQLString


            EXEC (@SQLString)

-- WHERE	(VOC.Unit_Number = CONVERT(Int, @UnitNumber) OR @UnitNumber IS NULL )
--AND	(CON.Contract_number = CONVERT(Int, @ContractNum) OR @ContractNum IS NULL )
--AND	(VEH.Current_Licence_Plate = @LicencePlate OR @LicencePlate IS NULL )
--AND	CON.Contract_number = VOC.Contract_Number
--AND	VOC.Unit_Number = VEH.Unit_Number
--AND	VOC.Actual_Check_In IS NULL
GO
