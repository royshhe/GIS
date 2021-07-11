USE [GISData]
GO
/****** Object:  Table [dbo].[Mechanical_Incident]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Mechanical_Incident](
	[Vehicle_Support_Incident_Seq] [int] NOT NULL,
	[Type] [char](50) NOT NULL,
	[Vehicle_Location] [varchar](128) NOT NULL,
	[Customer_Location] [varchar](128) NOT NULL,
	[Warranty_Repair] [bit] NOT NULL,
	[Vehicle_Drivable] [bit] NOT NULL,
	[Report_Required_At_Check_In] [bit] NOT NULL,
	[Current_Km] [int] NULL,
	[Vehicle_Model_Name] [varchar](25) NULL,
	[Vehicle_Serial_No] [varchar](30) NULL,
	[Vehicle_Exterior_Color] [varchar](15) NULL,
 CONSTRAINT [PK_Mechanical_Incident] PRIMARY KEY CLUSTERED 
(
	[Vehicle_Support_Incident_Seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Mechanical_Incident]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Support_Incident06] FOREIGN KEY([Vehicle_Support_Incident_Seq])
REFERENCES [dbo].[Vehicle_Support_Incident] ([Vehicle_Support_Incident_Seq])
GO
ALTER TABLE [dbo].[Mechanical_Incident] CHECK CONSTRAINT [FK_Vehicle_Support_Incident06]
GO
