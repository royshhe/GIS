USE [GISData]
GO
/****** Object:  Table [dbo].[Eigen_Settlement_CRTransReport]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Eigen_Settlement_CRTransReport](
	[trn_datetime] [datetime] NULL,
	[merchant_name] [varchar](60) NULL,
	[trn_order_number] [varchar](20) NULL,
	[Station_ID] [varchar](20) NULL,
	[trn_id] [varchar](20) NULL,
	[Terminal_Id] [varchar](20) NULL,
	[trn_card_type] [varchar](10) NULL,
	[trn_card_Number] [varchar](20) NULL,
	[trn_card_Expire] [varchar](10) NULL,
	[trn_amount] [decimal](11, 2) NULL,
	[trn_auth_code] [varchar](20) NULL,
	[trn_field1] [varchar](10) NULL,
	[RBR_Date] [datetime] NULL,
	[trn_type] [varchar](2) NULL
) ON [PRIMARY]
GO
