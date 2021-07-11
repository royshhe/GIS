USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[sp_MSupd_armaster_base]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSupd_armaster_base] 
 @c1 binary(8),@c2 varchar(12),@c3 varchar(12),@c4 varchar(60),@c5 varchar(10),@c6 varchar(40),@c7 varchar(40),@c8 varchar(40),@c9 varchar(40),@c10 varchar(40),@c11 varchar(40),@c12 varchar(40),@c13 varchar(40),@c14 varchar(40),@c15 smallint,@c16 smallint,@c17 varchar(40),@c18 varchar(30),@c19 varchar(40),@c20 varchar(30),@c21 varchar(30),@c22 varchar(30),@c23 varchar(30),@c24 varchar(8),@c25 varchar(8),@c26 varchar(8),@c27 varchar(8),@c28 varchar(8),@c29 varchar(8),@c30 varchar(8),@c31 varchar(8),@c32 varchar(8),@c33 varchar(8),@c34 varchar(8),@c35 varchar(8),@c36 varchar(8),@c37 varchar(12),@c38 varchar(8),@c39 smallint,@c40 varchar(8),@c41 varchar(8),@c42 varchar(8),@c43 varchar(8),@c44 varchar(255),@c45 float,@c46 smallint,@c47 smallint,@c48 smallint,@c49 smallint,@c50 float,@c51 smallint,@c52 smallint,@c53 smallint,@c54 smallint,@c55 varchar(30),@c56 varchar(20),@c57 int,@c58 varchar(20),@c59 smallint,@c60 smallint,@c61 smallint,@c62 smallint,@c63 char(8),@c64 smallint,@c65 int,@c66 varchar(30),@c67 datetime,@c68 varchar(30),@c69 datetime,@c70 varchar(8),@c71 varchar(8),@c72 smallint,@c73 varchar(8),@c74 smallint,@c75 varchar(40),@c76 varchar(40),@c77 varchar(15),@c78 varchar(40),@c79 varchar(10),@c80 varchar(10),@c81 varchar(10),@c82 varchar(10),@c83 int,@c84 varchar(50),@c85 varchar(255),@c86 varchar(32),@c87 char(1),@c88 varchar(8),@c89 smallint,@c90 smallint,@pkc1 varchar(12),@pkc2 varchar(12),@pkc3 smallint
,@bitmap binary(12)
as
if substring(@bitmap,1,1) & 2 = 2 or substring(@bitmap,1,1) & 4 = 4 or substring(@bitmap,2,1) & 64 = 64
begin
update "armaster_base" set
"timestamp" = case substring(@bitmap,1,1) & 1 when 1 then @c1 else "timestamp" end
,"customer_code" = case substring(@bitmap,1,1) & 2 when 2 then @c2 else "customer_code" end
,"ship_to_code" = case substring(@bitmap,1,1) & 4 when 4 then @c3 else "ship_to_code" end
,"address_name" = case substring(@bitmap,1,1) & 8 when 8 then @c4 else "address_name" end
,"short_name" = case substring(@bitmap,1,1) & 16 when 16 then @c5 else "short_name" end
,"addr1" = case substring(@bitmap,1,1) & 32 when 32 then @c6 else "addr1" end
,"addr2" = case substring(@bitmap,1,1) & 64 when 64 then @c7 else "addr2" end
,"addr3" = case substring(@bitmap,1,1) & 128 when 128 then @c8 else "addr3" end
,"addr4" = case substring(@bitmap,2,1) & 1 when 1 then @c9 else "addr4" end
,"addr5" = case substring(@bitmap,2,1) & 2 when 2 then @c10 else "addr5" end
,"addr6" = case substring(@bitmap,2,1) & 4 when 4 then @c11 else "addr6" end
,"addr_sort1" = case substring(@bitmap,2,1) & 8 when 8 then @c12 else "addr_sort1" end
,"addr_sort2" = case substring(@bitmap,2,1) & 16 when 16 then @c13 else "addr_sort2" end
,"addr_sort3" = case substring(@bitmap,2,1) & 32 when 32 then @c14 else "addr_sort3" end
,"address_type" = case substring(@bitmap,2,1) & 64 when 64 then @c15 else "address_type" end
,"status_type" = case substring(@bitmap,2,1) & 128 when 128 then @c16 else "status_type" end
,"attention_name" = case substring(@bitmap,3,1) & 1 when 1 then @c17 else "attention_name" end
,"attention_phone" = case substring(@bitmap,3,1) & 2 when 2 then @c18 else "attention_phone" end
,"contact_name" = case substring(@bitmap,3,1) & 4 when 4 then @c19 else "contact_name" end
,"contact_phone" = case substring(@bitmap,3,1) & 8 when 8 then @c20 else "contact_phone" end
,"tlx_twx" = case substring(@bitmap,3,1) & 16 when 16 then @c21 else "tlx_twx" end
,"phone_1" = case substring(@bitmap,3,1) & 32 when 32 then @c22 else "phone_1" end
,"phone_2" = case substring(@bitmap,3,1) & 64 when 64 then @c23 else "phone_2" end
,"tax_code" = case substring(@bitmap,3,1) & 128 when 128 then @c24 else "tax_code" end
,"terms_code" = case substring(@bitmap,4,1) & 1 when 1 then @c25 else "terms_code" end
,"fob_code" = case substring(@bitmap,4,1) & 2 when 2 then @c26 else "fob_code" end
,"freight_code" = case substring(@bitmap,4,1) & 4 when 4 then @c27 else "freight_code" end
,"posting_code" = case substring(@bitmap,4,1) & 8 when 8 then @c28 else "posting_code" end
,"location_code" = case substring(@bitmap,4,1) & 16 when 16 then @c29 else "location_code" end
,"alt_location_code" = case substring(@bitmap,4,1) & 32 when 32 then @c30 else "alt_location_code" end
,"dest_zone_code" = case substring(@bitmap,4,1) & 64 when 64 then @c31 else "dest_zone_code" end
,"territory_code" = case substring(@bitmap,4,1) & 128 when 128 then @c32 else "territory_code" end
,"salesperson_code" = case substring(@bitmap,5,1) & 1 when 1 then @c33 else "salesperson_code" end
,"fin_chg_code" = case substring(@bitmap,5,1) & 2 when 2 then @c34 else "fin_chg_code" end
,"price_code" = case substring(@bitmap,5,1) & 4 when 4 then @c35 else "price_code" end
,"payment_code" = case substring(@bitmap,5,1) & 8 when 8 then @c36 else "payment_code" end
,"vendor_code" = case substring(@bitmap,5,1) & 16 when 16 then @c37 else "vendor_code" end
,"affiliated_cust_code" = case substring(@bitmap,5,1) & 32 when 32 then @c38 else "affiliated_cust_code" end
,"print_stmt_flag" = case substring(@bitmap,5,1) & 64 when 64 then @c39 else "print_stmt_flag" end
,"stmt_cycle_code" = case substring(@bitmap,5,1) & 128 when 128 then @c40 else "stmt_cycle_code" end
,"inv_comment_code" = case substring(@bitmap,6,1) & 1 when 1 then @c41 else "inv_comment_code" end
,"stmt_comment_code" = case substring(@bitmap,6,1) & 2 when 2 then @c42 else "stmt_comment_code" end
,"dunn_message_code" = case substring(@bitmap,6,1) & 4 when 4 then @c43 else "dunn_message_code" end
,"note" = case substring(@bitmap,6,1) & 8 when 8 then @c44 else "note" end
,"trade_disc_percent" = case substring(@bitmap,6,1) & 16 when 16 then @c45 else "trade_disc_percent" end
,"invoice_copies" = case substring(@bitmap,6,1) & 32 when 32 then @c46 else "invoice_copies" end
,"iv_substitution" = case substring(@bitmap,6,1) & 64 when 64 then @c47 else "iv_substitution" end
,"ship_to_history" = case substring(@bitmap,6,1) & 128 when 128 then @c48 else "ship_to_history" end
,"check_credit_limit" = case substring(@bitmap,7,1) & 1 when 1 then @c49 else "check_credit_limit" end
,"credit_limit" = case substring(@bitmap,7,1) & 2 when 2 then @c50 else "credit_limit" end
,"check_aging_limit" = case substring(@bitmap,7,1) & 4 when 4 then @c51 else "check_aging_limit" end
,"aging_limit_bracket" = case substring(@bitmap,7,1) & 8 when 8 then @c52 else "aging_limit_bracket" end
,"bal_fwd_flag" = case substring(@bitmap,7,1) & 16 when 16 then @c53 else "bal_fwd_flag" end
,"ship_complete_flag" = case substring(@bitmap,7,1) & 32 when 32 then @c54 else "ship_complete_flag" end
,"resale_num" = case substring(@bitmap,7,1) & 64 when 64 then @c55 else "resale_num" end
,"db_num" = case substring(@bitmap,7,1) & 128 when 128 then @c56 else "db_num" end
,"db_date" = case substring(@bitmap,8,1) & 1 when 1 then @c57 else "db_date" end
,"db_credit_rating" = case substring(@bitmap,8,1) & 2 when 2 then @c58 else "db_credit_rating" end
,"late_chg_type" = case substring(@bitmap,8,1) & 4 when 4 then @c59 else "late_chg_type" end
,"valid_payer_flag" = case substring(@bitmap,8,1) & 8 when 8 then @c60 else "valid_payer_flag" end
,"valid_soldto_flag" = case substring(@bitmap,8,1) & 16 when 16 then @c61 else "valid_soldto_flag" end
,"valid_shipto_flag" = case substring(@bitmap,8,1) & 32 when 32 then @c62 else "valid_shipto_flag" end
,"payer_soldto_rel_code" = case substring(@bitmap,8,1) & 64 when 64 then @c63 else "payer_soldto_rel_code" end
,"across_na_flag" = case substring(@bitmap,8,1) & 128 when 128 then @c64 else "across_na_flag" end
,"date_opened" = case substring(@bitmap,9,1) & 1 when 1 then @c65 else "date_opened" end
,"added_by_user_name" = case substring(@bitmap,9,1) & 2 when 2 then @c66 else "added_by_user_name" end
,"added_by_date" = case substring(@bitmap,9,1) & 4 when 4 then @c67 else "added_by_date" end
,"modified_by_user_name" = case substring(@bitmap,9,1) & 8 when 8 then @c68 else "modified_by_user_name" end
,"modified_by_date" = case substring(@bitmap,9,1) & 16 when 16 then @c69 else "modified_by_date" end
,"rate_type_home" = case substring(@bitmap,9,1) & 32 when 32 then @c70 else "rate_type_home" end
,"rate_type_oper" = case substring(@bitmap,9,1) & 64 when 64 then @c71 else "rate_type_oper" end
,"limit_by_home" = case substring(@bitmap,9,1) & 128 when 128 then @c72 else "limit_by_home" end
,"nat_cur_code" = case substring(@bitmap,10,1) & 1 when 1 then @c73 else "nat_cur_code" end
,"one_cur_cust" = case substring(@bitmap,10,1) & 2 when 2 then @c74 else "one_cur_cust" end
,"city" = case substring(@bitmap,10,1) & 4 when 4 then @c75 else "city" end
,"state" = case substring(@bitmap,10,1) & 8 when 8 then @c76 else "state" end
,"postal_code" = case substring(@bitmap,10,1) & 16 when 16 then @c77 else "postal_code" end
,"country" = case substring(@bitmap,10,1) & 32 when 32 then @c78 else "country" end
,"remit_code" = case substring(@bitmap,10,1) & 64 when 64 then @c79 else "remit_code" end
,"forwarder_code" = case substring(@bitmap,10,1) & 128 when 128 then @c80 else "forwarder_code" end
,"freight_to_code" = case substring(@bitmap,11,1) & 1 when 1 then @c81 else "freight_to_code" end
,"route_code" = case substring(@bitmap,11,1) & 2 when 2 then @c82 else "route_code" end
,"route_no" = case substring(@bitmap,11,1) & 4 when 4 then @c83 else "route_no" end
,"url" = case substring(@bitmap,11,1) & 8 when 8 then @c84 else "url" end
,"special_instr" = case substring(@bitmap,11,1) & 16 when 16 then @c85 else "special_instr" end
,"guid" = case substring(@bitmap,11,1) & 32 when 32 then @c86 else "guid" end
,"price_level" = case substring(@bitmap,11,1) & 64 when 64 then @c87 else "price_level" end
,"ship_via_code" = case substring(@bitmap,11,1) & 128 when 128 then @c88 else "ship_via_code" end
,"po_num_reqd_flag" = case substring(@bitmap,12,1) & 1 when 1 then @c89 else "po_num_reqd_flag" end
,"claim_num_reqd_flag" = case substring(@bitmap,12,1) & 2 when 2 then @c90 else "claim_num_reqd_flag" end
where "customer_code" = @pkc1 and "ship_to_code" = @pkc2 and "address_type" = @pkc3
if @@rowcount = 0
	if @@microsoftversion>0x07320000
		exec sp_MSreplraiserror 20598
end
else
begin
update "armaster_base" set
"timestamp" = case substring(@bitmap,1,1) & 1 when 1 then @c1 else "timestamp" end
,"address_name" = case substring(@bitmap,1,1) & 8 when 8 then @c4 else "address_name" end
,"short_name" = case substring(@bitmap,1,1) & 16 when 16 then @c5 else "short_name" end
,"addr1" = case substring(@bitmap,1,1) & 32 when 32 then @c6 else "addr1" end
,"addr2" = case substring(@bitmap,1,1) & 64 when 64 then @c7 else "addr2" end
,"addr3" = case substring(@bitmap,1,1) & 128 when 128 then @c8 else "addr3" end
,"addr4" = case substring(@bitmap,2,1) & 1 when 1 then @c9 else "addr4" end
,"addr5" = case substring(@bitmap,2,1) & 2 when 2 then @c10 else "addr5" end
,"addr6" = case substring(@bitmap,2,1) & 4 when 4 then @c11 else "addr6" end
,"addr_sort1" = case substring(@bitmap,2,1) & 8 when 8 then @c12 else "addr_sort1" end
,"addr_sort2" = case substring(@bitmap,2,1) & 16 when 16 then @c13 else "addr_sort2" end
,"addr_sort3" = case substring(@bitmap,2,1) & 32 when 32 then @c14 else "addr_sort3" end
,"status_type" = case substring(@bitmap,2,1) & 128 when 128 then @c16 else "status_type" end
,"attention_name" = case substring(@bitmap,3,1) & 1 when 1 then @c17 else "attention_name" end
,"attention_phone" = case substring(@bitmap,3,1) & 2 when 2 then @c18 else "attention_phone" end
,"contact_name" = case substring(@bitmap,3,1) & 4 when 4 then @c19 else "contact_name" end
,"contact_phone" = case substring(@bitmap,3,1) & 8 when 8 then @c20 else "contact_phone" end
,"tlx_twx" = case substring(@bitmap,3,1) & 16 when 16 then @c21 else "tlx_twx" end
,"phone_1" = case substring(@bitmap,3,1) & 32 when 32 then @c22 else "phone_1" end
,"phone_2" = case substring(@bitmap,3,1) & 64 when 64 then @c23 else "phone_2" end
,"tax_code" = case substring(@bitmap,3,1) & 128 when 128 then @c24 else "tax_code" end
,"terms_code" = case substring(@bitmap,4,1) & 1 when 1 then @c25 else "terms_code" end
,"fob_code" = case substring(@bitmap,4,1) & 2 when 2 then @c26 else "fob_code" end
,"freight_code" = case substring(@bitmap,4,1) & 4 when 4 then @c27 else "freight_code" end
,"posting_code" = case substring(@bitmap,4,1) & 8 when 8 then @c28 else "posting_code" end
,"location_code" = case substring(@bitmap,4,1) & 16 when 16 then @c29 else "location_code" end
,"alt_location_code" = case substring(@bitmap,4,1) & 32 when 32 then @c30 else "alt_location_code" end
,"dest_zone_code" = case substring(@bitmap,4,1) & 64 when 64 then @c31 else "dest_zone_code" end
,"territory_code" = case substring(@bitmap,4,1) & 128 when 128 then @c32 else "territory_code" end
,"salesperson_code" = case substring(@bitmap,5,1) & 1 when 1 then @c33 else "salesperson_code" end
,"fin_chg_code" = case substring(@bitmap,5,1) & 2 when 2 then @c34 else "fin_chg_code" end
,"price_code" = case substring(@bitmap,5,1) & 4 when 4 then @c35 else "price_code" end
,"payment_code" = case substring(@bitmap,5,1) & 8 when 8 then @c36 else "payment_code" end
,"vendor_code" = case substring(@bitmap,5,1) & 16 when 16 then @c37 else "vendor_code" end
,"affiliated_cust_code" = case substring(@bitmap,5,1) & 32 when 32 then @c38 else "affiliated_cust_code" end
,"print_stmt_flag" = case substring(@bitmap,5,1) & 64 when 64 then @c39 else "print_stmt_flag" end
,"stmt_cycle_code" = case substring(@bitmap,5,1) & 128 when 128 then @c40 else "stmt_cycle_code" end
,"inv_comment_code" = case substring(@bitmap,6,1) & 1 when 1 then @c41 else "inv_comment_code" end
,"stmt_comment_code" = case substring(@bitmap,6,1) & 2 when 2 then @c42 else "stmt_comment_code" end
,"dunn_message_code" = case substring(@bitmap,6,1) & 4 when 4 then @c43 else "dunn_message_code" end
,"note" = case substring(@bitmap,6,1) & 8 when 8 then @c44 else "note" end
,"trade_disc_percent" = case substring(@bitmap,6,1) & 16 when 16 then @c45 else "trade_disc_percent" end
,"invoice_copies" = case substring(@bitmap,6,1) & 32 when 32 then @c46 else "invoice_copies" end
,"iv_substitution" = case substring(@bitmap,6,1) & 64 when 64 then @c47 else "iv_substitution" end
,"ship_to_history" = case substring(@bitmap,6,1) & 128 when 128 then @c48 else "ship_to_history" end
,"check_credit_limit" = case substring(@bitmap,7,1) & 1 when 1 then @c49 else "check_credit_limit" end
,"credit_limit" = case substring(@bitmap,7,1) & 2 when 2 then @c50 else "credit_limit" end
,"check_aging_limit" = case substring(@bitmap,7,1) & 4 when 4 then @c51 else "check_aging_limit" end
,"aging_limit_bracket" = case substring(@bitmap,7,1) & 8 when 8 then @c52 else "aging_limit_bracket" end
,"bal_fwd_flag" = case substring(@bitmap,7,1) & 16 when 16 then @c53 else "bal_fwd_flag" end
,"ship_complete_flag" = case substring(@bitmap,7,1) & 32 when 32 then @c54 else "ship_complete_flag" end
,"resale_num" = case substring(@bitmap,7,1) & 64 when 64 then @c55 else "resale_num" end
,"db_num" = case substring(@bitmap,7,1) & 128 when 128 then @c56 else "db_num" end
,"db_date" = case substring(@bitmap,8,1) & 1 when 1 then @c57 else "db_date" end
,"db_credit_rating" = case substring(@bitmap,8,1) & 2 when 2 then @c58 else "db_credit_rating" end
,"late_chg_type" = case substring(@bitmap,8,1) & 4 when 4 then @c59 else "late_chg_type" end
,"valid_payer_flag" = case substring(@bitmap,8,1) & 8 when 8 then @c60 else "valid_payer_flag" end
,"valid_soldto_flag" = case substring(@bitmap,8,1) & 16 when 16 then @c61 else "valid_soldto_flag" end
,"valid_shipto_flag" = case substring(@bitmap,8,1) & 32 when 32 then @c62 else "valid_shipto_flag" end
,"payer_soldto_rel_code" = case substring(@bitmap,8,1) & 64 when 64 then @c63 else "payer_soldto_rel_code" end
,"across_na_flag" = case substring(@bitmap,8,1) & 128 when 128 then @c64 else "across_na_flag" end
,"date_opened" = case substring(@bitmap,9,1) & 1 when 1 then @c65 else "date_opened" end
,"added_by_user_name" = case substring(@bitmap,9,1) & 2 when 2 then @c66 else "added_by_user_name" end
,"added_by_date" = case substring(@bitmap,9,1) & 4 when 4 then @c67 else "added_by_date" end
,"modified_by_user_name" = case substring(@bitmap,9,1) & 8 when 8 then @c68 else "modified_by_user_name" end
,"modified_by_date" = case substring(@bitmap,9,1) & 16 when 16 then @c69 else "modified_by_date" end
,"rate_type_home" = case substring(@bitmap,9,1) & 32 when 32 then @c70 else "rate_type_home" end
,"rate_type_oper" = case substring(@bitmap,9,1) & 64 when 64 then @c71 else "rate_type_oper" end
,"limit_by_home" = case substring(@bitmap,9,1) & 128 when 128 then @c72 else "limit_by_home" end
,"nat_cur_code" = case substring(@bitmap,10,1) & 1 when 1 then @c73 else "nat_cur_code" end
,"one_cur_cust" = case substring(@bitmap,10,1) & 2 when 2 then @c74 else "one_cur_cust" end
,"city" = case substring(@bitmap,10,1) & 4 when 4 then @c75 else "city" end
,"state" = case substring(@bitmap,10,1) & 8 when 8 then @c76 else "state" end
,"postal_code" = case substring(@bitmap,10,1) & 16 when 16 then @c77 else "postal_code" end
,"country" = case substring(@bitmap,10,1) & 32 when 32 then @c78 else "country" end
,"remit_code" = case substring(@bitmap,10,1) & 64 when 64 then @c79 else "remit_code" end
,"forwarder_code" = case substring(@bitmap,10,1) & 128 when 128 then @c80 else "forwarder_code" end
,"freight_to_code" = case substring(@bitmap,11,1) & 1 when 1 then @c81 else "freight_to_code" end
,"route_code" = case substring(@bitmap,11,1) & 2 when 2 then @c82 else "route_code" end
,"route_no" = case substring(@bitmap,11,1) & 4 when 4 then @c83 else "route_no" end
,"url" = case substring(@bitmap,11,1) & 8 when 8 then @c84 else "url" end
,"special_instr" = case substring(@bitmap,11,1) & 16 when 16 then @c85 else "special_instr" end
,"guid" = case substring(@bitmap,11,1) & 32 when 32 then @c86 else "guid" end
,"price_level" = case substring(@bitmap,11,1) & 64 when 64 then @c87 else "price_level" end
,"ship_via_code" = case substring(@bitmap,11,1) & 128 when 128 then @c88 else "ship_via_code" end
,"po_num_reqd_flag" = case substring(@bitmap,12,1) & 1 when 1 then @c89 else "po_num_reqd_flag" end
,"claim_num_reqd_flag" = case substring(@bitmap,12,1) & 2 when 2 then @c90 else "claim_num_reqd_flag" end
where "customer_code" = @pkc1 and "ship_to_code" = @pkc2 and "address_type" = @pkc3
if @@rowcount = 0
	if @@microsoftversion>0x07320000
		exec sp_MSreplraiserror 20598
end
GO
