USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehSupportActionLog]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehSupportActionLog    Script Date: 2/18/99 12:12:23 PM ******/
/****** Object:  Stored Procedure dbo.GetVehSupportActionLog    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehSupportActionLog    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehSupportActionLog    Script Date: 11/23/98 3:55:34 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetVehSupportActionLog]
	@Sequence Varchar(10)
AS
	/* 4/14/99 - cpy bug fix - format Logged_On to be DD MMM YYYY HH:MM */
	/* 4/15/99 - cpy bug fix - order by logged_on and Action_Seq desc */
	Declare	@nSequence Integer
	Select		@nSequence = Convert(Int, NULLIF(@Sequence,''))

	SELECT	VSAL.Action,
		VSAL.Contact_Information,
		VSAL.Logged_By,
		Convert(Varchar(17), VSAL.Logged_On, 113)
	FROM	Vehicle_Support_Action_Log VSAL
	WHERE	VSAL.Vehicle_Support_Incident_Seq = @nSequence
	ORDER BY
		VSAL.Logged_On DESC, Action_Seq DESC
	RETURN @@ROWCOUNT















GO
