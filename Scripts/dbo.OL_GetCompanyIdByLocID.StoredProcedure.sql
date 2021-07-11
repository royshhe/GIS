USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[OL_GetCompanyIdByLocID]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OL_GetCompanyIdByLocID]  --43
	@Location VarChar(25)
AS
	/* 6/10/99 - added mnemonic code to the end */
	Declare @OwningCompanyID smallint
	Declare @MnemonicCode varchar(20)
	
   	SELECT	 
		@OwningCompanyID =Location.Owning_Company_ID,@MnemonicCode = Mnemonic_Code

   	FROM   	Location 
   	inner join Owning_Company
   	on Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
	WHERE	Location.Location_Id = CONVERT(SmallInt, @Location)
	AND	Location.Delete_Flag = 0
	
	--print @MnemonicCode
	if @OwningCompanyID=7425
	 
		Select @OwningCompanyID, Location_ID from [svbvm021].gisdata.dbo.location
			where @MnemonicCode=Mnemonic_Code
	else
	 
		if @OwningCompanyID=7440 or @OwningCompanyID=8411
			Begin 
				Select @OwningCompanyID, Location_ID from [svbvm021].VICDB.dbo.location
				where @MnemonicCode=Mnemonic_Code
			End
		Else
			Begin
				if @OwningCompanyID=8410		
				Select @OwningCompanyID, Location_ID from [svbvm021].DevonDB.dbo.location
				where @MnemonicCode=Mnemonic_Code
				
			End
    
		
   	RETURN 1
 
 
 --select * from location
 
 --exec OL_GetCompanyIdByLocID @Location = '221'
GO
