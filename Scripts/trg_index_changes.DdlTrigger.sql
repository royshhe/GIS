USE [GISData]
GO
/****** Object:  DdlTrigger [trg_index_changes]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [trg_index_changes]
ON DATABASE
FOR 
    CREATE_INDEX,
    ALTER_INDEX, 
    DROP_INDEX
AS
BEGIN
    SET NOCOUNT ON;
 
    INSERT INTO index_logs (
        event_data,
        changed_by
    )
    VALUES (
        EVENTDATA(),
        USER
    );
END;
GO
ENABLE TRIGGER [trg_index_changes] ON DATABASE
GO
