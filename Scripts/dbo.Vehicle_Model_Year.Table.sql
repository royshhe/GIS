USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Model_Year]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Model_Year](
	[Vehicle_Model_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Model_Name] [varchar](25) NOT NULL,
	[Model_Year] [int] NULL,
	[Km_Per_Litre] [decimal](6, 2) NULL,
	[Fuel_Tank_Size] [decimal](6, 2) NULL,
	[ICBC_Class] [char](1) NULL,
	[Manufacturer_ID] [smallint] NULL,
	[PST_Rate] [decimal](5, 2) NULL,
	[Foreign_Model_Only] [bit] NOT NULL,
	[Diesel] [bit] NOT NULL,
	[Passenger_Vehicle] [bit] NULL,
	[Last_Updated_By] [varchar](20) NOT NULL,
	[Last_Updated_On] [datetime] NOT NULL,
	[AddenDum] [varchar](50) NULL,
	[IBX_Model_Name] [varchar](25) NULL,
	[IBX_Sending_Only] [bit] NULL,
	[Old_Km_Per_Litre] [decimal](6, 2) NULL,
	[PM_Schedule_Id] [int] NULL,
 CONSTRAINT [PK_Vehicle_Model_Year] PRIMARY KEY CLUSTERED 
(
	[Vehicle_Model_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_Vehicle_Model_Year1] UNIQUE NONCLUSTERED 
(
	[Model_Name] ASC,
	[Model_Year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle_Model_Year] ADD  CONSTRAINT [DF_VMY_PST]  DEFAULT (7) FOR [PST_Rate]
GO
ALTER TABLE [dbo].[Vehicle_Model_Year] ADD  CONSTRAINT [DF__Vehicle_M__Forei__1FE5F8E0]  DEFAULT (0) FOR [Foreign_Model_Only]
GO
ALTER TABLE [dbo].[Vehicle_Model_Year] ADD  CONSTRAINT [DF__Vehicle_M__Diese__20DA1D19]  DEFAULT (0) FOR [Diesel]
GO
ALTER TABLE [dbo].[Vehicle_Model_Year] ADD  CONSTRAINT [DF_Vehicle_Model_Year_Passener_Vehicle]  DEFAULT (1) FOR [Passenger_Vehicle]
GO
ALTER TABLE [dbo].[Vehicle_Model_Year]  WITH NOCHECK ADD  CONSTRAINT [CK_Vehicle_Model_Year_Year] CHECK  (([foreign_model_only] = 1 or ((not([model_year] is null)))))
GO
ALTER TABLE [dbo].[Vehicle_Model_Year] CHECK CONSTRAINT [CK_Vehicle_Model_Year_Year]
GO
