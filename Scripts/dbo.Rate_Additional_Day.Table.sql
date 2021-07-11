USE [GISData]
GO
/****** Object:  Table [dbo].[Rate_Additional_Day]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rate_Additional_Day](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Location_ID] [int] NULL,
	[Vehicle_Class_Code] [char](1) NULL,
	[Rate_Name] [varchar](25) NULL,
	[Amount_Adjusted] [decimal](9, 2) NULL,
	[Rate_Type] [varchar](25) NULL,
	[Valid_From] [datetime] NULL,
	[Valid_To] [datetime] NULL,
 CONSTRAINT [PK_Rate_Additional_Day] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Rate_Additional_Day]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Rate_Additional_Day] ON [dbo].[Rate_Additional_Day]
(
	[Vehicle_Class_Code] ASC,
	[Rate_Name] ASC,
	[Valid_From] ASC,
	[Location_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
