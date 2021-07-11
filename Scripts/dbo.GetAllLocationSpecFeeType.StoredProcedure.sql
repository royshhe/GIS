USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllLocationSpecFeeType]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







CREATE Procedure [dbo].[GetAllLocationSpecFeeType]
AS
	
Select Value, Code
From LookUp_table
Where Category = 'Charge Type Calculated' and (Code = 35 or Code = 96 or Code = 39 or code=46)



GO
