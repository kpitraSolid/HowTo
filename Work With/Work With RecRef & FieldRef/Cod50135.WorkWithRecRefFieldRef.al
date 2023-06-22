codeunit 50135 "Work With RecRef FieldRef"
{
    procedure UpdateCity(RecordToUpdate: Variant; NewCityName: Code[20]; FieldNo: Integer)
    var
        DataTypeMgt: Codeunit "Data Type Management";
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        if NewCityName = 'RZESZÓW' then
            Error('Nie możesz wprowadzić RZESZÓW');

        DataTypeMgt.GetRecordRef(RecordToUpdate, RecRef);
        FldRef := RecRef.Field(FieldNo);
        FldRef.Validate(NewCityName);
        RecRef.Modify(true);
    end;

    local procedure SetFilter(var Rec: Record Customer)
    var
        DataTypeMgt: Codeunit "Data Type Management";
        RecRef: RecordRef;
        FldRefNo: FieldRef;
    begin
        RecRef.Open(Rec.RecordId.TableNo);
        RecRef.Copy(Rec);
        if DataTypeMgt.FindFieldByName(RecRef, FldRefNo, 'No.') then
            FldRefNo.SetFilter('10000');
        RecRef.SetTable(Rec);
    end;

    local procedure SetFilter2(var Rec: Record Customer)
    var
        DataTypeMgt: Codeunit "Data Type Management";
        RecRef: RecordRef;
        FldRefNo: FieldRef;
    begin
        RecRef.Open(Rec.RecordId.TableNo);
        RecRef.Copy(Rec);
        if DataTypeMgt.FindFieldByName(RecRef, FldRefNo, 'Name') then
            FldRefNo.SetFilter('Adatum Corporation');
        RecRef.SetTable(Rec);
    end;

    local procedure SetFilterVariant(RecVariant: Variant): Variant
    var
        DataTypeMgt: Codeunit "Data Type Management";
        OutVariant: Variant;
        RecRef: RecordRef;
        FldRefNo: FieldRef;
    begin
        DataTypeMgt.GetRecordRef(RecVariant, RecRef);
        if DataTypeMgt.FindFieldByName(RecRef, FldRefNo, 'Name') then
            FldRefNo.SetFilter('ALA');
        RecRef.GetTable(OutVariant);
    end;



    [EventSubscriber(ObjectType::Page, Page::"Customer List", 'OnOpenPageEvent', '', true, true)]
    local procedure SetFilterCustomerList(var Rec: Record Customer)
    begin
        SetFilter(Rec);
        SetFilter2(Rec);
        //Rec := SetFilterVariant(Rec); // <- przez Variant nie działa...
    end;

    procedure FindLineAndCheck(FromDoc: Variant)
    var
        DataTypeMgt: Codeunit "Data Type Management";
        DocumentToCheck: RecordRef;
    begin
        DataTypeMgt.GetRecordRef(FromDoc, DocumentToCheck);
        SearchAndCheckLine(DocumentToCheck);
    end;

    local procedure SearchAndCheckLine(DocumentToCheck: RecordRef)
    var
        DataTypeMgt: Codeunit "Data Type Management";
        LineToCheck: RecordRef;
        FRDoucmentNoLine: FieldRef;
        FRDoucmentNoHeader: FieldRef;
        DocumentNo: Code[20];
        SalesLine: Record "Sales Line";
    begin
        if not DataTypeMgt.FindFieldByName(DocumentToCheck, FRDoucmentNoHeader, 'No.') then
            exit;

        case DocumentToCheck.Number of
            Database::"Sales Header":
                LineToCheck.Open(Database::"Sales Line");
            else
                exit;
        end;

        DataTypeMgt.FindFieldByName(LineToCheck, FRDoucmentNoLine, 'Document No.');
        FRDoucmentNoLine.SetRange(FRDoucmentNoHeader.Value);

        if LineToCheck.FindSet() then
            repeat
                SalesLine.Get(LineToCheck.RecordId);
                Message('%1 %2 %3', SalesLine."Document No.", SalesLine."Line No.", SalesLine."No.");
            until LineToCheck.Next() < 1;
    end;
}
