USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SearchContract]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













/****** Object:  Stored Procedure dbo.SearchContract    Script Date: 2/18/99 12:12:20 PM ******/
/****** Object:  Stored Procedure dbo.SearchContract    Script Date: 2/16/99 2:05:43 PM ******/
CREATE PROCEDURE [dbo].[SearchContract]-- '990675055','07576543US2','2015-03-22 22:13:00.000','186000','AQT4967','7376','Martin','alan douglas','1420840','MCD','*1920','.','aa'
	@ContractNum 	varchar(35),
	@ConfirmNum 	varchar(35),
	@CODatetime	Varchar(24),
	@UnitNumber 	varchar(35),
	@LicencePlate 	varchar(35),
	@OwningCompanyId Varchar(5),
	@LastName 	varchar(35),
	@FirstName 	varchar(35),
	@DriverLicence 	varchar(35),
	@CCType		Varchar(3),
	@CCNumber	Varchar(20),
	@CompanyName 	varchar(35),
	@MVANumber		varchar(20)=''
AS
--DECLARE @iContractNum Int
--DECLARE @sForeignContractNum Varchar(20)
--DECLARE @iConfirmNum Int
--DECLARE @sForeignConfirmNum Varchar(20)
DECLARE @CheckedOutOn Varchar(24)
--DECLARE @iOwningCompanyId SmallInt
--DECLARE @iUnitNum Int
--DECLARE @sUnitNum Varchar(35)
--DECLARE @dDefaultDate Datetime
--DECLARE @dEndDate Datetime

	/* 3/16/99 - cpy bug fix - was not looking at Credit_Card_Authorization and
			renter_primary_billing when doing CC search */
	/* 3/17/99 - cpy bug fix - unit number was not searching for foreign unit #s
			and did not accept alpha-numeric unit #s */
	/* 3/18/99 - cpy bug fix - set max rows returned to 100 from 2000
			- return foreign unit # if foreign
			- if > 1 VOC record for contract, return latest VOC
			  record for contract (currently DISABLED; if Bus.Analyst
			  require returning only 1 contract per row, remove the
			  comments following "@UnitNumber IS NULL") */
	/* 4/13/99 - cpy bug fix - uncommented lines following "@UnitNumber" to
			  only return 1 contract per row */
	/* 4/16/99 - cpy bug fix - handle retrieving contracts that have
			  VOC.checked_out > VOC.actual_check_in
			- apply LTRIM to @ContractNum and @ConfirmNum */
	/* 5/06/99 - cpy bug fix - allow for null foreign_contract_number
			- set default time to 23:59 if none provided on
			  @CODatetime */
	/* 8/18/99 - add join to Vehicle_Licence_History to search using historical
			licence instead of current licence */
	/* 9/01/99 - default VLH.Removed_On to '31 dec 2078' if VLH.Removed_On
			is NULL 
	rhe- aug 20 2005  - fix for db compability level 80
			*/

DECLARE @SQLString VARCHAR(3000)
DECLARE @sSelect VARCHAR(1000)
DECLARE @sTmpSelect VARCHAR(1000)

DECLARE @sFrom VARCHAR(200)
DECLARE @sWhere VARCHAR(2000)
DECLARE @sCCWhere VARCHAR(500)
DECLARE @bFirstCond varchar(10)
DECLARE @bFilterMax varchar(10)
DECLARE @UnitNum VARCHAR(35)
DECLARE @sOrderBy VARCHAR(50)

DECLARE @SQLStringWhere VARCHAR(2000)



SET ROWCOUNT 100 
	SELECT 	@ContractNum 	= NULLIF(LTRIM(@ContractNum),''),
--		@iContractNum 	=
--		   CASE WHEN ISNUMERIC(@ContractNum) = 1
--			THEN Convert(Int, NULLIF(@ContractNum,''))
--		   	ELSE NULL
--		   END,
--		@sForeignContractNum = NULLIF(LTRIM(@ContractNum),''),
		@ConfirmNum	= NULLIF(LTRIM(@ConfirmNum),''),
--		@iConfirmNum 	=
--		   CASE WHEN ISNUMERIC(@ConfirmNum) = 1
--		 	THEN Convert(Int, NULLIF(@ConfirmNum,''))
--		   	ELSE NULL
--		   END,
--		@sForeignConfirmNum = NULLIF(@ConfirmNum,''),
		@CheckedOutOn     =
		   CASE WHEN LEN(@CODatetime) = 11	-- "DD MMM YYYY"
			THEN @CODatetime + ' 23:59'
			ELSE @CODatetime
		   END,

		@LastName 	= NULLIF(@LastName,''),
		@FirstName 	= NULLIF(@FirstName,''),
		@DriverLicence 	= NULLIF(@DriverLicence,''),
		@CCType		= NULLIF(@CCType,''),
		@CCNumber	= NULLIF(@CCNumber,''),
		--@CompanyName 	= NULLIF(@CompanyName,""),
		@UnitNum 	= NULLIF(@UnitNumber,''),
--		@iUnitNum 	=
--		   CASE WHEN ISNUMERIC(@UnitNumber) = 1
--			THEN Convert(Int, NULLIF(@UnitNumber,''))
--			ELSE NULL
--		   END,
--		@sUnitNum	= NULLIF(@UnitNumber,''),
		@LicencePlate 	= NULLIF(@LicencePlate,''),
		@OwningCompanyId  = NULLIF(@OwningCompanyId,'')
--		@iOwningCompanyId = Convert(Int, NULLIF(@OwningCompanyId,'')),
--		@dDefaultDate 	= getdate(),
--		@dEndDate	= Convert(Datetime, '31 DEC 2078 23:59')

select @sSelect='SELECT	DISTINCT  
					CS.Contract_Number,
					Case WHEN(CS.Foreign_Contract_Number Is Null) 
						THEN Convert(Varchar(35),CS.Contract_Number) 
						Else CS.Foreign_Contract_Number 
					END as Foreign_Contract_Number, 
					CS.Last_Name, 
					CS.First_Name, 
					Convert(Varchar(17), CS.Pick_Up_On, 113) as Pick_Up_On, 
					CS.Pick_Up_Location, 
					Coalesce(CS.Foreign_Vehicle_Unit_Number, Convert(Varchar(10), CS.Unit_Number)) as Unit_Number, 
					Coalesce(CS.Licence_Plate_Number, CS.Current_Licence_Plate) as Licence_Plate_Number,
					CS.Status, 
					CS.Pick_Up_On '
select @sFrom = 'FROM Contract_Search CS '
    
select @sWhere = 'WHERE '
    
select @bFirstCond = 'True'
select @bFilterMax = 'True'

    If @ContractNum <>'' 
		BEGIN
			If IsNumeric(@ContractNum)=1 
			   --search on contract_number and foreign_contract_number if numeric
				begin
					if @bFirstCond= 'True' 
						 select @sWhere = @sWhere + 
									'(CS.Contract_Number = ''' + @ContractNum + ''' ' + 
									 'OR CS.Foreign_Contract_Number = ''' + @ContractNum + ''' ) '

						else
						  select @sWhere = @sWhere +  'AND ' + 
										'(CS.Contract_Number = ''' + @ContractNum + ''' ' + 
										 'OR CS.Foreign_Contract_Number = ''' + @ContractNum + ''' ) '
				end
			Else
				--if not numeric, must be foreign
				begin
					if @bFirstCond= 'True' 
						select @sWhere = @sWhere +
								'CS.Foreign_Contract_Number = ''' + @ContractNum + ''' '
					  else
						select @sWhere = @sWhere +  'AND ' + 
								'CS.Foreign_Contract_Number = ''' + @ContractNum + ''' '
				end
			select @bFirstCond = 'False'

		END

    If @OwningCompanyId <> ''
		Begin	
			if @bFirstCond= 'True'
				select @sWhere = @sWhere + 
								'CS.Owning_Company_ID = ''' + @OwningCompanyId + ''' '
			  else	
				select @sWhere = @sWhere + 'AND ' + 
								'CS.Owning_Company_ID = ''' + @OwningCompanyId + ''' '

			select @bFirstCond =  'False'
		End

    --added on 2005/06/17 for searching by MVA number
    If @MVANumber <> ''
		Begin	
			if @bFirstCond= 'True'
			   select @sWhere = @sWhere + 
								'replace(CS.MVA_Number,''-'','''')= replace(''' +  lTrim(rtrim(@MVANumber)) + ''',''-'','''') '
			  else
				   select @sWhere = @sWhere + 'AND ' + 
									'replace(CS.MVA_Number,''-'','''')= replace(''' +  lTrim(rtrim(@MVANumber)) + ''',''-'','''') '
			select @bFirstCond =  'False'
		end

    If @UnitNum <> ''
		Begin
        --'check if unit num (and optionally owning company id) are the only search params
			If rtrim(lTrim(@ContractNum + @ConfirmNum + @CheckedOutOn + @LicencePlate + @LastName +
						@FirstName + @DriverLicence + @CCType + @CCNumber + @CompanyName)) = ''
	            Begin
				--'if the only params we're searching on is UnitNum and OwningCompanyId, then
				--'use a union of two selects (one on the unit_number, the other on the
				--'foreign_unit_number) -- there is an index on unit_number and foreign_unit_number
				--'that is not used effectively when there is an OR
	            
					If IsNumeric(@UnitNum) =1
						Begin
							select @sTmpSelect = @sSelect + @sFrom + @sWhere
							if @bFirstCond= 'True' 
									select @sWhere = @sWhere +
												'CS.Unit_Number = ' + @UnitNum + ' ' +
												'UNION ' +
												@sTmpSelect +
												'CS.Foreign_Vehicle_Unit_Number = ''' + @UnitNum + ''' '
								else
									select @sWhere = @sWhere +  'AND ' +
												'CS.Unit_Number = ' + @UnitNum + ' ' + 
												'UNION ' + 
												@sTmpSelect + 'AND ' +
												'CS.Foreign_Vehicle_Unit_Number = ''' + @UnitNum + ''' '
						end
					Else
						Begin
							if @bFirstCond= 'True' 
								select @sWhere = @sWhere + 
											 'CS.Foreign_Vehicle_Unit_Number = ''' + @UnitNum + ''' '
							  Else
								select @sWhere = @sWhere + 'AND ' +
										 'CS.Foreign_Vehicle_Unit_Number = ''' + @UnitNum + ''' '
						end
	            End
			Else
				--if other params exist, then it's OK to use OR since the other params filter
				--the resultset and the OR is only applied to a small resultset
				If IsNumeric(@UnitNum)=1
					if @bFirstCond= 'True'  
						select @sWhere = @sWhere + 
									'(CS.Unit_Number = ' + @UnitNum + ' ' + 
									 'OR ' + 
									 'CS.Foreign_Vehicle_Unit_Number = ''' + @UnitNum + ''') '
					  else
						select @sWhere = @sWhere +'AND ' +
									'(CS.Unit_Number = ' + @UnitNum + ' ' + 
									 'OR ' +
									 'CS.Foreign_Vehicle_Unit_Number = ''' + @UnitNum + ''') '
				Else
					if @bFirstCond= 'True'  
						select @sWhere = @sWhere + 
									 'CS.Foreign_Vehicle_Unit_Number = ''' + @UnitNum + ''' '
				      else
						select @sWhere = @sWhere + 'AND '+
									 'CS.Foreign_Vehicle_Unit_Number = ''' + @UnitNum + ''' '
	        
			
			select @bFirstCond =  'False'
			select @bFilterMax =  'False'
	    End
    
    If @LicencePlate <> ''
		Begin
        --check if licence plate (and optionally owning company id) are the only search params
			If lTrim(rtrim(@ContractNum + @ConfirmNum + @CheckedOutOn + @UnitNum + @LastName + 
						@FirstName + @DriverLicence + @CCType + @CCNumber + @CompanyName)) = '' 
				Begin
				--if search is only on licence plate (and owning company), use Union instead
				--of OR -- faster
					select @sTmpSelect = @sSelect + @sFrom + @sWhere
					if @bFirstCond= 'True'
						select @sWhere = @sWhere +
									'CS.Licence_Plate_Number = ''' + @LicencePlate + ''' ' +
									'UNION ' +	@sTmpSelect + 
									'CS.Current_Licence_Plate = ''' + @LicencePlate + ''' '
					  Else
						select @sWhere = @sWhere + 'AND ' + 
									'CS.Licence_Plate_Number = ''' + @LicencePlate + ''' ' +
									'UNION ' +	@sTmpSelect + 'AND ' +
									'CS.Current_Licence_Plate = ''' + @LicencePlate + ''' '
				end
			Else
				if @bFirstCond= 'True'
					select @sWhere = @sWhere + 
								'(CS.Licence_Plate_Number = ''' + @LicencePlate + ''' ' +
								' OR ' +
								' CS.Current_Licence_Plate = ''' + @LicencePlate + ''') '
				  else	
					select @sWhere = @sWhere + 'AND ' +
								'(CS.Licence_Plate_Number = ''' + @LicencePlate + ''' ' + 
								' OR ' +
								' CS.Current_Licence_Plate = ''' + @LicencePlate + ''') '

			select @bFirstCond =  'False'
			select @bFilterMax =  'False'
		end

    If @CheckedOutOn <> ''
	  Begin	
		if @bFirstCond= 'True'
			select @sWhere = @sWhere + 
							'CS.Checked_Out <= Convert(Datetime, ''' + @CheckedOutOn + ''') ' +
							'AND ISNULL(CS.Actual_Check_In, CS.Expected_Check_In) >= Convert(Datetime, ''' + @CheckedOutOn + ''') '
		  else	
			select @sWhere = @sWhere + 'AND ' +
							'CS.Checked_Out <= Convert(Datetime, ''' + @CheckedOutOn + ''') ' +
							'AND ISNULL(CS.Actual_Check_In, CS.Expected_Check_In) >= Convert(Datetime, ''' + @CheckedOutOn + ''') '
        select @bFirstCond =  'False'
        select @bFilterMax =  'False'
	  End	
    
    If @LastName <> ''
	  Begin
		if @bFirstCond= 'True'
			select @sWhere = @sWhere +
						'CS.Last_Name LIKE ''' + @LastName + '%'' '
		  else	
			select @sWhere = @sWhere + 'AND ' + 
						'CS.Last_Name LIKE ''' + @LastName + '%'' '
        select @bFirstCond =  'False'
	  End
    
    If @FirstName <> ''
	  Begin
		if @bFirstCond= 'True'
			select @sWhere = @sWhere +
						'CS.First_Name LIKE ''' + @FirstName + '%'' '
		  else
			select @sWhere = @sWhere + 'AND ' +  
						'CS.First_Name LIKE ''' + @FirstName + '%'' '
        select @bFirstCond =  'False'
	  End
    
    If @CompanyName <> ''
	  Begin
		if @bFirstCond= 'True'
			select @sWhere = @sWhere +
						'CS.Company_Name LIKE ''' + @CompanyName + '%'' '
		  else
			select @sWhere = @sWhere + 'AND '+
						'CS.Company_Name LIKE ''' + @CompanyName + '%'' '
        select @bFirstCond =  'False'
	  End	
    
    If @ConfirmNum <> ''
		begin
			select @sFrom = @sFrom +
						'JOIN Reservation R ' +
						  'ON CS.Confirmation_Number = R.Confirmation_Number '

			If IsNumeric(@ConfirmNum) =1
				--search on confirm_number and foreign_confirm_number if numeric
				if @bFirstCond= 'True'
					select @sWhere = @sWhere + 
								'((R.Confirmation_Number = ' + @ConfirmNum + ' ' +
								   'AND CS.Confirmation_Number IS NOT NULL ' +
								   'AND R.Foreign_Confirm_Number IS NULL) ' +
								'OR ' +
								'R.Foreign_Confirm_Number = ''' + @ConfirmNum + ''') '
				  else
					select @sWhere = @sWhere +'AND '+
								'((R.Confirmation_Number = ' + @ConfirmNum + ' ' +
								   'AND CS.Confirmation_Number IS NOT NULL ' +
								   'AND R.Foreign_Confirm_Number IS NULL) ' +
								'OR ' +
								'R.Foreign_Confirm_Number = ''' + @ConfirmNum + ''') '
			 Else
				--if not numeric, must be foreign
				if @bFirstCond= 'True'
					select @sWhere = @sWhere +
								'R.Foreign_Confirm_Number = ''' + @ConfirmNum + ''' '
				  else	
					select @sWhere = @sWhere + 'AND '+
								'R.Foreign_Confirm_Number = ''' + @ConfirmNum + ''' '
			select @bFirstCond =  'False'
	  end
    
    If @DriverLicence <> ''
		Begin
			select @sFrom = @sFrom +
						'JOIN Renter_Driver_Licence RDL ' +
						  'ON CS.Contract_Number = RDL.Contract_Number '
			if @bFirstCond= 'True'
				select @sWhere = @sWhere + 
							'RDL.Licence_Number = ''' + @DriverLicence + ''' '
			  else	
				select @sWhere = @sWhere + 'AND '+
							'RDL.Licence_Number = ''' + @DriverLicence + ''' '
			select @bFirstCond =  'False'
		End
    
	select @sCCWhere=''

    If @CCType <> '' Or @CCNumber <> '' 
	  Begin	
        If @CCType <> '' 
			Begin
				select @sCCWhere = 'WHERE Credit_Card_Type_Id = ''' + @CCType + ''' '
				If @CCNumber <> ''
					select @sCCWhere = @sCCWhere+'AND ES.trn_card_number LIKE ''' + Replace(@CCNumber, '*', '%') + ''' '
			end
        Else
            If @CCNumber <> ''
                select @sCCWhere = 'WHERE ES.trn_card_number LIKE ''' + Replace(@CCNumber, '*', '%') + ''' '
        
        if @bFirstCond= 'True'
			select @sWhere = @sWhere + 
						'CS.Contract_Number IN ( ' +
							'SELECT Distinct Contract_Number ' +
							'FROM   Credit_Card_Payment CCP ' +
								   'JOIN Credit_Card CC ' +
									 'ON CCP.Credit_Card_Key = CC.Credit_Card_Key ' +
									'left join Eigen_Settlement_CRTransReport ES on CCP.authorization_number=ES.trn_auth_code and right(rtrim(cc.Credit_Card_Number),4)=right(rtrim(ES.trn_card_number),4) '+
							@sCCWhere +
							'UNION ' +
							'SELECT Distinct Contract_Number ' +
							'FROM   Credit_Card_Authorization CCA ' +
								   'JOIN Credit_Card CC2 ' +
									 'ON CCA.Credit_Card_Key = CC2.Credit_Card_Key ' +
									'left join Eigen_Settlement_CRTransReport ES on CCA.authorization_number=ES.trn_auth_code and right(rtrim(cc2.Credit_Card_Number),4)=right(rtrim(ES.trn_card_number),4) '+
							@sCCWhere +
							'UNION ' +
							'SELECT Distinct Contract_Number ' +
							'FROM   Renter_Primary_Billing RPB ' +
								   'JOIN Credit_Card CC3 ' +
									 'ON RPB.Credit_Card_Key = CC3.Credit_Card_Key ' +
									'left join Eigen_Settlement_CRTransReport ES on  right(rtrim(cc3.Credit_Card_Number),4)=right(rtrim(ES.trn_card_number),4) ' +
									'and right(cc3.Expiry,2)=right(ES.trn_card_Expire,2) and  left(cc3.Expiry,2)=left(ES.trn_card_Expire,2) ' +
							@sCCWhere +
						') '
		  else
			select @sWhere = @sWhere + 'AND '+
						'CS.Contract_Number IN ( ' +
							'SELECT Contract_Number ' +
							'FROM   Credit_Card_Payment CCP ' +
								   'JOIN Credit_Card CC ' +
									 'ON CCP.Credit_Card_Key = CC.Credit_Card_Key ' +
									'left join Eigen_Settlement_CRTransReport ES on CCP.authorization_number=ES.trn_auth_code and right(rtrim(cc.Credit_Card_Number),4)=right(rtrim(ES.trn_card_number),4) '+
							@sCCWhere +
							'UNION ' +
							'SELECT Contract_Number ' +
							'FROM   Credit_Card_Authorization CCA ' +
								   'JOIN Credit_Card CC2 ' +
									 'ON CCA.Credit_Card_Key = CC2.Credit_Card_Key ' +
									'left join Eigen_Settlement_CRTransReport ES on CCA.authorization_number=ES.trn_auth_code and right(rtrim(cc2.Credit_Card_Number),4)=right(rtrim(ES.trn_card_number),4) '+
							@sCCWhere +
							'UNION ' +
							'SELECT Contract_Number ' +
							'FROM   Renter_Primary_Billing RPB ' +
								   'JOIN Credit_Card CC3 ' +
									 'ON RPB.Credit_Card_Key = CC3.Credit_Card_Key ' +
									'left join Eigen_Settlement_CRTransReport ES on  right(rtrim(cc3.Credit_Card_Number),4)=right(rtrim(ES.trn_card_number),4) ' +
									'and right(cc3.Expiry,2)=right(ES.trn_card_Expire,2) and  left(cc3.Expiry,2)=left(ES.trn_card_Expire,2) ' +
							@sCCWhere +
						') '
        select @bFirstCond =  'False'
      end 

    If @bFilterMax =  'True' 
        --return only the most recently checked out vehicle there is > 1 vehicle on contract
		if @bFirstCond= 'True'
			select @sWhere = @sWhere +
								'( (CS.Checked_Out IS NOT NULL ' +
									'AND ' +
									'CS.Checked_Out = ( SELECT   MAX(VOC2.Checked_Out) ' +
														'FROM    Vehicle_On_Contract VOC2 ' +
														'WHERE   VOC2.Contract_Number = CS.Contract_Number ) ' +
									') ' +
								   'OR ' +
								   'CS.Checked_Out IS NULL ) '
		  else
			select @sWhere = @sWhere +'AND '+
								'( (CS.Checked_Out IS NOT NULL ' +
									'AND ' +
									'CS.Checked_Out = ( SELECT   MAX(VOC2.Checked_Out) ' +
														'FROM    Vehicle_On_Contract VOC2 ' +
														'WHERE   VOC2.Contract_Number = CS.Contract_Number ) ' +
									') ' +
								   'OR ' +
								   'CS.Checked_Out IS NULL ) '

    select @sOrderBy = 'Order By CS.Pick_Up_On Desc'
    
    select @SQLString =  @sSelect + @sFrom + @sWhere + @sOrderBy 

--print @sWhere
--	PRINT @SQLString
	EXEC (@SQLString)

	Return @@ROWCOUNT










-------------------------------------PM Schedule changes  ------------------------------------------------------------------------------------------------







set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON

GO
