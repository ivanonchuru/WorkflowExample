table 50100 "Fixed Asset Allocation"
{
    Caption = 'Fixed Asset Allocation';
    DataClassification = ToBeClassified;
    LookupPageId = "FIxed Asset Allocation List";
    DrillDownPageId = "FIxed Asset Allocation List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Fixed Asset No."; Code[20])
        {
            Caption = 'Fixed Asset No.';
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset"."No.";

            trigger OnValidate()
            var
                FA: Record "Fixed Asset";
            begin
                if FA.Get("Fixed Asset No.") then begin
                    "Fixed Asset Description" := FA.Description;
                    "Responsible User" := FA."Responsible Employee";
                end;
            end;
        }
        field(3; "Fixed Asset Description"; Text[250])
        {
            Caption = 'Fixed Asset Description';
            DataClassification = ToBeClassified;
        }
        field(4; "Responsible User"; Code[50])
        {
            Caption = 'Responsible User';
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(5; "New User"; Code[50])
        {
            Caption = 'New User';
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(6; "Approval Status"; Enum "Custom Approval Status")
        {
            Caption = 'Approval Status';
            DataClassification = ToBeClassified;
        }
        field(7; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "No." = '' then begin
            SalesSetup.Get();
            SalesSetup.TestField("Customer Nos.");
            NoSeriesMgt.InitSeries(SalesSetup."Customer Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;


}
