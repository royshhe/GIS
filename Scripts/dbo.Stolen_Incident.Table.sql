USE [GISData]
GO
/****** Object:  Table [dbo].[Stolen_Incident]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stolen_Incident](
	[Vehicle_Support_Incident_Seq] [int] NOT NULL,
	[Reported_To_Police] [bit] NOT NULL,
	[Case_Number] [varchar](20) NULL,
	[Detachment] [varchar](20) NULL,
	[Contact_Name] [varchar](31) NULL,
	[Contact_Phone] [varchar](31) NULL,
	[Customer_Location] [varchar](128) NOT NULL,
	[Key_Location] [varchar](128) NOT NULL,
	[Last_Seen_Location] [varchar](128) NOT NULL,
	[Last_Seen_On] [datetime] NOT NULL,
	[Noticed_Missing_At] [datetime] NOT NULL,
	[Customer_Contact_Phone] [varchar](31) NULL,
 CONSTRAINT [PK_Stolen_Incident] PRIMARY KEY CLUSTERED 
(
	[Vehicle_Support_Incident_Seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Stolen_Incident]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Support_Incident08] FOREIGN KEY([Vehicle_Support_Incident_Seq])
REFERENCES [dbo].[Vehicle_Support_Incident] ([Vehicle_Support_Incident_Seq])
GO
ALTER TABLE [dbo].[Stolen_Incident] CHECK CONSTRAINT [FK_Vehicle_Support_Incident08]
GO
