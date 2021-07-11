USE [GISData]
GO
/****** Object:  Table [dbo].[Seizure_Incident]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Seizure_Incident](
	[Vehicle_Support_Incident_Seq] [int] NOT NULL,
	[Seizure_Location] [varchar](128) NOT NULL,
	[Reason] [varchar](255) NOT NULL,
	[Vehicle_Location] [varchar](128) NOT NULL,
	[Reporting_Authority] [varchar](30) NOT NULL,
	[Contact_Name] [varchar](25) NOT NULL,
	[Contact_Position] [varchar](20) NOT NULL,
	[Contact_Phone] [varchar](31) NOT NULL,
	[Seizure_On] [datetime] NOT NULL,
 CONSTRAINT [PK_Seizure_Incident] PRIMARY KEY CLUSTERED 
(
	[Vehicle_Support_Incident_Seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Seizure_Incident]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Support_Incident09] FOREIGN KEY([Vehicle_Support_Incident_Seq])
REFERENCES [dbo].[Vehicle_Support_Incident] ([Vehicle_Support_Incident_Seq])
GO
ALTER TABLE [dbo].[Seizure_Incident] CHECK CONSTRAINT [FK_Vehicle_Support_Incident09]
GO
