USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SaveTrx]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[SaveTrx] AS

declare @iTmp int

update batch_error_Log
set maestro_id = 9999
where id = 18996

insert into batch_error_log
(process_code, process_date, batch_start_date, error_number)
values
('TST',getdate(), getdate(), Null)

/* update batch_error_log
set error_number = null
where id = 18996 */


return @@ROWCOUNT



GO
