USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_Charge_Item_Audit]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_Charge_Item_Audit](
	[Contract_Number] [int] NOT NULL,
	[Charge_Item_Type] [char](1) NOT NULL,
	[Sequence] [smallint] NOT NULL,
	[Rental_Charge_Split_ID] [smallint] NULL,
	[Sales_Accessory_ID] [smallint] NULL,
	[Optional_Extra_ID] [smallint] NULL,
	[Charge_Type] [char](2) NOT NULL,
	[Charge_description] [varchar](50) NOT NULL,
	[Amount] [decimal](9, 2) NULL,
	[GST_Amount] [decimal](9, 2) NOT NULL,
	[PST_Amount] [decimal](9, 2) NULL,
	[PVRT_Amount] [decimal](9, 2) NULL,
	[GST_Included] [bit] NOT NULL,
	[PST_Included] [bit] NOT NULL,
	[PVRT_Included] [bit] NOT NULL,
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
	[GST_Amount_Included] [decimal](9, 2) NULL,
	[PST_Amount_Included] [decimal](9, 2) NULL,
	[PVRT_Amount_Included] [decimal](9, 2) NULL,
	[Business_Transaction_ID] [int] NULL,
 CONSTRAINT [PK_Contract_Charge_Item_Audit] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Charge_Item_Type] ASC,
	[Sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Audit] ADD  CONSTRAINT [DF_Contract_Charge_Item_Audit_GST_Included]  DEFAULT (0) FOR [GST_Included]
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Audit] ADD  CONSTRAINT [DF_Contract_Charge_Item_Audit_PST_Included]  DEFAULT (0) FOR [PST_Included]
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Audit] ADD  CONSTRAINT [DF_Contract_Charge_Item_Audit_PVRT_Included]  DEFAULT (0) FOR [PVRT_Included]
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Audit] ADD  CONSTRAINT [DF_Contract_Charge_Item_Audit_GST_Exempt]  DEFAULT (0) FOR [GST_Exempt]
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Audit] ADD  CONSTRAINT [DF_Contract_Charge_Item_Audit_PST_Exempt]  DEFAULT (0) FOR [PST_Exempt]
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Audit] ADD  CONSTRAINT [DF_Contract_Charge_Item_Audit_PVRT_Exempt]  DEFAULT (0) FOR [PVRT_Exempt]
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Audit]  WITH CHECK ADD  CONSTRAINT [FK_Business_Transaction9] FOREIGN KEY([Business_Transaction_ID])
REFERENCES [dbo].[Business_Transaction] ([Business_Transaction_ID])
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Audit] CHECK CONSTRAINT [FK_Business_Transaction9]
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Audit]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract20] FOREIGN KEY([Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Audit] CHECK CONSTRAINT [FK_Contract20]
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Audit]  WITH CHECK ADD  CONSTRAINT [FK_Optional_Extra10] FOREIGN KEY([Optional_Extra_ID])
REFERENCES [dbo].[Optional_Extra] ([Optional_Extra_ID])
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Audit] CHECK CONSTRAINT [FK_Optional_Extra10]
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Audit]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Accessory7] FOREIGN KEY([Sales_Accessory_ID])
REFERENCES [dbo].[Sales_Accessory] ([Sales_Accessory_ID])
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Audit] CHECK CONSTRAINT [FK_Sales_Accessory7]
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Audit]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Support_Incident10] FOREIGN KEY([Vehicle_Support_Incident_Seq])
REFERENCES [dbo].[Vehicle_Support_Incident] ([Vehicle_Support_Incident_Seq])
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Audit] CHECK CONSTRAINT [FK_Vehicle_Support_Incident10]
GO
