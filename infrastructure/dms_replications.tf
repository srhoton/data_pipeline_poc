 resource "aws_dms_replication_subnet_group" "source_db_to_s3" {
  replication_subnet_group_description = "Subnet group for replication from the source mysql db to s3"
  replication_subnet_group_id = "source-db-to-s3"
  subnet_ids = [data.aws_subnet.public_subnet_1.id, data.aws_subnet.public_subnet_2.id]
   
   tags = {
     Name = "source-db-to-s3"
   }
 }


resource "aws_dms_replication_config" "source_db_to_s3" {
    replication_config_identifier = "db-source-test"
    replication_settings          = jsonencode(
        {
            BeforeImageSettings                 = null
            ChangeProcessingDdlHandlingPolicy   = {
                HandleSourceTableAltered   = true
                HandleSourceTableDropped   = true
                HandleSourceTableTruncated = true
            }
            ChangeProcessingTuning              = {
                BatchApplyMemoryLimit         = 500
                BatchApplyPreserveTransaction = true
                BatchApplyTimeoutMax          = 30
                BatchApplyTimeoutMin          = 1
                BatchSplitSize                = 0
                CommitTimeout                 = 1
                MemoryKeepTime                = 60
                MemoryLimitTotal              = 1024
                MinTransactionSize            = 1000
                StatementCacheSize            = 50
            }
            CharacterSetSettings                = null
            ControlTablesSettings               = {
                CommitPositionTableEnabled    = false
                ControlSchema                 = ""
                FullLoadExceptionTableEnabled = false
                HistoryTableEnabled           = false
                HistoryTimeslotInMinutes      = 5
                StatusTableEnabled            = false
                SuspendedTablesTableEnabled   = false
                historyTimeslotInMinutes      = 5
            }
            ErrorBehavior                       = {
                ApplyErrorDeletePolicy                      = "IGNORE_RECORD"
                ApplyErrorEscalationCount                   = 0
                ApplyErrorEscalationPolicy                  = "LOG_ERROR"
                ApplyErrorFailOnTruncationDdl               = false
                ApplyErrorInsertPolicy                      = "LOG_ERROR"
                ApplyErrorUpdatePolicy                      = "LOG_ERROR"
                DataErrorEscalationCount                    = 0
                DataErrorEscalationPolicy                   = "SUSPEND_TABLE"
                DataErrorPolicy                             = "LOG_ERROR"
                DataTruncationErrorPolicy                   = "LOG_ERROR"
                EventErrorPolicy                            = "IGNORE"
                FailOnNoTablesCaptured                      = true
                FailOnTransactionConsistencyBreached        = false
                FullLoadIgnoreConflicts                     = true
                RecoverableErrorCount                       = -1
                RecoverableErrorInterval                    = 5
                RecoverableErrorStopRetryAfterThrottlingMax = true
                RecoverableErrorThrottling                  = true
                RecoverableErrorThrottlingMax               = 1800
                TableErrorEscalationCount                   = 0
                TableErrorEscalationPolicy                  = "STOP_TASK"
                TableErrorPolicy                            = "SUSPEND_TABLE"
            }
            FailTaskWhenCleanTaskResourceFailed = false
            FullLoadSettings                    = {
                CommitRate                      = 10000
                CreatePkAfterFullLoad           = false
                MaxFullLoadSubTasks             = 8
                StopTaskCachedChangesApplied    = false
                StopTaskCachedChangesNotApplied = false
                TargetTablePrepMode             = "DO_NOTHING"
                TransactionConsistencyTimeout   = 600
            }
            Logging                             = {
                CloudWatchLogGroup  = "dms-serverless-replication-S7ZGLW7AOU6TR4XBVMWKKDT4W2NK5Y3UNN6I6EY"
                CloudWatchLogStream = "dms-serverless-serv-res-id-1707510629537-mttz"
                EnableLogContext    = false
                EnableLogging       = true
                LogComponents       = [
                    {
                        Id       = "TRANSFORMATION"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "SOURCE_UNLOAD"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "IO"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "TARGET_LOAD"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "PERFORMANCE"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "SOURCE_CAPTURE"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "SORTER"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "REST_SERVER"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "VALIDATOR_EXT"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "TARGET_APPLY"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "TASK_MANAGER"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "TABLES_MANAGER"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "METADATA_MANAGER"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "FILE_FACTORY"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "COMMON"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "ADDONS"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "DATA_STRUCTURE"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "COMMUNICATION"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                    {
                        Id       = "FILE_TRANSFER"
                        Severity = "LOGGER_SEVERITY_DEFAULT"
                    },
                ]
            }
            LoopbackPreventionSettings          = null
            PostProcessingRules                 = null
            StreamBufferSettings                = {
                CtrlStreamBufferSizeInMB = 5
                StreamBufferCount        = 3
                StreamBufferSizeInMB     = 8
            }
            TTSettings                          = {
                EnableTT            = false
                FailTaskOnTTFailure = false
                TTRecordSettings    = null
                TTS3Settings        = null
            }
            TargetMetadata                      = {
                BatchApplyEnabled            = false
                FullLobMode                  = false
                InlineLobMaxSize             = 0
                LimitedSizeLobMode           = true
                LoadMaxFileSize              = 0
                LobChunkSize                 = 64
                LobMaxSize                   = 32
                ParallelApplyBufferSize      = 0
                ParallelApplyQueuesPerThread = 0
                ParallelApplyThreads         = 0
                ParallelLoadBufferSize       = 0
                ParallelLoadQueuesPerThread  = 0
                ParallelLoadThreads          = 0
                SupportLobs                  = true
                TargetSchema                 = ""
                TaskRecoveryTableEnabled     = false
            }
        }
    )
    replication_type              = "full-load-and-cdc"
    source_endpoint_arn           = "arn:aws:dms:us-east-1:705740530616:endpoint:LZVMAC4U3FNHIPLLPCKW2UQHYGLOEIBPJ3GGQBQ"
    table_mappings                = jsonencode(
        {
            rules = [
                {
                    object-locator = {
                        schema-name = "source_db"
                        table-name  = "%%"
                    }
                    rule-action    = "include"
                    rule-id        = "1"
                    rule-name      = "1"
                    rule-type      = "selection"
                },
            ]
        }
    )
    tags                          = {}
    tags_all                      = {}
    target_endpoint_arn           = "arn:aws:dms:us-east-1:705740530616:endpoint:BZTG2OUTZ3GZD7KWCQFIBD5ZSDR6PBRW7NLKO6A"

    compute_config {
        kms_key_id                  = "arn:aws:kms:us-east-1:705740530616:key/25f3407b-3087-4746-9240-d3ff9efb0981"
        max_capacity_units          = 2
        min_capacity_units          = 1
        multi_az                    = true
        replication_subnet_group_id = "source-db-to-s3"
        vpc_security_group_ids      = [
            "sg-0b49e84a70b886e1f",
        ]
    }
}