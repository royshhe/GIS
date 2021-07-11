USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationFee]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [dbo].[GetLocationFee]
	@LocId	VarChar(10),
	@ResnetOnly Char(1) = '0'
AS
/*
	Purpose:	To return Location fees for the given location id
*/

	DECLARE	@iLocID SmallInt
	SELECT	@iLocID = CONVERT(SmallInt, NULLIF(@LocID, ''))

	SELECT 	Percentage_Fee,
			Flat_Fee 		

	FROM		Location L WITH(NOLOCK)

	WHERE	L.Location_Id = @iLocID
	AND		L.Delete_Flag = 0
	AND 		L.Rental_Location = 1
	AND 		(  L.Resnet = 1
		   	 OR @ResnetOnly = '0'
		    	)
	ORDER BY L.Location

	RETURN @@ROWCOUNT





GO
