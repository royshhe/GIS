USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetMaestroData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetMaestroData]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	  CONVERT(date, CONVERT(varchar(12), res.Pick_Up_On, 112))  AS Pick_Up_On,
	  CASE WHEN COUNT(res.Confirmation_Number) = 0
	  then NULL
	  else COUNT(res.Confirmation_Number)
	  end
	  AS 'Res_Cnt'

        FROM
	  [dbo].[Reservation] res

        WHERE res.Pick_Up_On between dateadd(DAY, datediff(DAY, 0, getdate()),0)  and dateadd(DAY, datediff(DAY, 0, getdate()),13.999)
        and res.status IN ('A','O')

        group by CONVERT(date, CONVERT(varchar(12), res.Pick_Up_On, 112))
        order by CONVERT(date, CONVERT(varchar(12), res.Pick_Up_On, 112))
END
GO
