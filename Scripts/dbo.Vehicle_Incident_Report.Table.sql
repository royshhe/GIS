USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Incident_Report]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Incident_Report](
	[Damage_Report_Number] [int] IDENTITY(1,1) NOT NULL,
	[Unit_Number] [int] NOT NULL,
	[Incident_Date] [datetime] NULL,
	[Contract_Number] [int] NOT NULL,
	[Checked_Out_At] [datetime] NOT NULL,
	[Service_Performed_On] [datetime] NOT NULL,
	[Estimated_Damage_Cost] [decimal](9, 2) NULL,
	[Movement_Out] [datetime] NOT NULL,
	[Remarks] [varchar](255) NULL,
 CONSTRAINT [PK_Vehicle_Incident] PRIMARY KEY CLUSTERED 
(
	[Damage_Report_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
