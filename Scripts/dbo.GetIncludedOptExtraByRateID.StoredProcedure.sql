USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetIncludedOptExtraByRateID]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO











CREATE PROCEDURE [dbo].[GetIncludedOptExtraByRateID]
@RateID varchar(20)
AS
Set Rowcount 2000
Select Distinct
	IOE.Optional_Extra_ID,
	OE.Optional_Extra,
	OE.Type
From
	Included_Optional_Extra IOE,
	Optional_Extra OE
Where
	IOE.Rate_ID = Convert(int, @RateID)
	And IOE.Termination_Date = 'Dec 31 2078 11:59PM'
        And IOE.Optional_Extra_ID = OE.Optional_Extra_ID
	And OE.Delete_Flag=0
Order By
	OE.Optional_Extra
Return 1













GO
