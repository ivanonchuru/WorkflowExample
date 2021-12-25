codeunit 50104 "Custom Page Management"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnAfterGetPageID', '', true, true)]
    local procedure OnAfterGetPageID(RecordRef: RecordRef; var PageID: Integer)
    begin
        if PageID = 0 then
            PageID := GetConditionalCardPageID(RecordRef);
    end;

    local procedure GetConditionalCardPageID(REcordRef: RecordRef): Integer
    var
        myInt: Integer;
    begin
        case RecordRef.Number of
            Database::"Fixed Asset Allocation":
                exit(Page::"Fixed Asset Allocation Card");
        end;
    end;

}
