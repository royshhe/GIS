USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Support_Incident]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Support_Incident](
	[Vehicle_Support_Incident_Seq] [int] IDENTITY(1,1) NOT NULL,
	[Unit_Number] [int] NULL,
	[Movement_Out] [datetime] NULL,
	[Contract_Number] [int] NULL,
	[Checked_Out] [datetime] NULL,
	[Licence_Plate] [varchar](10) NOT NULL,
	[Last_Name] [varchar](25) NOT NULL,
	[First_Name] [varchar](25) NOT NULL,
	[Logged_On] [datetime] NOT NULL,
	[Logged_By] [varchar](20) NOT NULL,
	[Incident_Status] [char](1) NULL,
	[Reported_By_Role] [varchar](25) NOT NULL,
	[Reported_By_Name] [varchar](25) NULL,
	[Reported_By_Relationship] [varchar](25) NULL,
	[Incident_Type] [varchar](15) NOT NULL,
	[Do_Not_Switch_Vehicle] [bit] NOT NULL,
	[Do_Not_Switch_Reason] [varchar](255) NULL,
	[Claim_Number] [int] NULL,
	[Foreign_Contract_Number] [varchar](20) NULL,
	[Foreign_Vehicle_Unit_Number] [varchar](20) NULL,
	[Owning_Company_Id] [smallint] NULL,
	[Last_Updated_By] [varchar](20) NOT NULL,
	[Last_Updated_On] [datetime] NOT NULL,
 CONSTRAINT [PK_Vehicle_Support_Incident] PRIMARY KEY CLUSTERED 
(
	[Vehicle_Support_Incident_Seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle_Support_Incident]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Claim1] FOREIGN KEY([Claim_Number])
REFERENCES [dbo].[Vehicle_Claim] ([Claim_Number])
GO
ALTER TABLE [dbo].[Vehicle_Support_Incident] CHECK CONSTRAINT [FK_Vehicle_Claim1]
GO
ALTER TABLE [dbo].[Vehicle_Support_Incident]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Movement1] FOREIGN KEY([Unit_Number], [Movement_Out])
REFERENCES [dbo].[Vehicle_Movement] ([Unit_Number], [Movement_Out])
GO
ALTER TABLE [dbo].[Vehicle_Support_Incident] CHECK CONSTRAINT [FK_Vehicle_Movement1]
GO
ALTER TABLE [dbo].[Vehicle_Support_Incident]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_On_Contract1] FOREIGN KEY([Contract_Number], [Unit_Number], [Checked_Out])
REFERENCES [dbo].[Vehicle_On_Contract] ([Contract_Number], [Unit_Number], [Checked_Out])
GO
ALTER TABLE [dbo].[Vehicle_Support_Incident] CHECK CONSTRAINT [FK_Vehicle_On_Contract1]
GO
