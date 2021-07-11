USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxGetServerTime]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







---------------------------------------------------------------------------------------------------------
-------   Programmer :  Jack Jian
------    Date: 	      Apr 05 , 2001
------    Details:	      Return the server hour and minute
---------------------------------------------------------------------------------------------------------



CREATE PROCEDURE [dbo].[AutoFaxGetServerTime]
	@Server_hour int output ,
	@Server_minute int output  ,
	@whole_thing varchar(255) output

AS
	
	SELECT @server_hour = convert( int ,  DATEPART(hour, GETDATE()) )
	SELECT @server_minute = convert( int ,  DATEPART(minute, GETDATE()) )
	select @whole_thing = getdate()




GO
