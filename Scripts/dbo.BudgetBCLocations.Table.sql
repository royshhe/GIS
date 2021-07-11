USE [GISData]
GO
/****** Object:  Table [dbo].[BudgetBCLocations]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BudgetBCLocations](
	[STA] [nvarchar](255) NULL,
	[CTYRO] [nvarchar](255) NULL,
	[MNEM] [nvarchar](255) NULL,
	[RAC] [nvarchar](255) NULL,
	[OC] [nvarchar](255) NULL,
	[CL] [nvarchar](255) NULL,
	[STA TYPE] [nvarchar](255) NULL,
	[ON_OFF] [nvarchar](255) NULL,
	[APO] [nvarchar](255) NULL,
	[NAME] [nvarchar](255) NULL,
	[DESCRIPTOR] [nvarchar](255) NULL,
	[ADDR1] [nvarchar](255) NULL,
	[ADDR2] [nvarchar](255) NULL,
	[CITY] [nvarchar](255) NULL,
	[STATE] [nvarchar](255) NULL,
	[ZIP] [nvarchar](255) NULL,
	[CC] [nvarchar](255) NULL,
	[DIV] [nvarchar](255) NULL,
	[REGION] [nvarchar](255) NULL,
	[FO] [nvarchar](255) NULL,
	[DIST] [nvarchar](255) NULL,
	[MEGA] [nvarchar](255) NULL,
	[OPEN] [nvarchar](255) NULL,
	[CLOSED] [nvarchar](255) NULL,
	[INTL_DISP] [nvarchar](255) NULL,
	[DBR] [nvarchar](255) NULL,
	[VENDOR ] [nvarchar](255) NULL
) ON [PRIMARY]
GO
