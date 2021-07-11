USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehSupportComment]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehSupportComment    Script Date: 2/18/99 12:12:23 PM ******/
/****** Object:  Stored Procedure dbo.GetVehSupportComment    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehSupportComment    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehSupportComment    Script Date: 11/23/98 3:55:34 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetVehSupportComment]
	@Sequence Varchar(10)
AS
	/* 4/13/99 - cpy bug fix - format Logged_On to DD MMM YYYY HH:MM */
	/* 4/15/99 - cpy bug fix - order by logged_on and comment_seq desc */

	Declare	@nSequence Integer
	Select		@nSequence = Convert(Int, NULLIF(@Sequence,''))

	SELECT	Comment,
		Logged_By,
		Convert(Varchar(17), Logged_On, 113)
	FROM	Vehicle_Support_Comment
	WHERE	Vehicle_Support_Incident_Seq = @nSequence
	ORDER BY
		Logged_On DESC, Comment_Seq DESC
	RETURN @@ROWCOUNT















GO
