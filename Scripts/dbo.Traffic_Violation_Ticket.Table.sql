USE [GISData]
GO
/****** Object:  Table [dbo].[Traffic_Violation_Ticket]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Traffic_Violation_Ticket](
	[Unit_Number] [int] NOT NULL,
	[Ticket_Number] [varchar](20) NOT NULL,
	[Issuing_Jurisdiction] [varchar](20) NOT NULL,
	[Contract_Number] [int] NULL,
	[Checked_Out] [datetime] NULL,
	[Movement_Out] [datetime] NULL,
 CONSTRAINT [PK_Traffice_Violation_Ticket] PRIMARY KEY CLUSTERED 
(
	[Ticket_Number] ASC,
	[Issuing_Jurisdiction] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Traffic_Violation_Ticket]  WITH CHECK ADD  CONSTRAINT [FK_Vehicle_Movement3] FOREIGN KEY([Unit_Number], [Movement_Out])
REFERENCES [dbo].[Vehicle_Movement] ([Unit_Number], [Movement_Out])
GO
ALTER TABLE [dbo].[Traffic_Violation_Ticket] CHECK CONSTRAINT [FK_Vehicle_Movement3]
GO
ALTER TABLE [dbo].[Traffic_Violation_Ticket]  WITH CHECK ADD  CONSTRAINT [FK_Vehicle_On_Contract2] FOREIGN KEY([Contract_Number], [Unit_Number], [Checked_Out])
REFERENCES [dbo].[Vehicle_On_Contract] ([Contract_Number], [Unit_Number], [Checked_Out])
GO
ALTER TABLE [dbo].[Traffic_Violation_Ticket] CHECK CONSTRAINT [FK_Vehicle_On_Contract2]
GO
