USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[sp_MSins_bgt_armaster_base]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSins_bgt_armaster_base] @c1 binary(8),@c2 varchar(12),@c3 varchar(12),@c4 smallint,@c5 smallint,@c6 smallint

AS
BEGIN


insert into "bgt_armaster_base"( 
"timestamp", "customer_code", "ship_to_code", "address_type", "po_num_reqd_flag", "claim_num_reqd_flag"
 )

values ( 
@c1, @c2, @c3, @c4, @c5, @c6
 )


END
GO
