USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResComments]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/****** Object:  Stored Procedure dbo.GetResComments    Script Date: 2/18/99 12:12:03 PM ******/
/****** Object:  Stored Procedure dbo.GetResComments    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResComments    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResComments    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetResComments]-- '2184540'
	@ConfirmNum	Varchar(10)
AS
	/* 3/08/99 - cpy bug fix - not returning standard print comments;
				- moved init of @iConfirmNum before CommentCur declare */
	/* 5/11/99 - cpy modified - specified cursor as Fast_foward; close cursor */
	/* 9/3/99 - Order By RSC.Reservation_Comment */
	/* 8/3/05 - rhe Fix for db compatibility level 80*/

DECLARE @iConfirmNum Integer
DECLARE @SpecComment Varchar(255)
DECLARE @PrintComment Varchar(800)
DECLARE @tmpComment Varchar(800)

	SELECT 	@iConfirmNum = Convert(Int, NULLIF(@ConfirmNum,''))

DECLARE CommentCur CURSOR FAST_FORWARD FOR
	(SELECT	RSC.Reservation_Comment + Char(13) + Char(10)
--select *
	FROM	Reservation_Standard_Comment RSC,
		Reservation_Comment RC
	WHERE	RC.Reservation_Comment_ID = RSC.Reservation_Comment_ID
	AND	RC.Confirmation_Number = @iConfirmNum
--	ORDER BY
--		RSC.Reservation_Comment

	union
	
	SELECT 	case when Description is not null
					then Description + Char(13) + Char(10)
					else ''
			end as Description
	FROM	Reserved_Rental_Accessory  
	WHERE	Confirmation_Number = Convert(Int, @ConfirmNum) 
	)


	/* get the special comments */
	SELECT 	@SpecComment = Special_Comments
	FROM	Reservation
	WHERE	Confirmation_Number = @iConfirmNum

	/* get the standard print comments and append
	   them into 1 string */
	OPEN CommentCur
	FETCH FROM CommentCur INTO @tmpComment
        --FOR COMPATIBILITY LEVEL 80
        --INITIALIZE FIRST 
	SELECT @PrintComment=''

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @PrintComment =
			-- use IS NULL
			CASE
				WHEN @PrintComment IS NULL THEN @tmpComment
				ELSE @PrintComment + @tmpComment
			END

		FETCH NEXT FROM CommentCur INTO @tmpComment
	END
	
	CLOSE CommentCur
	DEALLOCATE CommentCur
	SELECT
		@PrintComment + @SpecComment
	WHERE
		len(@PrintComment + @SpecComment) > 0

	RETURN @@ROWCOUNT


GO
