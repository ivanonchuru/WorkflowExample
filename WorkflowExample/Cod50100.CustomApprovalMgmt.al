codeunit 50100 "Custom Approval Mgmt"
{
    trigger OnRun()
    begin
    end;

    var
        WorkflowManagement: Codeunit 1501;
        CustWorkflowEventHandling: Codeunit 50101;
        NoWorkflowEnabledErr: TextConst ENU = 'No approval workflow for this record type is enabled';


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        FAAllocation: Record "Fixed Asset Allocation";
    begin
        Case RecRef.NUMBER of
            DATABASE::"Fixed Asset Allocation":
                begin
                    RecRef.SetTable(FAAllocation);
                    ApprovalEntryArgument."Document No." := FAAllocation."No.";
                end;
        end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        FAAllocation: Record "Fixed Asset Allocation";
    begin
        Case RecRef.Number of
            DATABASE::"Fixed Asset Allocation":
                begin
                    RecRef.SetTable(FAAllocation);
                    FAAllocation."Approval Status" := FAAllocation."Approval Status"::"Pending Approval";
                    FAAllocation.Modify;
                    IsHandled := true;
                end;
        End
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendFAAllocationForApproval(var FAAllocation: Record "Fixed Asset Allocation")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelFAAllocationForApproval(var FAAllocation: Record "Fixed Asset Allocation")
    begin
    end;

    procedure CheckFAAllocationApprovalsWorkflowEnable(var FAAllocation: Record "Fixed Asset Allocation"): Boolean
    begin
        if not IsFAAllocationApprovalsWorkflowEnabled(FAAllocation) then
            Error(NoWorkflowEnabledErr);
        exit(true)
    end;

    procedure IsFAAllocationApprovalsWorkflowEnabled(var FAAllocation: Record "Fixed Asset Allocation"): Boolean
    begin
        if FAAllocation."Approval Status" <> FAAllocation."Approval Status"::Open then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(FAAllocation, CustWorkflowEventHandling.RunWorkflowOnSendFAAllocationForApprovalCode));
    end;

}
