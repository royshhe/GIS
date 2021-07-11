USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[TempUpdatereservation]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[TempUpdatereservation] 
as
Update reservation set status ='N' 
WHERE     (Pick_Up_On < '3/10/2003 5:07:01 AM') and status='a'
GO
