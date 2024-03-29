tableextension 50101 "Ext Sales Line" extends "Sales Line"
{
    fields
    {
        field(50100; "My Quantity 1"; Decimal)
        {
            Caption = 'My Quantity 1';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                WorkWith: Codeunit "Work With Record";
                Variant: Variant;
            begin
                Variant := Rec;
                WorkWith.CalculateSetAndProcesedRecToVariant(Variant);
                Rec := Variant;
            end;
        }
        field(50101; "My Quantity 2"; Decimal)
        {
            Caption = 'My Quantity 2';
            DataClassification = ToBeClassified;
        }
    }
}
