USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[sp_MSins_glchart_base]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSins_glchart_base] @c1 binary(8),@c2 varchar(32),@c3 varchar(40),@c4 smallint,@c5 smallint,@c6 varchar(32),@c7 varchar(32),@c8 varchar(32),@c9 varchar(32),@c10 smallint,@c11 smallint,@c12 int,@c13 int,@c14 smallint,@c15 varchar(8),@c16 smallint,@c17 varchar(8),@c18 varchar(8)

AS
BEGIN


insert into "glchart_base"( 
"timestamp", "account_code", "account_description", "account_type", "new_flag", "seg1_code", "seg2_code", "seg3_code", "seg4_code", "consol_detail_flag", "consol_type", "active_date", "inactive_date", "inactive_flag", "currency_code", "revaluate_flag", "rate_type_home", "rate_type_oper"
 )

values ( 
@c1, @c2, @c3, @c4, @c5, @c6, @c7, @c8, @c9, @c10, @c11, @c12, @c13, @c14, @c15, @c16, @c17, @c18
 )


END
GO
