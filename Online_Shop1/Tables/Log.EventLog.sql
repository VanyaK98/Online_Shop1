CREATE TABLE [Log].[EventLog] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [User]           VARCHAR (50)  NULL,
    [ProcName]       VARCHAR (MAX) NULL,
    [OperationRunId] INT           NULL,
    [EventDetails]   VARCHAR (250) NULL,
    CONSTRAINT [PK_Log_EventLog] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_L_EventLog_OperationsRuns] FOREIGN KEY ([OperationRunId]) REFERENCES [Log].[OperationRuns] ([Id])
);

