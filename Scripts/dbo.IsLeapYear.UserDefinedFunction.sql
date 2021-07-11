USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[IsLeapYear]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IsLeapYear] ( @pDate    DATETIME )
RETURNS BIT
AS
BEGIN

    IF (YEAR( @pDate ) % 4 = 0 AND YEAR( @pDate ) % 100 != 0) OR
        YEAR( @pDate ) % 400 = 0
        RETURN 1

    RETURN 0

END
GO
