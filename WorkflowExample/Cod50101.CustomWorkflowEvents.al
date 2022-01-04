codeunit 50101 "Custom Workflow Events"
{
    trigger OnRun()
    begin
    end;

    var
        WorkflowManagement: Codeunit 1501;
        WorkflowEventHandling: Codeunit 1520;
        FAAllocationSendForApprovalEventDescTxt: TextConst ENU = 'An Approval for Fixed Asset Allocation is requested';
        FAAllocationApprovalREquestCancelEventDescTxt: TextConst ENU = 'An Approval for Fixed Asset Allocation is cancelled';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendFAAllocationForApprovalCode, Database::"Fixed Asset Allocation", FAAllocationSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelFAAllocationForApprovalCode, Database::"Fixed Asset Allocation", FAAllocationApprovalREquestCancelEventDescTxt, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendFAAllocationForApprovalCode);
        WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendFAAllocationForApprovalCode);
        WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendFAAllocationForApprovalCode);
    end;


    procedure RunWorkflowOnSendFAAllocationForApprovalCode(): code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendFAAllocationForApproval'));
    end;

    procedure RunWorkflowOnCancelFAAllocationForApprovalCode(): code[128]
    begin
        exit(uppercase('RunWorkflowOnCancelFAAllocationForApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Approval Mgmt", 'OnSendFAAllocationForApproval', '', true, true)]

    local procedure RunWorkflowOnSendFAAllocationForApproval(var FAAllocation: Record "Fixed Asset Allocation")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendFAAllocationForApprovalCode, FAAllocation);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Approval Mgmt", 'OnCancelFAAllocationForApproval', '', true, true)]
    local procedure RunWorkflowOnCancelFAAllocationForApproval(var FAAllocation: Record "Fixed Asset Allocation")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelFAAllocationForApprovalCode, FAAllocation);
    end;
}
