USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOwningCompanyCount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetOwningCompanyCount    Script Date: 2/18/99 12:11:46 PM ******/
/****** Object:  Stored Procedure dbo.GetOwningCompanyCount    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetOwningCompanyCount    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetOwningCompanyCount    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetOwningCompanyCount]
	@OwningCompanyID VarChar(10)
AS
   	SELECT	Count(*)
	FROM	Owning_Company
	WHERE	Owning_Company_ID = CONVERT(SmallInt, @OwningCompanyID)
   	RETURN 1













GO
