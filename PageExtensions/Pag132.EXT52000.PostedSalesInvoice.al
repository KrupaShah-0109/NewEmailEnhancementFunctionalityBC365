pageextension 52000 "PostedSalesInvExt52000" extends "Posted Sales Invoice"
{


    actions
    {
        addafter("Email Later Flag XS")
        {
            action("E-Mail with New Enhancement")
            {
                ToolTip = 'E-Mail with New Enhancement';
                Caption = 'E-Mail with New Enhancement';
                ApplicationArea = All;
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Category6;
                trigger OnAction()
                var
                    MailSalesInvoiceReport: Report PostedSalesInvMail;
                begin
                    clear(MailSalesInvoiceReport);
                    CurrPage.SetSelectionFilter(Rec);
                    MailSalesInvoiceReport.SetTableView(Rec);
                    MailSalesInvoiceReport.Run();
                    Commit();
                    Clear(MailSalesInvoiceReport);
                end;

            }
        }
    }


}