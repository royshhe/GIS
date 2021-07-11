USE [GISData]
GO
/****** Object:  Table [dbo].[Business_Transaction]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Business_Transaction](
	[Business_Transaction_ID] [int] IDENTITY(1,1) NOT NULL,
	[RBR_Date] [datetime] NOT NULL,
	[Transaction_Date] [datetime] NOT NULL,
	[Transaction_Description] [varchar](20) NOT NULL,
	[Contract_Number] [int] NULL,
	[Confirmation_Number] [int] NULL,
	[Transaction_Type] [varchar](3) NOT NULL,
	[Location_ID] [smallint] NOT NULL,
	[User_ID] [varchar](20) NOT NULL,
	[Sales_Contract_Number] [int] NULL,
	[Entered_On_Handheld] [bit] NOT NULL,
	[Signature_Required] [bit] NOT NULL,
	[IBX_Send] [bit] NOT NULL,
 CONSTRAINT [PK_Business_Transaction] PRIMARY KEY CLUSTERED 
(
	[Business_Transaction_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [ix_bt_rbr_date]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [ix_bt_rbr_date] ON [dbo].[Business_Transaction]
(
	[RBR_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Business_Transaction] ADD  CONSTRAINT [DF_Business_Transaction_IBX_Send]  DEFAULT (1) FOR [IBX_Send]
GO
ALTER TABLE [dbo].[Business_Transaction]  WITH NOCHECK ADD  CONSTRAINT [FK_Business_Tr_Contract] FOREIGN KEY([Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
GO
ALTER TABLE [dbo].[Business_Transaction] CHECK CONSTRAINT [FK_Business_Tr_Contract]
GO
ALTER TABLE [dbo].[Business_Transaction]  WITH NOCHECK ADD  CONSTRAINT [FK_Business_Tr_Reservation] FOREIGN KEY([Confirmation_Number])
REFERENCES [dbo].[Reservation] ([Confirmation_Number])
GO
ALTER TABLE [dbo].[Business_Transaction] CHECK CONSTRAINT [FK_Business_Tr_Reservation]
GO
ALTER TABLE [dbo].[Business_Transaction]  WITH NOCHECK ADD  CONSTRAINT [FK_Location32] FOREIGN KEY([Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Business_Transaction] CHECK CONSTRAINT [FK_Location32]
GO
ALTER TABLE [dbo].[Business_Transaction]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Accessory_Sale_Contract3] FOREIGN KEY([Sales_Contract_Number])
REFERENCES [dbo].[Sales_Accessory_Sale_Contract] ([Sales_Contract_Number])
GO
ALTER TABLE [dbo].[Business_Transaction] CHECK CONSTRAINT [FK_Sales_Accessory_Sale_Contract3]
GO
ALTER TABLE [dbo].[Business_Transaction]  WITH NOCHECK ADD  CONSTRAINT [CK_Business_Transaction1] CHECK  ((((not([Contract_Number] is null))) and [Confirmation_Number] is null and [Sales_Contract_Number] is null or [Contract_Number] is null and ((not([Confirmation_Number] is null))) and [Sales_Contract_Number] is null or [Contract_Number] is null and [Confirmation_Number] is null and ((not([Sales_Contract_Number] is null)))))
GO
ALTER TABLE [dbo].[Business_Transaction] CHECK CONSTRAINT [CK_Business_Transaction1]
GO
