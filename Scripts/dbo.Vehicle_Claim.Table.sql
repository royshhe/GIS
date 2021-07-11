USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Claim]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Claim](
	[Claim_Number] [int] NOT NULL,
	[Unit_Number] [int] NOT NULL,
	[Insurance_Company] [varchar](25) NULL,
	[Claim_Filed_On] [datetime] NULL,
	[Contract_Number] [int] NULL,
	[Contact_Name] [varchar](20) NULL,
	[Contact_Phone_Number] [varchar](31) NULL,
	[Remarks] [varchar](255) NULL,
	[Checked_Out] [datetime] NULL,
	[Movement_Out] [datetime] NULL,
 CONSTRAINT [PK_Vehicle_Claim] PRIMARY KEY CLUSTERED 
(
	[Claim_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle_Claim]  WITH CHECK ADD  CONSTRAINT [FK_Vehicle_Movement2] FOREIGN KEY([Unit_Number], [Movement_Out])
REFERENCES [dbo].[Vehicle_Movement] ([Unit_Number], [Movement_Out])
GO
ALTER TABLE [dbo].[Vehicle_Claim] CHECK CONSTRAINT [FK_Vehicle_Movement2]
GO
ALTER TABLE [dbo].[Vehicle_Claim]  WITH CHECK ADD  CONSTRAINT [FK_Vehicle_On_Contract3] FOREIGN KEY([Contract_Number], [Unit_Number], [Checked_Out])
REFERENCES [dbo].[Vehicle_On_Contract] ([Contract_Number], [Unit_Number], [Checked_Out])
GO
ALTER TABLE [dbo].[Vehicle_Claim] CHECK CONSTRAINT [FK_Vehicle_On_Contract3]
GO
ALTER TABLE [dbo].[Vehicle_Claim]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle5] FOREIGN KEY([Unit_Number])
REFERENCES [dbo].[Vehicle] ([Unit_Number])
GO
ALTER TABLE [dbo].[Vehicle_Claim] CHECK CONSTRAINT [FK_Vehicle5]
GO
