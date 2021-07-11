USE [GISData]
GO
/****** Object:  Table [dbo].[Employee_Attendance]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee_Attendance](
	[Attendance_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_ID] [char](20) NULL,
	[Attendance_Date] [datetime] NULL,
	[Attendance_End_Date] [datetime] NULL,
	[Attendance_Type] [char](2) NULL,
	[Days] [int] NULL,
	[Reason] [varchar](350) NULL,
	[Remarks] [varchar](350) NULL,
 CONSTRAINT [PK_Employee_Attendance] PRIMARY KEY CLUSTERED 
(
	[Attendance_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
