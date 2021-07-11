USE [GISData]
GO
/****** Object:  Table [dbo].[RP_Flt_15_Vehicle_Utilization]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RP_Flt_15_Vehicle_Utilization](
	[Hub_ID] [char](25) NULL,
	[Hub] [varchar](30) NULL,
	[Current_Location_ID] [int] NOT NULL,
	[Current_Location_Name] [varchar](25) NOT NULL,
	[Vehicle_Type_ID] [varchar](18) NOT NULL,
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Vehicle_Class_Name] [varchar](30) NOT NULL,
	[Rentable] [int] NULL,
	[Not_Rentable] [int] NULL,
	[Rented] [int] NULL,
	[RP_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_RP_Flt_15_Vehicle_Utilization] PRIMARY KEY CLUSTERED 
(
	[Current_Location_ID] ASC,
	[Vehicle_Type_ID] ASC,
	[Vehicle_Class_Code] ASC,
	[RP_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
