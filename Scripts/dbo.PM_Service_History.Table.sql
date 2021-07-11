USE [GISData]
GO
/****** Object:  Table [dbo].[PM_Service_History]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PM_Service_History](
	[Unit_Number] [int] NOT NULL,
	[Service_Code] [char](10) NOT NULL,
	[Service_Date] [datetime] NOT NULL,
	[KM_Reading] [int] NULL,
	[Service_Performed_By] [varchar](20) NULL,
	[Document_Number] [varchar](30) NULL,
	[Remarks] [varchar](50) NULL,
	[Last_Updated_By] [varchar](30) NULL,
	[Last_Updated_On] [datetime] NULL,
 CONSTRAINT [PK_VM_PM_Service_History] PRIMARY KEY CLUSTERED 
(
	[Unit_Number] ASC,
	[Service_Code] ASC,
	[Service_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
