USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SecCheckUserLocation]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


-------------------------------------------------------------------------------------------------------------------
----  Programmer:  Jack Jian
----  Date: 	 Dec 22, 2001
----  Details:	 check user location
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SecCheckUserLocation]
	@location varchar(255) ,
	@result varchar(1) output
as

	SET XACT_ABORT on
	SET NOCOUNT ON

	declare @CompanyCode int  --remove hardcode code
	select @CompanyCode=Code from Lookup_Table where Category = 'BudgetBC Company'

	set @result = '0 '

	select 1 
	from location 
	where 	location = @location and
		Owning_Company_ID = @CompanyCode

	if @@rowcount <> 1 
		set @result = '0'
	else
		set @result = '1'

	SET NOCOUNT Off
	SET XACT_ABORT off






GO
