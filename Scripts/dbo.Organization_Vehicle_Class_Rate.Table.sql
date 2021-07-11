USE [GISData]
GO
/****** Object:  Table [dbo].[Organization_Vehicle_Class_Rate]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organization_Vehicle_Class_Rate](
	[Org_VC_Rate_ID] [int] IDENTITY(1,1) NOT NULL,
	[Organization_ID] [int] NOT NULL,
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Trip_Type] [varchar](50) NOT NULL,
	[Rate_ID] [int] NOT NULL,
	[Rate_Level] [char](1) NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Pickup_Date] [datetime] NULL,
	[Drop_Off_Date] [datetime] NULL,
	[Termination_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Organization_Vehicle_Class_Rate] PRIMARY KEY CLUSTERED 
(
	[Org_VC_Rate_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
