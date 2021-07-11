USE [GISData]
GO
/****** Object:  Table [dbo].[AR_Export]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AR_Export](
	[AR_Export_ID] [int] IDENTITY(1,1) NOT NULL,
	[RBR_Date] [datetime] NOT NULL,
	[Customer_Account] [varchar](12) NOT NULL,
	[Amount] [decimal](9, 2) NOT NULL,
	[Contract_Number] [int] NULL,
	[Purchase_Order_Number] [varchar](20) NULL,
	[Loss_Of_Use_Claim_Number] [varchar](15) NULL,
	[Adjuster_First_Name] [varchar](20) NULL,
	[Adjuster_Last_Name] [varchar](20) NULL,
	[Credit_Card_Key] [int] NULL,
	[Location_ID] [smallint] NULL,
	[Authorization_Number] [varchar](50) NULL,
	[Confirmation_Number] [int] NULL,
	[Transaction_Date] [datetime] NULL,
	[Transaction_Type] [char](1) NULL,
	[Count_Charges] [smallint] NULL,
	[Count_Credits] [smallint] NULL,
	[Summary_Level] [char](1) NOT NULL,
	[Ticket_Number] [varchar](20) NULL,
	[Issuing_Jurisdiction] [varchar](20) NULL,
	[Budget_Claim_Number] [varchar](20) NULL,
	[Doc_Ctrl_Num_Base] [varchar](12) NOT NULL,
	[Doc_Ctrl_Num_Type] [char](1) NULL,
	[Doc_Ctrl_Num_Seq] [int] NULL,
	[Apply_To_Doc_Ctrl_Num] [varchar](16) NULL,
	[Sales_Contract_Number] [int] NULL,
	[ITB_BU_ID] [int] NULL,
 CONSTRAINT [PK_Invoice] PRIMARY KEY CLUSTERED 
(
	[AR_Export_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AR_Export]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract17] FOREIGN KEY([Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
GO
ALTER TABLE [dbo].[AR_Export] CHECK CONSTRAINT [FK_Contract17]
GO
ALTER TABLE [dbo].[AR_Export]  WITH NOCHECK ADD  CONSTRAINT [FK_Credit_Card7] FOREIGN KEY([Credit_Card_Key])
REFERENCES [dbo].[Credit_Card] ([Credit_Card_Key])
GO
ALTER TABLE [dbo].[AR_Export] CHECK CONSTRAINT [FK_Credit_Card7]
GO
ALTER TABLE [dbo].[AR_Export]  WITH NOCHECK ADD  CONSTRAINT [FK_RBR_Date7] FOREIGN KEY([RBR_Date])
REFERENCES [dbo].[RBR_Date] ([RBR_Date])
GO
ALTER TABLE [dbo].[AR_Export] CHECK CONSTRAINT [FK_RBR_Date7]
GO
ALTER TABLE [dbo].[AR_Export]  WITH NOCHECK ADD  CONSTRAINT [FK_Reservation7] FOREIGN KEY([Confirmation_Number])
REFERENCES [dbo].[Reservation] ([Confirmation_Number])
GO
ALTER TABLE [dbo].[AR_Export] CHECK CONSTRAINT [FK_Reservation7]
GO
ALTER TABLE [dbo].[AR_Export]  WITH NOCHECK ADD  CONSTRAINT [FK_Sales_Accessory_Sale_Contract4] FOREIGN KEY([Sales_Contract_Number])
REFERENCES [dbo].[Sales_Accessory_Sale_Contract] ([Sales_Contract_Number])
GO
ALTER TABLE [dbo].[AR_Export] CHECK CONSTRAINT [FK_Sales_Accessory_Sale_Contract4]
GO
ALTER TABLE [dbo].[AR_Export]  WITH NOCHECK ADD  CONSTRAINT [CK_AR_Export1] CHECK  (([Summary_Level] = 'C' or [Summary_Level] = 'L' or [Summary_Level] = 'D'))
GO
ALTER TABLE [dbo].[AR_Export] CHECK CONSTRAINT [CK_AR_Export1]
GO
ALTER TABLE [dbo].[AR_Export]  WITH NOCHECK ADD  CONSTRAINT [CK_AR_Export2] CHECK  (([Summary_Level] <> 'D' or ((not([Contract_Number] is null))) or ((not([Confirmation_Number] is null))) or ((not([Sales_Contract_Number] is null)))))
GO
ALTER TABLE [dbo].[AR_Export] CHECK CONSTRAINT [CK_AR_Export2]
GO
