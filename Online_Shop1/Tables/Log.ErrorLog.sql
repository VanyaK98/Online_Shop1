CREATE TABLE [Log].[ErrorLog] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [ErrorNumber]  INT           NULL,
    [ErrorSeverty] INT           NULL,
    [ErrorState]   INT           NULL,
    [ErrorProc]    VARCHAR (50)  NULL,
    [ErrorLine]    INT           NULL,
    [ErrorMessege] VARCHAR (100) NULL,
    [EventLogId]   INT           NULL,
    CONSTRAINT [PK_Log_ErrorLog] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_L_ErrorLog_EventLog] FOREIGN KEY ([EventLogId]) REFERENCES [Log].[EventLog] ([Id])
);

