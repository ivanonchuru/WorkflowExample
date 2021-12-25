codeunit 50102 "Custom Workflow Responses"
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowResponseHandling: Codeunit 1521;
        CustWorkflowEventHandling: Codeunit 50101;
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.SetStatusToPendingApprovalCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, CustWorkflowEventHandling.RunWorkflowOnSendFAAllocationForApprovalCode);
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, CustWorkflowEventHandling.RunWorkflowOnSendFAAllocationForApprovalCode);
            WorkflowResponseHandling.CancelAllApprovalRequestsCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, CustWorkflowEventHandling.RunWorkflowOnCancelFAAllocationForApprovalCode);
            WorkflowResponseHandling.OpenDocumentCode:
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, CustWorkflowEventHandling.RunWorkflowOnCancelFAAllocationForApprovalCode);
        end

    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        FAAllocation: Record "Fixed Asset Allocation";
    begin
        case RecRef.Number of
            DATABASE::"Fixed Asset Allocation":
                begin
                    RecRef.SetTable(FAAllocation);
                    FAAllocation."Approval Status" := FAAllocation."Approval Status"::Open;
                    FAAllocation.Modify;
                    Handled := true;
                end;

        end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        FAAllocation: Record "Fixed Asset Allocation";
    begin
        case RecRef.Number of
            DATABASE::"Fixed Asset Allocation":
                begin
                    RecRef.SetTable(FAAllocation);
                    FAAllocation."Approval Status" := FAAllocation."Approval Status"::Approved;
                    FAAllocation.Modify;
                    Handled := true;
                end;

        end
    end;
}
