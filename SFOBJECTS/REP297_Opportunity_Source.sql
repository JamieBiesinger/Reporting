--USE [Warehouse]
--GO

--/****** Object:  View [SFOBJECT].[Opportunity_Source]    Script Date: 7/30/2015 10:04:55 AM ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--ALTER VIEW [SFOBJECT].[Opportunity_Source]
--AS
    SELECT
        a.RecordTypeID
       ,a.RequestId AS iTx_ID__c
       ,a.RequestIdentifier AS Request_Identifier__c
       ,a.RequestStatus AS Stage
       ,a.RequestedOn AS Request_Date__c
       ,a.RequiredOn AS Required_Date__c
       ,a.RequestComments AS Description
       ,a.RequestCancelReason AS Cancellation_Reason__c
       ,a.RequesterID AS Requesting_Contact__c
       ,a.RequestingLocationId AS Requesting_Organization__c
       ,a.SurgeonUnknown AS Surgeon_Unknown__c
       ,a.ResearcherUnknown AS Researcher_Unknown__c
       ,a.IntendedOutcome AS Request_Intended_Outcome__c
       ,a.IntendedSubOutcome AS Request_Intended_Sub_Outcome__c
       ,a.TissueTypeRequested AS Request_Tissue_Type__c
       ,a.TissueSubTypeRequested AS Request_Tissue_Subtype__c
       ,a.TissueTypeRequestedOther AS Request_Tissue_Type_Other__c
       ,a.SurgeryType AS Request_Surgery_Type__c
       ,a.SurgerySubType AS Request_Surgery_Subtype__c
       ,a.TissueUse AS Request_Tissue_Use__c
       ,a.PreCutRequested AS PreCut_Request__c
       ,a.PreCutRequestedOn AS PreCut_Request_Date__c
       ,a.PreCutRequestedType AS PreCut_Request_Type__c
       ,a.PreCutParameters AS PreCut_Parameters__c
       ,a.PreCutParametersOther AS PreCut_Parameters_Other__c
       ,a.PreCutParametersDepth AS PreCut_Parameters_Depth__c
       ,a.PreCutParametersDiameter AS PreCut_Parameters_Diameter__c
       ,a.ProcessingFee AS Request_Processing_Fee__c
       ,a.ShippingFee AS Request_Shipping_Fee__c
       ,a.TotalFee AS ExpectedRevenue
       ,a.PoNumber AS itx_ponumber
       ,a.RequestCancelledOn AS Request_Cancelled_on
       ,fe.FE_Amount
       ,fe.AR7CLIENTSID
       ,fe.CLIENTPONUMBER AS FE_PONumber
       ,fe.Balance
       ,CASE WHEN fe.invoicedate IS NULL THEN a.requiredon
             ELSE fe.invoicedate
        END AS CloseDate
       ,a.UpdatedOn
       ,ISNULL(o.Name, '') + ': ' + ISNULL(c.FirstName, '') + ' '
        + ISNULL(c.LastName, ' ') + ' ' + a.RequestIdentifier AS NAME
       ,fe.fe_Invoice
       ,fe.FE_client_name__c
       ,fe.FE_Last_Updated
       ,CASE WHEN o.Name = 'Glycerin Preserved - Sightlife'
             THEN 'Glycerin Preserved'
             WHEN a.RequestComments LIKE '%#backupfordmek%'
                  AND o.Name != 'Glycerin Preserved - Sightlife'
             THEN 'Back Up'
             WHEN a.requestcomments LIKE '%Dummy%request%'
                  AND o.Name != 'Glycerin Preserved - Sightlife'
             THEN 'Dummy Request'
             WHEN a.requesttype = 'CutOnly'
                  AND o.Name != 'Glycerin Preserved - Sightlife'
             THEN 'Cut Only'
             WHEN ( a.RequestComments NOT LIKE '%#backupfordmek%'
                    AND a.requestcomments NOT LIKE '%Dummy%request%'
                    AND o.Name != 'Glycerin Preserved - Sightlife'
                    OR a.requestcomments IS NULL
                  )
                  AND a.requesttype = 'Surgery' THEN 'Surgery'
             WHEN ( a.RequestComments NOT LIKE '%#backupfordmek%'
                    AND a.requestcomments NOT LIKE '%Dummy%request%'
                    AND o.Name != 'Glycerin Preserved - Sightlife'
                    OR a.requestcomments IS NULL
                  )
                  AND a.requesttype = 'Research' THEN 'Research'
        END AS Type
       ,sri.ShipmentId AS Shipment_ID__c
       ,a.Outcome AS TissueOutcome
       ,sri.RequestCancelledOn
       ,CASE WHEN a.TissueReasonForimport = 'Import' THEN 'Import'
             WHEN a.TissueReasonForimport = 'Cut-Only' THEN 'Cut-Only'
             ELSE 'Referral'
        END AS TissueSourceDetail
    FROM
        (
          SELECT
            '012d0000000h8yjAAA' AS RecordTypeID
           ,ri.RequestId
           ,ri.RequestType
           ,ri.RequestIdentifier
           ,ri.ProcessingFee
           ,ri.ShippingFee
           ,ri.PoNumber
           ,ri.TissueIdentifier
           ,ri.TissueFee AS TotalFee
           ,ri.RequestStatus
           ,ri.RequestedOn
           ,ri.RequiredOn
           ,ri.RequestComments
           ,CASE WHEN ri.RequestCancelReason = '1'
                 THEN 'Surgery cancelled due to tissue quality'
                 WHEN ri.RequestCancelReason = '2'
                 THEN 'Accepted tissue elsewhere'
                 WHEN ri.RequestCancelReason = '3' THEN 'Surgery canceled'
                 WHEN ri.RequestCancelReason = '4' THEN 'Duplicate'
                 ELSE ri.RequestCancelReason
            END AS RequestCancelReason
           ,CASE WHEN ri.ResearcherId = '00000000-0000-0000-0000-000000000000'
                      AND ri.SurgeonId = '00000000-0000-0000-0000-000000000000'
                 THEN NULL
                 WHEN ri.ResearcherId = '00000000-0000-0000-0000-000000000000'
                 THEN ri.SurgeonId
                 ELSE ri.ResearcherId
            END AS RequesterID
           ,CASE WHEN ri.ResearchLocationId = '00000000-0000-0000-0000-000000000000'
                      AND ri.SurgeryLocationId = '00000000-0000-0000-0000-000000000000'
                 THEN NULL
                 WHEN ri.ResearchLocationId = '00000000-0000-0000-0000-000000000000'
                 THEN ri.SurgeryLocationId
                 ELSE ri.ResearchLocationId
            END AS RequestingLocationId
           ,ri.SurgeonUnknown
           ,ri.ResearcherUnknown
           ,ri.IntendedOutcome
           ,ri.IntendedSubOutcome
           ,ri.TissueTypeRequested
           ,ri.TissueSubTypeRequested
           ,ri.TissueTypeRequestedOther
           ,ri.SurgeryType
           ,ri.SurgerySubType
           ,ri.TissueUse
           ,ri.PreCutRequested
           ,ri.PreCutRequestedOn
           ,ri.PreCutRequestedType
           ,ri.PreCutParameters
           ,ri.PreCutParametersOther
           ,ri.PreCutParametersDepth
           ,ri.PreCutParametersDiameter
           ,CASE WHEN SIGHTLIFE.EyeDist.Request.UpdatedOn > ri.RequestedOn
                 THEN UpdatedOn
                 ELSE ri.RequestedOn + 5
            END AS UpdatedOn
           ,ri.Outcome
           ,ri.RequestCancelledOn
           ,ri.ReasonForImport AS TissueReasonForImport
          FROM
            SIGHTLIFE.Data.RequestInventory AS ri
            LEFT OUTER JOIN SIGHTLIFE.EyeDist.Request ON ri.RequestId = SIGHTLIFE.EyeDist.Request.Id
        ) AS a
        LEFT OUTER JOIN SIGHTLIFE.dbo.Contact AS c ON a.RequesterID = c.Id
        LEFT OUTER JOIN SIGHTLIFE.dbo.Organization AS o ON o.Id = a.RequestingLocationId
        LEFT OUTER JOIN 
		
		
		(
		
		
		SELECT *
		 FROM warehouse.dbo.FinancialEdgeInvoiceInfo 
		
        SELECT
            fe2.DESCRIPTION
           ,SUM(Fe2.FE_Amount) AS FE_Amount
           ,MIN(Fe2.FE_client_name__c) AS FE_Client_name__C
           ,SUM(Fe2.Balance) AS Balance
           ,MIN(Fe2.AR7CLIENTSID) AS AR7CLIENTSID
           ,MAX(Fe2.FE_Last_Updated) AS FE_Last_Updated
           ,MIN(Fe2.INVOICEDATE) AS INVOICEDATE
           ,STUFF((
                    SELECT
                        ', ' + CAST([fe1].[fe_Invoice] AS VARCHAR(MAX))
                    FROM
                        warehouse.dbo.FinancialEdgeInvoiceInfo fe1
                    WHERE
                        fe1.DESCRIPTION = fe2.DESCRIPTION ---- string with grouping by fileid
                  FOR
                    XML PATH('')
                  ), 1, 1, '') AS fe_Invoice
           ,STUFF((
                    SELECT
                        ', ' + CAST([fe3].[AR7CLIENTSID] AS VARCHAR(MAX))
                    FROM
                        warehouse.dbo.FinancialEdgeInvoiceInfo fe3
                    WHERE
                        fe3.DESCRIPTION = fe2.DESCRIPTION ---- string with grouping by fileid
                  FOR
                    XML PATH('')
                  ), 1, 1, '') AS AR7CLIENTSID
        FROM
            warehouse.dbo.FinancialEdgeInvoiceInfo fe2
        GROUP BY
            fe2.DESCRIPTION
		--GROUP BY fe.DESCRIPTION  
        
		
		
		--) fe2 ON LOWER(a.TissueIdentifier) = LOWER(fe.DESCRIPTION)
		
		
		
		
		
		LEFT OUTER JOIN (
                          SELECT
                            RequestId
                           ,MAX(ShipmentCreatedOn) AS max_Date
                          FROM
                            SIGHTLIFE.Data.ShipmentRequestInventory AS si
                          WHERE
                            ( ShipmentPurpose = 'Request Fulfillment' )
                            AND ( RequestId <> '00000000-0000-0000-0000-000000000000' )
                            AND ( ShipmentDeletedOn IS NULL )
                          GROUP BY
                            RequestId
                        ) AS b ON b.RequestId = a.RequestId
                                  AND a.RequestStatus <> 'Cancelled'
        LEFT OUTER JOIN (
                          SELECT
                            ShipmentItemId
                           ,ShipmentId
                           ,OwnedById
                           ,OwnedByShortName
                           ,ShipmentIdentifier
                           ,ShipFromId
                           ,ShipFromName
                           ,ShipFromShortName
                           ,ShipToId
                           ,ShipToName
                           ,ShipToShortName
                           ,HandCarried
                           ,HandCarriedById
                           ,HandCarriedByFirstName
                           ,HandCarriedByLastName
                           ,ShipperId
                           ,ShipperName
                           ,ShipperShortName
                           ,ShipmentPurpose
                           ,TrackingNumber
                           ,ShipOnPlanned
                           ,ShipOnActual
                           ,DeliverOnEstimated
                           ,DeliverOnActual
                           ,DeliveryBy
                           ,ShipmentLabelComments
                           ,ShipmentComments
                           ,ShipmentCreatedBy
                           ,ShipmentCreatedOn
                           ,ShipmentDeletedBy
                           ,ShipmentDeletedOn
                           ,RequestId
                           ,RequestType
                           ,RequestIdentifier
                           ,RequestStatus
                           ,RequestedOn
                           ,RequiredOn
                           ,RequestComments
                           ,RequestCancelReason
                           ,SurgeonId
                           ,SurgeonFirstName
                           ,SurgeonLastName
                           ,SurgeonUnknown
                           ,SurgeryLocationId
                           ,SurgeryLocationName
                           ,SurgeryLocationShortName
                           ,ResearcherId
                           ,ResearcherFirstName
                           ,ResearcherLastName
                           ,ResearcherUnknown
                           ,ResearchLocationId
                           ,ResearchLocationName
                           ,ResearchLocationShortName
                           ,RequestingOrganizationId
                           ,RequestingOrganizationName
                           ,RequestingOrganizationShortName
                           ,IntendedOutcome
                           ,IntendedSubOutcome
                           ,TissueTypeRequested
                           ,TissueSubTypeRequested
                           ,TissueTypeRequestedOther
                           ,SurgeryType
                           ,SurgerySubType
                           ,TissueUse
                           ,PreCutRequested
                           ,PreCutRequestedOn
                           ,PreCutRequestedType
                           ,PreCutParameters
                           ,PreCutParametersOther
                           ,PreCutParametersDepth
                           ,PreCutParametersDiameter
                           ,PreCutSentOut
                           ,PreCutLocationId
                           ,PreCutLocationName
                           ,PreCutLocationShortName
                           ,PoNumber
                           ,TissueFee
                           ,ProcessingFee
                           ,ShippingFee
                           ,FeeAdjustment
                           ,TotalFee
                           ,InvoiceNumber
                           ,RequestCreatedBy
                           ,RequestCreatedOn
                           ,RequestCancelledBy
                           ,RequestCancelledOn
                           ,InventoryId
                           ,ParentEyeTissueId
                           ,IsDeleted
                           ,IsConfirmed
                           ,ChildCount
                           ,TissueIdentifier
                           ,TissueCode
                           ,RecoveryTissueType
                           ,RecoveryTissueTypeOther
                           ,RecoveryTissueSubtype
                           ,Oculus
                           ,StorageMedia
                           ,StorageMediaLotNumber
                           ,StorageMediaExpirationDate
                           ,InventoryStatus
                           ,RecoveryIntent
                           ,ApprovedOutcomes
                           ,ApprovedForTransplant
                           ,ApprovedForResearch
                           ,ApprovedForTraining
                           ,ApprovedForDiscard
                           ,ApprovedOutcomeDetails
                           ,ApprovedUsages
                           ,ReleasedOn
                           ,FinalReviewAndApprovalBy
                           ,ApprovedByFirstName
                           ,ApprovedByLastName
                           ,ApprovalSignatureId
                           ,Outcome
                           ,OutcomeDetail
                           ,DiscardedOn
                           ,DiscardedBy
                           ,DiscardedByFirstName
                           ,DiscardedByLastName
                           ,DiscardDeterminedBy
                           ,DiscardDeterminedByFirstName
                           ,DiscardDeterminedByLastName
                           ,Nsft
                           ,PrimaryNsftReason
                           ,PrimaryNsftReasonOther
                           ,NsftSerology
                           ,NsftSerologyOther
                           ,NsftSerologyOtherDescription
                           ,NsftSerologyOtherCommunicable
                           ,NsftSerologyOtherCommunicableDescription
                           ,NsftSerologyBloodSampleIssue
                           ,NsftMedicalRecord
                           ,NsftMedicalRecordOther
                           ,NsftMedicalRecordOtherDescription
                           ,NsftMedSocInterview
                           ,NsftMedSocInterviewOther
                           ,NsftMedSocInterviewOtherDescription
                           ,NsftSocialBehavioralHistory
                           ,NsftBodyExam
                           ,NsftEpithelium
                           ,NsftStroma
                           ,NsftStromaOther
                           ,NsftStromaOtherDescription
                           ,NsftDescemetsMembrane
                           ,NsftEndothelium
                           ,NsftQuality
                           ,NsftQualityOther
                           ,NsftQualityOtherDescription
                           ,NsftReleased
                           ,NsftPostRelease
                           ,NsftPostReleaseOther
                           ,NsftPostReleaseOtherDescription
                           ,NsftComments
                           ,ReasonForImport
                           ,OriginEyeBank
                           ,OriginEyeBankName
                           ,OriginEyeBankShortName
                           ,OriginEyeBankDonorNumber
                           ,OriginEyeBankTissueNumber
                           ,InHouse
                           ,TissueLabelPrintedOn
                           ,TissueLabelPrintedBy
                          FROM
                            SIGHTLIFE.DATA.ShipmentRequestInventory
                          WHERE
                            ( ShipmentItemId NOT IN (
                              SELECT
                                Id
                              FROM
                                SIGHTLIFE.EyeDist.ShipmentItem
                              WHERE
                                ( DeletedOn IS NOT NULL ) ) )
                        ) AS sri ON sri.RequestId = b.RequestId
                                    AND sri.ShipmentCreatedOn = b.max_Date

GO




--35FC9502-F480-451C-A730-B3483224A0F6
--B8CF761F-8CBC-4227-91A9-B86953352556
--02088679-BBBE-4290-B176-EAA1D8B761F4