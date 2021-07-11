USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCtrctChgItemdscpt]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Function [dbo].[GetCtrctChgItemdscpt]
(
	@ContractNumber VarChar(45)
) 

RETURNS VarChar(500)
AS
BEGIN
		DECLARE @ItemDscripts  VarChar(500)
		declare @ChargeDescription varchar(50)
 		select @ItemDscripts=''
     
				DECLARE Item_cursor CURSOR FOR
					SELECT	ChargeType.Value+ '-'+ Charge_Description
					FROM	Contract_Charge_Item WITH(NOLOCK)
					Inner Join 
					(select * from lookup_table where category like '%charge type adj%') ChargeType
					On Contract_Charge_Item.Charge_Type =ChargeType.Code
					
					where contract_number=@ContractNumber
					and Charge_Item_type='a'  and Charge_type in ('14',
																	'20',
																	'23',
																	'34',
																	'36',
																	'37',
																	'61',
																	'62',
																	'63',
																	'64',
																	'67',
																	'68',
																	'76',
																	'98',
																	'60')
					

				OPEN Item_cursor
				FETCH NEXT FROM Item_cursor
				INTO @ChargeDescription

				WHILE @@FETCH_STATUS = 0
					BEGIN
						Select @ItemDscripts= @ItemDscripts +@ChargeDescription +'/'
						FETCH NEXT FROM Item_cursor
						INTO @ChargeDescription
					End
				CLOSE Item_cursor
				DEALLOCATE Item_cursor

		RETURN @ItemDscripts
END
 




GO
