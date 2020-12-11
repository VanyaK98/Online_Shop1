CREATE TABLE [Log].[OperationRuns] (
    [Id]          INT          IDENTITY (1, 1) NOT NULL,
    [OperationId] INT          NULL,
    [StartTime]   DATETIME     NULL,
    [EndTime]     DATETIME     NULL,
    [InsertedRows]  int          NULL,
    [Status]      VARCHAR (25) NULL,
    CONSTRAINT [PK_Log_OperationRun] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_L_OperationRuns_Operations] FOREIGN KEY ([OperationId]) REFERENCES [Log].[Operations] ([Id])
);

