USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SearchConCust]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[SearchConCust]   --'NI','PETER','','','9876543210','','1977/02/01','0','0'
--[dbo].[SearchConCust]  'NI','PETER','Richmond','60467981119','','','1977/02/01','0','0'
	@LastName Varchar(25),
	@FirstName Varchar(25),
	@City Varchar(25),
	@Phone Varchar(35),
	@DLNum Varchar(25),
	@Jurisdiction Varchar(20),
	@BirthDate varchar(24)='',
	@Flag Varchar(1)='1' ,
	@DoNotRentFlag Varchar(1)='0'
AS
Declare @sLastName	Varchar(25)
Declare @sFirstName	Varchar(25)
Declare @sCity		Varchar(25)
Declare @sPhone		Varchar(35)
Declare @sDLNum	Varchar(25) 
Declare @sJurisdiction		Varchar(25)
Declare @sBirthDate		Varchar(24)
Declare @sSearchType Varchar(25)

DECLARE @SQLString VARCHAR(5000) 

	/* 3/15/99 - cpy bug fix - return matches using AND on all fields instead of union */
	/* 3/22/99 - cpy modified - added Jurisdiction; can only use Jurisdiction if DL provided */
	/* 10/05/99 - @DLNum varchar(15) -> varchar(25) */
	/* 11/09/99 - do LTRIM outside of SQL; removed OR in where clause; break select up 
			into 3 versions depending on DLnum and jurisdiction provided or not 
		    - specify index to use in each select */
	/* Nov 04 2001 - enforce to use IX_Customer_DLNumber */

		SELECT @DLNum =Replace(@DLNum, ' ','')
		SELECT @DLNum =Replace(@DLNum, '-','')
		SELECT @DLNum =Replace(@DLNum, '/','')
		SELECT @DLNum =Replace(@DLNum, '*','')

	if @BirthDate<>''
		select @sBirthDate=ltrim(convert(varchar(24),convert(datetime,@BirthDate,101)))
	SELECT	@sDLNum = LTRIM(@DLNum),
		@sJurisdiction = LTRIM(@Jurisdiction),
		@sLastName = LTRIM(@LastName ),
		@sFirstName = LTRIM(@FirstName ),
		@sCity = LTRIM(@City ),
		@sPhone = LTRIM(@Phone ),
		@sSearchType=' = '

	if @flag='0' 
		begin
			select @sBirthDate=@sBirthDate+'%'
			select @sDLNum=@sDLNum+'%'
			select @sJurisdiction=@sJurisdiction+'%'
			select @sLastName=@sLastName+'%'
			select @sFirstName=@sFirstName+'%'
			select @sCity=@sCity+'%'
			select @sPhone=@sPhone+'%'
			select @sSearchType=' like '
		end


    SET ROWCOUNT 100

	IF @DLNum IS NULL  or @DLNum=''
		/* do search by name, city, and phone */
		BEGIN
            select @SQLString=' SELECT	top 100 Cust.Customer_ID, Cust.Program_Number, Cust.Last_Name, Cust.First_Name,
			Cust.Address_1 +space(1)+ISNULL(Cust.Address_2,''''), Cust.City, Cust.Phone_Number, 
			 Cust.Driver_Licence_Number, 
			Convert(Char(1), Cust.Do_Not_Rent), Cust.Remarks, Cust.Birth_Date,
			CC.Credit_card_type_ID, CC.Credit_card_Number, CC.Expiry, CC.Last_Name Car_Holder_Last_Name, CC.First_Name Card_Holder_First_Name
            From       Customer	Cust left Join Credit_Card   CC
            On	 Cust.Customer_ID=CC.Customer_ID
            Where      Cust.Inactive = 0' 

        if @LastName<>'' 
           Select @SQLString= @SQLString +' And Cust.Last_Name '+@sSearchType +''''+replace(@sLastName,"'","''")+''''
        if @FirstName <> ''
               Select @SQLString= @SQLString +' And         Cust.First_Name '+@sSearchType+''''+replace(@sFirstName,"'","''")+''''
        if @City <> ''
           Select @SQLString= @SQLString +' And ISNULL(Cust.City,'''') '+@sSearchType+''''+@sCity+''''
        if @Jurisdiction<> ''
           Select @SQLString= @SQLString +' And Cust.Jurisdiction '+@sSearchType+ ''''+ @sJurisdiction+''''
        if @Phone <> ''
           Select @SQLString= @SQLString +' And ISNULL(Cust.Phone_Number,'''') '+@sSearchType+ ''''+ @sPhone+''''
        if @BirthDate <> ''
           Select @SQLString= @SQLString +' And ISNULL(convert(datetime,Cust.Birth_Date,101),'''') '+@sSearchType+ ''''+ @sBirthDate+''''
        if @DoNotRentFlag = '1'
           Select @SQLString= @SQLString +' And Cust.Do_Not_Rent=1'
       Select @SQLString= @SQLString +' 
            ORDER BY Cust.Last_Name, Cust.First_Name, Cust.City'
	   END
	ELSE
	BEGIN
			/* do search by name, city, phone, DLnum, and jurisdiction */
            select @SQLString=' SELECT	top 100 Cust.Customer_ID, Cust.Program_Number, Cust.Last_Name, Cust.First_Name,
			Cust.Address_1 +space(1)+ISNULL(Cust.Address_2,''''), Cust.City, Cust.Phone_Number, 
			 Cust.Driver_Licence_Number, 
			Convert(Char(1), Cust.Do_Not_Rent), Cust.Remarks, Cust.Birth_Date,
			CC.Credit_card_type_ID, CC.Credit_card_Number, CC.Expiry, CC.Last_Name Car_Holder_Last_Name, CC.First_Name Card_Holder_First_Name
            From       Customer	Cust left Join Credit_Card   CC
            On	 Cust.Customer_ID=CC.Customer_ID
            Where      Cust.Inactive = 0' 

        if @LastName<>'' 
           Select @SQLString= @SQLString +' And Cust.Last_Name '+@sSearchType+ ''''+replace(@sLastName,"'","''")+''''
        if @FirstName <> ''
               Select @SQLString= @SQLString +' And Cust.First_Name '+@sSearchType+ ''''+replace(@sFirstName,"'","''")+''''
        if @City <> ''
           Select @SQLString= @SQLString +' And ISNULL(Cust.City,'''') '+@sSearchType+''''+@sCity+''''
        if @Jurisdiction<> ''
           Select @SQLString= @SQLString +' And Cust.Jurisdiction '+@sSearchType+ ''''+ @sJurisdiction+''''
            if @Phone <> ''
           Select @SQLString= @SQLString +' And ISNULL(Cust.Phone_Number,'''') '+@sSearchType+ ''''+ @sPhone+''''
            if @DLNum<> ''
               Select @SQLString= @SQLString +' And       replace(replace(replace(replace(Cust.Driver_Licence_Number,''*'',''''),'' '',''''),''/'',''''),''-'','''') '+@sSearchType+ ''''+@sDLNum+''''
        if @BirthDate <> ''
           Select @SQLString= @SQLString +' And ISNULL(convert(datetime,Cust.Birth_Date,101),'''') '+@sSearchType+ ''''+ @sBirthDate+''''
        if @DoNotRentFlag = '1'
           Select @SQLString= @SQLString +' And Cust.Do_Not_Rent=1'

        Select @SQLString= @SQLString +' 
            ORDER BY Cust.Last_Name, Cust.First_Name, City'

	END

--print @SQLString
 
exec (@SQLString) 

   SET ROWCOUNT 0
	RETURN @@ROWCOUNT
GO
