codeunit 50103 "Custom Workflow Setup"
{
    trigger OnRun()
    begin
    end;

    var
        WorkflowSetup: Codeunit 1502;
        FAAllocationWorkflowCategoryTxt: TextConst ENU = 'Fixed Assets';
        FAAllocationWorkflowCategoryDescTxt: TextConst ENU = 'Fixed Assets Document';
        FAAllocatioApprovalWorkflowCodeTxt: TextConst ENU = 'FA Allocation';
        FAAllocatioApprovalWorkfowDescTxt: TextConst ENU = 'Fixed Asset Allocation Approval Workflow';
        FAAllocationTypeCondTxt: TextConst ENU = '<?xml version = “1.0” encoding=”utf-8” standalone=”yes”?><ReportParameters><DataItems><DataItem name=”FAAllocation”>%1</DataItem></DataItems></ReportParameters>';


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', true, true)]
    local procedure OnAddWorkflowCategoriesToLibrary()
    begin
        WorkflowSetup.InsertWorkflowCategory(FAAllocationWorkflowCategoryTxt, FAAllocatioApprovalWorkfowDescTxt);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', true, true)]
    local procedure OnAfterInsertApprovalsTableRelations()
    var
        ApprovalEntry: Record 454;
    begin
        WorkflowSetup.InsertTableRelation(Database::"Fixed Asset Allocation", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnInsertWorkflowTemplates', '', true, true)]
    local procedure OnInsertWorkflowTemplates()
    begin
        //TODO
    end;

    local procedure InsertFAAllocationApprovalWorkflowTemplate()
    var
        Workflow: Record 1501;
    Begin
        WorkflowSetup.InsertworkflowTemplate(Workflow, FAAllocatioApprovalWorkflowCodeTxt, FAAllocatioApprovalWorkfowDescTxt, FAAllocationWorkflowCategoryTxt);
        InsertFAAllocationApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkworkflowAsTemplate(Workflow);
    End;

    local procedure InsertFAAllocationApprovalWorkflowDetails(var Workflow: Record 1501)
    Var
        WorkflowStepArgument: Record 1523;
        BlankDateFormula: DateFormula;
        WorkflowEventHandlingCust: Codeunit 50101;
        WorkflowResponseHandling: Codeunit 1521;
        FAAllocation: Record "Fixed Asset Allocation";
    begin

        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument, WorkflowStepargument."Approver Type"::Approver, WorkflowStepargument."Approver Limit Type"::"Direct Approver", 0, '', BlankDateFormula, true);
        WorkflowSetup.InsertDocApprovalWorkflowSteps(
            Workflow,
            BuildFAAllocationTypeConditions(FAAllocation."Approval Status"::Open.AsInteger()),
            WorkflowEventHandlingCust.RunWorkflowOnSendFAAllocationForApprovalCode,
            BuildFAAllocationTypeConditions(FAAllocation."Approval Status"::"Pending Approval".AsInteger()),
            WorkflowEventHandlingCust.RunWorkflowOnCancelFAAllocationForApprovalCode,
            WorkflowStepArgument, TRUE);
    end;

    local procedure BuildFAAllocationTypeConditions(Status: Integer): Text
    var
        FAAllocation: Record "Fixed Asset Allocation";
    begin
        FAAllocation.SetRange("Approval Status", Status);
        EXIT(STRSUBSTNO(FAAllocationTypeCondTxt, WorkflowSetup.Encode(FAAllocation.GETVIEW(FALSE))));
    end;




}
