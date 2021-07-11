USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_Reimbur_and_Discount]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_Reimbur_and_Discount](
	[Contract_Number] [int] NOT NULL,
	[Entered_On] [datetime] NOT NULL,
	[Type] [varchar](20) NOT NULL,
	[Reimbursement_Reason] [varchar](255) NULL,
	[Entered_By] [varchar](20) NOT NULL,
	[Flat_Amount] [decimal](9, 2) NULL,
	[Percentage] [decimal](5, 2) NULL,
	[Vehicle_Support_Incident_Seq] [int] NULL,
	[Discount_Reason] [varchar](255) NULL,
	[Business_Transaction_ID] [int] NULL,
 CONSTRAINT [PK_Contract_Reimbur_and_Discnt] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Entered_On] ASC,
	[Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contract_Reimbur_and_Discount]  WITH CHECK ADD  CONSTRAINT [FK_Business_Transaction6] FOREIGN KEY([Business_Transaction_ID])
REFERENCES [dbo].[Business_Transaction] ([Business_Transaction_ID])
GO
ALTER TABLE [dbo].[Contract_Reimbur_and_Discount] CHECK CONSTRAINT [FK_Business_Transaction6]
GO
ALTER TABLE [dbo].[Contract_Reimbur_and_Discount]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract02] FOREIGN KEY([Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
GO
ALTER TABLE [dbo].[Contract_Reimbur_and_Discount] CHECK CONSTRAINT [FK_Contract02]
GO
ALTER TABLE [dbo].[Contract_Reimbur_and_Discount]  WITH NOCHECK ADD  CONSTRAINT [FK_Reimbursement_Reason1] FOREIGN KEY([Reimbursement_Reason])
REFERENCES [dbo].[Reimbursement_Reason] ([Reason])
GO
ALTER TABLE [dbo].[Contract_Reimbur_and_Discount] CHECK CONSTRAINT [FK_Reimbursement_Reason1]
GO
ALTER TABLE [dbo].[Contract_Reimbur_and_Discount]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Support_Incident01] FOREIGN KEY([Vehicle_Support_Incident_Seq])
REFERENCES [dbo].[Vehicle_Support_Incident] ([Vehicle_Support_Incident_Seq])
GO
ALTER TABLE [dbo].[Contract_Reimbur_and_Discount] CHECK CONSTRAINT [FK_Vehicle_Support_Incident01]
GO
