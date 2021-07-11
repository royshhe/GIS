USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetUpdServerDate]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-----------------------------------------------------------------------------------------
--  Programmer:     Vivian Leung
--  Date:           07 Oct 2002
--  Details:        To retrieve the system date
-----------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[GetUpdServerDate]
AS
	SELECT left (getdate(), 11) as ServerDate,  right (getdate(), 7) as ServerTime
GO
