USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SeeError]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




/*  Programmer :     Jack Jian
     Date :                Mar 01, 2001
*/     

CREATE PROCEDURE [dbo].[SeeError]

	@Date varchar(255) ,
	@Code1 varchar(255) = 'Accounting' ,
	@code2  varchar(255) = 'CloseBDay'
as

select 
	blog.Process_Code ,
	blog.Process_Date  ,              
	blog.Batch_Start_Date ,
	blog.Error_Number ,
	substring(msg.Message1 , 1 , 30)  as Error_Msg ,
	substring(blog.Data_1, 1 , 30) as data1
from batch_error_log blog
join batch_error_message msg
on blog.Error_Number = msg.Error_Number
where blog.Process_date >=rtrim( ltrim(@Date ))
	and  (blog.process_code = @Code1 or blog.process_code = @Code2 )
	and blog.process_code <> 'Maestro'
	and blog.process_code <> 'No Show'

GO
