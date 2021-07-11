USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVSILastUpdated]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[GetVSILastUpdated]
	@SeqNum VarChar(10)
AS

/*  PURPOSE:		To retrieve the last update on date for the given Sequence number
     AUTHOR:		Niem Phan
     MOD HISTORY:
     Name    Date        Comments
*/
	DECLARE	@iSeqNum Int
	SELECT @iSeqNum = CONVERT(Int, NULLIF(@SeqNum, ''))

	SELECT	
			Vehicle_Support_Incident_Seq,
			CONVERT(VarChar, Last_Updated_On, 113) Last_Updated_On
	
	FROM		Vehicle_Support_Incident

	WHERE	Vehicle_Support_Incident_Seq = @iSeqNum
	
RETURN @@ROWCOUNT


GO
