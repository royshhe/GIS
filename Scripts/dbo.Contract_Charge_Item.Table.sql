USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_Charge_Item]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_Charge_Item](
	[Contract_Number] [int] NOT NULL,
	[Charge_Item_Type] [char](1) NOT NULL,
	[Sequence] [smallint] NOT NULL,
	[Rental_Charge_Split_ID] [smallint] NULL,
	[Sales_Accessory_ID] [smallint] NULL,
	[Optional_Extra_ID] [smallint] NULL,
	[Charge_Type] [char](3) NOT NULL,
	[Charge_description] [varchar](50) NOT NULL,
	[Amount] [decimal](9, 2) NULL,
	[GST_Amount] [decimal](9, 2) NOT NULL,
	[PST_Amount] [decimal](9, 2) NULL,
	[PVRT_Amount] [decimal](9, 2) NULL,
	[GST_Included] [bit] NOT NULL,
	[PST_Included] [bit] NOT NULL,
	[PVRT_Included] [bit] NOT NULL,
	[CRF_Included] [bit] NULL,
	[VLF_Included] [bit] NULL,
	[ERF_Included] [bit] NULL,
	[GST_Exempt] [bit] NOT NULL,
	[PST_Exempt] [bit] NOT NULL,
	[PVRT_Exempt] [bit] NOT NULL,
	[Contract_Billing_Party_ID] [int] NOT NULL,
	[Unit_Amount] [decimal](9, 3) NOT NULL,
	[Unit_Type] [varchar](20) NOT NULL,
	[Quantity] [decimal](9, 2) NULL,
	[Vehicle_Support_Incident_Seq] [int] NULL,
	[Charged_By] [varchar](20) NULL,
	[Charged_On] [datetime] NULL,
	[PVRT_Days] [decimal](7, 4) NULL,
	[VLF_Days] [decimal](7, 4) NULL,
	[ERF_Days] [decimal](7, 4) NULL,
	[GST_Amount_Included] [decimal](9, 2) NULL,
	[PST_Amount_Included] [decimal](9, 2) NULL,
	[PVRT_Amount_Included] [decimal](9, 2) NULL,
	[CRF_Amount_Included] [decimal](9, 2) NULL,
	[VLF_Amount_Included] [decimal](9, 2) NULL,
	[ERF_Amount_Included] [decimal](9, 2) NULL,
	[Business_Transaction_ID] [int] NULL,
	[Ticket_Number] [varchar](30) NULL,
	[Issuer] [char](2) NULL,
	[Issuing_Date] [datetime] NULL,
	[License_Number] [varchar](10) NULL,
	[Manual_Qty_Copy] [bit] NULL,
	[IBX_Charge_Item_Type] [char](1) NULL,
	[CFC_Included] [bit] NULL,
	[CFC_Days] [decimal](7, 4) NULL,
	[CFC_Amount_Included] [decimal](9, 2) NULL,
 CONSTRAINT [PK_Contract_Charge_Item] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Charge_Item_Type] ASC,
	[Sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contract_Charge_Item] ADD  CONSTRAINT [DF__Contract___GST_I__50941D33]  DEFAULT (0) FOR [GST_Included]
GO
ALTER TABLE [dbo].[Contract_Charge_Item] ADD  CONSTRAINT [DF__Contract___PST_I__5188416C]  DEFAULT (0) FOR [PST_Included]
GO
ALTER TABLE [dbo].[Contract_Charge_Item] ADD  CONSTRAINT [DF__Contract___PVRT___527C65A5]  DEFAULT (0) FOR [PVRT_Included]
GO
ALTER TABLE [dbo].[Contract_Charge_Item] ADD  CONSTRAINT [DF__Contract___GST_E__537089DE]  DEFAULT (0) FOR [GST_Exempt]
GO
ALTER TABLE [dbo].[Contract_Charge_Item] ADD  CONSTRAINT [DF__Contract___PST_E__5464AE17]  DEFAULT (0) FOR [PST_Exempt]
GO
ALTER TABLE [dbo].[Contract_Charge_Item] ADD  CONSTRAINT [DF__Contract___PVRT___5558D250]  DEFAULT (0) FOR [PVRT_Exempt]
GO
ALTER TABLE [dbo].[Contract_Charge_Item] ADD  CONSTRAINT [DF_Contract_Charge_Item_Manual_Qty_Copy]  DEFAULT (0) FOR [Manual_Qty_Copy]
GO
ALTER TABLE [dbo].[Contract_Charge_Item] ADD  CONSTRAINT [DF_Contract_Charge_Item_IBX_Charge_Item_Type]  DEFAULT (0) FOR [IBX_Charge_Item_Type]
GO
ALTER TABLE [dbo].[Contract_Charge_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_Business_Transaction5] FOREIGN KEY([Business_Transaction_ID])
REFERENCES [dbo].[Business_Transaction] ([Business_Transaction_ID])
GO
ALTER TABLE [dbo].[Contract_Charge_Item] CHECK CONSTRAINT [FK_Business_Transaction5]
GO
ALTER TABLE [dbo].[Contract_Charge_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract_Billing_Party6] FOREIGN KEY([Contract_Number], [Contract_Billing_Party_ID])
REFERENCES [dbo].[Contract_Billing_Party] ([Contract_Number], [Contract_Billing_Party_ID])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[Contract_Charge_Item] NOCHECK CONSTRAINT [FK_Contract_Billing_Party6]
GO
ALTER TABLE [dbo].[Contract_Charge_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract03] FOREIGN KEY([Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
GO
ALTER TABLE [dbo].[Contract_Charge_Item] CHECK CONSTRAINT [FK_Contract03]
GO
ALTER TABLE [dbo].[Contract_Charge_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_Optional_Extra05] FOREIGN KEY([Optional_Extra_ID])
REFERENCES [dbo].[Optional_Extra] ([Optional_Extra_ID])
GO
ALTER TABLE [dbo].[Contract_Charge_Item] CHECK CONSTRAINT [FK_Optional_Extra05]
GO
ALTER TABLE [dbo].[Contract_Charge_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_Sales_Accessory4] FOREIGN KEY([Sales_Accessory_ID])
REFERENCES [dbo].[Sales_Accessory] ([Sales_Accessory_ID])
GO
ALTER TABLE [dbo].[Contract_Charge_Item] CHECK CONSTRAINT [FK_Sales_Accessory4]
GO
ALTER TABLE [dbo].[Contract_Charge_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Support_Incident02] FOREIGN KEY([Vehicle_Support_Incident_Seq])
REFERENCES [dbo].[Vehicle_Support_Incident] ([Vehicle_Support_Incident_Seq])
GO
ALTER TABLE [dbo].[Contract_Charge_Item] CHECK CONSTRAINT [FK_Vehicle_Support_Incident02]
GO
