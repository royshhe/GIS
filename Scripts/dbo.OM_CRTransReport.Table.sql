USE [GISData]
GO
/****** Object:  Table [dbo].[OM_CRTransReport]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OM_CRTransReport](
	[merchant_id] [int] NULL,
	[merchant_name] [varchar](100) NULL,
	[trn_id] [int] NOT NULL,
	[trn_datetime] [datetime] NULL,
	[trn_card_owner] [varchar](50) NULL,
	[trn_ip] [varchar](30) NULL,
	[trn_type] [char](10) NULL,
	[trn_amount] [int] NULL,
	[trn_original_amount] [int] NULL,
	[trn_returns] [int] NULL,
	[trn_order_number] [varchar](30) NULL,
	[trn_batch_number] [int] NULL,
	[trn_auth_code] [varchar](30) NULL,
	[trn_card_type] [char](10) NULL,
	[trn_adjustment_to] [int] NULL,
	[trn_response] [int] NULL,
	[message_id] [int] NULL,
	[b_name] [varchar](50) NULL,
	[b_email] [varchar](50) NULL,
	[b_phone] [varchar](30) NULL,
	[b_address1] [varchar](100) NULL,
	[b_address2] [varchar](100) NULL,
	[b_city] [varchar](50) NULL,
	[b_province] [varchar](50) NULL,
	[b_postal] [varchar](50) NULL,
	[b_country] [varchar](50) NULL,
	[s_name] [varchar](50) NULL,
	[s_email] [varchar](50) NULL,
	[s_phone] [varchar](50) NULL,
	[s_address1] [varchar](50) NULL,
	[s_address2] [varchar](50) NULL,
	[s_city] [varchar](50) NULL,
	[s_province] [varchar](50) NULL,
	[s_postal] [varchar](50) NULL,
	[s_country] [varchar](50) NULL,
	[eci] [int] NULL,
	[avs_response] [char](10) NULL,
	[cvd_response] [char](10) NULL,
 CONSTRAINT [PK_OM_CRTransReport] PRIMARY KEY CLUSTERED 
(
	[trn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
