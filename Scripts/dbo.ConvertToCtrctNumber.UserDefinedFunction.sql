USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertToCtrctNumber]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






CREATE FUNCTION [dbo].[ConvertToCtrctNumber] 
(
  @strInvoiceNumber Varchar(20), 
  @Prefix char(5),
   @InvType char(5)
)

RETURNS int 
AS
BEGIN


Return convert(int, 
                                  substring (@strInvoiceNumber, 
                                                  CHARINDEX(ltrim(rtrim(@Prefix)), @strInvoiceNumber)+1,
                                                 len( @strInvoiceNumber)-CHARINDEX(ltrim(rtrim(@Prefix)), @strInvoiceNumber)
													-( len(@strInvoiceNumber)-
                                                            
                                                                (
																  Case when PATINDEX('%'+ltrim(rtrim(@InvType))+'%', @strInvoiceNumber)>0 then
																         (PATINDEX('%'+ltrim(rtrim(@InvType))+'%', @strInvoiceNumber)-1)
                                                                         Else len( @strInvoiceNumber)
                                                                 End)
																)

										 )
                                   )






END






GO
