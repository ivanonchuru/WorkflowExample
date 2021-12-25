page 50100 "Fixed Asset Allocation List"
{

    ApplicationArea = All;
    Caption = 'Fixed Asset Allocation List';
    PageType = List;
    SourceTable = "Fixed Asset Allocation";
    CardPageId = "Fixed Asset Allocation Card";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
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

}
