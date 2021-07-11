USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockOwningCompany]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To lock the owning company record for the given owning company id
AUTHOR: Niem Phan
DATE CREATED: Jan 14, 2000
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockOwningCompany]
	@OwningCompanyId varchar(11)
AS

	DECLARE	@iOwningCompanyId SmallInt
	SELECT 	@iOwningCompanyId = CAST(NULLIF(@OwningCompanyId, '') AS SmallInt)

	SELECT	COUNT(*)
	  FROM	Owning_Company WITH(UPDLOCK)
	 WHERE	Owning_Company_Id = @iOwningCompanyId





GO
