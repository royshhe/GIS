USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[sp_MSins_armaster_base]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSins_armaster_base] @c1 binary(8),@c2 varchar(12),@c3 varchar(12),@c4 varchar(60),@c5 varchar(10),@c6 varchar(40),@c7 varchar(40),@c8 varchar(40),@c9 varchar(40),@c10 varchar(40),@c11 varchar(40),@c12 varchar(40),@c13 varchar(40),@c14 varchar(40),@c15 smallint,@c16 smallint,@c17 varchar(40),@c18 varchar(30),@c19 varchar(40),@c20 varchar(30),@c21 varchar(30),@c22 varchar(30),@c23 varchar(30),@c24 varchar(8),@c25 varchar(8),@c26 varchar(8),@c27 varchar(8),@c28 varchar(8),@c29 varchar(8),@c30 varchar(8),@c31 varchar(8),@c32 varchar(8),@c33 varchar(8),@c34 varchar(8),@c35 varchar(8),@c36 varchar(8),@c37 varchar(12),@c38 varchar(8),@c39 smallint,@c40 varchar(8),@c41 varchar(8),@c42 varchar(8),@c43 varchar(8),@c44 varchar(255),@c45 float,@c46 smallint,@c47 smallint,@c48 smallint,@c49 smallint,@c50 float,@c51 smallint,@c52 smallint,@c53 smallint,@c54 smallint,@c55 varchar(30),@c56 varchar(20),@c57 int,@c58 varchar(20),@c59 smallint,@c60 smallint,@c61 smallint,@c62 smallint,@c63 char(8),@c64 smallint,@c65 int,@c66 varchar(30),@c67 datetime,@c68 varchar(30),@c69 datetime,@c70 varchar(8),@c71 varchar(8),@c72 smallint,@c73 varchar(8),@c74 smallint,@c75 varchar(40),@c76 varchar(40),@c77 varchar(15),@c78 varchar(40),@c79 varchar(10),@c80 varchar(10),@c81 varchar(10),@c82 varchar(10),@c83 int,@c84 varchar(50),@c85 varchar(255),@c86 varchar(32),@c87 char(1),@c88 varchar(8),@c89 smallint,@c90 smallint

AS
BEGIN


insert into "armaster_base"( 
"timestamp", "customer_code", "ship_to_code", "address_name", "short_name", "addr1", "addr2", "addr3", "addr4", "addr5", "addr6", "addr_sort1", "addr_sort2", "addr_sort3", "address_type", "status_type", "attention_name", "attention_phone", "contact_name", "contact_phone", "tlx_twx", "phone_1", "phone_2", "tax_code", "terms_code", "fob_code", "freight_code", "posting_code", "location_code", "alt_location_code", "dest_zone_code", "territory_code", "salesperson_code", "fin_chg_code", "price_code", "payment_code", "vendor_code", "affiliated_cust_code", "print_stmt_flag", "stmt_cycle_code", "inv_comment_code", "stmt_comment_code", "dunn_message_code", "note", "trade_disc_percent", "invoice_copies", "iv_substitution", "ship_to_history", "check_credit_limit", "credit_limit", "check_aging_limit", "aging_limit_bracket", "bal_fwd_flag", "ship_complete_flag", "resale_num", "db_num", "db_date", "db_credit_rating", "late_chg_type", "valid_payer_flag", "valid_soldto_flag", "valid_shipto_flag", "payer_soldto_rel_code", "across_na_flag", "date_opened", "added_by_user_name", "added_by_date", "modified_by_user_name", "modified_by_date", "rate_type_home", "rate_type_oper", "limit_by_home", "nat_cur_code", "one_cur_cust", "city", "state", "postal_code", "country", "remit_code", "forwarder_code", "freight_to_code", "route_code", "route_no", "url", "special_instr", "guid", "price_level", "ship_via_code", "po_num_reqd_flag", "claim_num_reqd_flag"
 )

values ( 
@c1, @c2, @c3, @c4, @c5, @c6, @c7, @c8, @c9, @c10, @c11, @c12, @c13, @c14, @c15, @c16, @c17, @c18, @c19, @c20, @c21, @c22, @c23, @c24, @c25, @c26, @c27, @c28, @c29, @c30, @c31, @c32, @c33, @c34, @c35, @c36, @c37, @c38, @c39, @c40, @c41, @c42, @c43, @c44, @c45, @c46, @c47, @c48, @c49, @c50, @c51, @c52, @c53, @c54, @c55, @c56, @c57, @c58, @c59, @c60, @c61, @c62, @c63, @c64, @c65, @c66, @c67, @c68, @c69, @c70, @c71, @c72, @c73, @c74, @c75, @c76, @c77, @c78, @c79, @c80, @c81, @c82, @c83, @c84, @c85, @c86, @c87, @c88, @c89, @c90
 )


END
GO
