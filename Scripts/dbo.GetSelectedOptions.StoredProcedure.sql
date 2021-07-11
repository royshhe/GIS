USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSelectedOptions]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetSelectedOptions    Script Date: 2/18/99 12:12:04 PM ******/
/****** Object:  Stored Procedure dbo.GetSelectedOptions    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetSelectedOptions    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetSelectedOptions    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetSelectedOptions]
@ClassCode varchar(35)
AS
Set Rowcount 2000
Select Distinct
	A.Optional_Extra_ID
From
	Optional_Extra A, Optional_Extra_Restriction B
Where
	A.Optional_Extra_ID Not In
		(Select
			A.Optional_Extra_ID
		From
			Optional_Extra A, Optional_Extra_Restriction B

		Where
			B.Vehicle_Class_Code=@ClassCode
			And A.Optional_Extra_ID=B.Optional_Extra_ID)
	And A.Delete_Flag=0
Return 1












GO
