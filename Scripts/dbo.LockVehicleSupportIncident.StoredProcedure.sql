USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LockVehicleSupportIncident]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To lock a vehicle support incident
AUTHOR: Niem Phan
DATE CREATED: Jan 12, 2000
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[LockVehicleSupportIncident]
	@SeqNum varchar(11)
AS

	DECLARE @iSeqNum integer
	SELECT @iSeqNum = CAST(NULLIF(@SeqNum, '') AS integer)

	SELECT	COUNT(*)
	  FROM	Vehicle_Support_Incident WITH(UPDLOCK)
	 WHERE	Vehicle_Support_Incident_Seq = @iSeqNum




GO
