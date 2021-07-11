USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_Charge_Item_Inclusive]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_Charge_Item_Inclusive](
	[Contract_Number] [int] NOT NULL,
	[Charge_Item_Type] [char](1) NOT NULL,
	[Sequence] [smallint] NOT NULL,
	[Item_Number] [smallint] NOT NULL,
	[Sales_Accessory_ID] [smallint] NULL,
	[Optional_Extra_ID] [smallint] NULL,
	[Charge_Type] [char](2) NOT NULL,
	[Unit_Amount] [decimal](9, 3) NOT NULL,
	[Unit_Type] [varchar](20) NOT NULL,
	[Quantity] [decimal](9, 2) NULL,
	[Amount_Included] [decimal](9, 2) NULL,
	[GST_Amount] [decimal](9, 2) NOT NULL,
	[PST_Amount] [decimal](9, 2) NULL,
	[PVRT_Amount] [decimal](9, 2) NULL,
	[GST_Exempt] [bit] NOT NULL,
	[PST_Exempt] [bit] NOT NULL,
	[PVRT_Exempt] [bit] NOT NULL,
 CONSTRAINT [PK_Contract_Charge_Item_Inclusive] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Charge_Item_Type] ASC,
	[Sequence] ASC,
	[Item_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Inclusive] ADD  CONSTRAINT [DF__Contract__GST_Exempt]  DEFAULT (0) FOR [GST_Exempt]
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Inclusive] ADD  CONSTRAINT [DF__Contract___PST_Exempt]  DEFAULT (0) FOR [PST_Exempt]
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Inclusive] ADD  CONSTRAINT [DF__Contract___PVRT_Exempt]  DEFAULT (0) FOR [PVRT_Exempt]
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Inclusive]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract_Charge_Item_Inclusive_Contract_Charge_Item] FOREIGN KEY([Contract_Number], [Charge_Item_Type], [Sequence])
REFERENCES [dbo].[Contract_Charge_Item] ([Contract_Number], [Charge_Item_Type], [Sequence])
GO
ALTER TABLE [dbo].[Contract_Charge_Item_Inclusive] CHECK CONSTRAINT [FK_Contract_Charge_Item_Inclusive_Contract_Charge_Item]
GO
