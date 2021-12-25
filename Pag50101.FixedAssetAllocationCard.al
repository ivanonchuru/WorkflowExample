page 50101 "Fixed Asset Allocation Card"
{

    Caption = 'Fixed Asset Allocation Card';
    PageType = Card;
    SourceTable = "Fixed Asset Allocation";
    PromotedActionCategories = 'New,Process,Report,Approve,New Document,Document Approval,Customer,Navigate,Prices & Discounts';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Fixed Asset No."; Rec."Fixed Asset No.")
                {
                    ToolTip = 'Specifies the value of the Fixed Asset No. field.';
                    ApplicationArea = All;
                }
                field("Fixed Asset Description"; Rec."Fixed Asset Description")
                {
                    ToolTip = 'Specifies the value of the Fixed Asset Description field.';
                    ApplicationArea = All;
                }
                field("Responsible User"; Rec."Responsible User")
                {
                    ToolTip = 'Specifies the value of the Responsible User field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("New User"; Rec."New User")
                {
                    ToolTip = 'Specifies the value of the New User field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("Request Approvals")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;

                action(SendApprovalRequest)
                {
                    ApplicationArea = all;
                    Caption = 'Send A&pproval Request';
                    Enabled = (NOT OpenApprovalEntriesExist) AND EnabledApprovalWorkflowsExist;//AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ToolTip = 'Request approval to change the record.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        If CustApprovalsMgmt.CheckFAAllocationApprovalsWorkflowEnable(Rec) then
                            CustApprovalsMgmt.OnSendFAAllocationForApproval(Rec);
                        //SetWorkFlowEnabled();                        
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = All;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
                    begin
                        CustApprovalsMgmt.OnCancelFAAllocationForApproval(Rec);
                        WorkflowWebhookManagement.FindAndCancel(RecordId);
                    end;
                }
                action(ApprovalEntries)
                {
                    ApplicationArea = All;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(RecordId);
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        WorkFlowEventFilter :=
        CustWEFHandling.RunWorkflowOnSendFAAllocationForApprovalCode;
        SetWorkFlowEnabled();
    end;

    trigger OnAfterGetCurrRecord()
    var
        WorkflowStepInstance: Record "Workflow Step Instance";
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
    begin
        WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);
        WorkflowStepInstance.SetRange("Record ID", Rec.RecordId);
        ShowWorkflowStatus := not WorkflowStepInstance.IsEmpty();
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
        if OpenApprovalEntriesExist then
            OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId)
        else
            OpenApprovalEntriesExistCurrUser := false;

    end;

    local procedure SetWorkFlowEnabled()
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        AnyWorkflowExists := WorkflowManagement.AnyWorkflowExists();
        EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::"Fixed Asset Allocation", WorkFlowEventFilter);
    end;


    var
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        CanCancelApprovalForRecord: Boolean;
        EnabledApprovalWorkflowsExist: Boolean;
        AnyWorkflowExists: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CustApprovalsMgmt: Codeunit "Custom Approval Mgmt";
        WorkFlowEventFilter: Text;
        CustWEFHandling: Codeunit "Custom Workflow Events";



}