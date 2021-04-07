report 52000 "PostedSalesInvMail"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;


    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            Var
                CustomerRec: Record Customer;
                CustomReportLayout: Record "Custom Report Layout";
                ReportLayoutSelection: Record "Report Layout Selection";
                // Message: Record "Email Message";
                // SMTPAccountRec: Record "Email Account";
                PostedSalesInvoiceEmail: Report "SalesInvoice XS";
                TypeHelper: Codeunit "Type Helper";
                EmailCOD: Codeunit Email;
                EmailMessageCOD: Codeunit "Email Message";
                // EmailMessageIMPLCOD: codeunit "Email Message Impl.";
                TempBlobCOD: Codeunit "Temp Blob";
                AddCCtext: List of [text];
                EMAILText: List of [text];
                AddBCCText: List of [text];
                SplitText: text;
                EmailId: text;
                EmailOutStream: OutStream;
                EmailInStream: InStream;
                BodyText: text;
                CRLF: text[2];
            begin
                clear(TempBlobCOD);
                clear(PostedSalesInvoiceEmail);
                clear(CRLF);
                clear(TypeHelper);
                clear(EmailInStream);
                CRLF := TypeHelper.CRLFSeparator();
                CustomerRec.Reset();
                CustomerRec.GET("Sales Invoice Header"."Sell-to Customer No.");

                TempBlobCOD.CreateOutStream(EmailOutStream);
                TempBlobCOD.CreateInStream(EmailInStream);
                EmailId := CustomerRec."E-Mail";
                EMAILText := EmailId.Split(';');
                if EmailId <> '' then begin
                    if CustomerRec."CC Email XS" <> '' then begin
                        SplitText := CustomerRec."CC Email XS";
                        AddCCtext := SplitText.Split(';');
                    end;
                    BodyText := 'Hi ' + "Sales Invoice Header"."Sell-to Customer Name" + ','
                                                             + CRLF +
                                                             CRLF +
                                                              'Please refer to enclosed invoiced raised in your account' +
                                                             CRLF +
                                                             CRLF +
                                                              'Thank You,' +
                                                             CRLF +
                                                              'Eli Montague' +
                                                             CRLF +
                                                              'Accounting Manager' +
                                                             CRLF +
                                                              'O: (844) 790-3897 Ext. 6002' +
                                                             CRLF +
                                                              'C: (239) 273-1848' +
                                                             CRLF +
                                                              'F: (727) 800-3062' +
                                                             CRLF +
                                                              'eli@xs-supply.com' +
                                                             CRLF +
                                                              'www.xs-supply.com' +
                                                             CRLF +
                                                              'This is a system generated mail. Please do not reply to this mail!';
                    EmailMessageCOD.Create(EMAILText, 'Invoice - ' + "Sales Invoice Header"."No.", BodyText, false, AddCCtext, AddBCCText);
                    CustomReportLayout.Reset();
                    CustomReportLayout.SetRange("Report ID", 50102);
                    CustomReportLayout.SetRange(Type, CustomReportLayout.Type::RDLC);
                    if CustomReportLayout.FindFirst() then begin

                        ReportLayoutSelection.SetTempLayoutSelected(CustomReportLayout.Code);
                        PostedSalesInvoiceEmail.SetTableView("Sales Invoice Header");
                        PostedSalesInvoiceEmail.SaveAs('', ReportFormat::Pdf, EmailOutStream);
                        EmailMessageCOD.AddAttachment('Customer Invoice' + "Sales Invoice Header"."No." + '.pdf', '.pdf', EmailInStream);
                    end;
                    // clear(TempBlobCOD);
                    // clear(PostedSalesInvoiceEmail);
                    // clear(TypeHelper);
                    // clear(EmailInStream);
                    // clear(ReportLayoutSelection);
                    // TempBlobCOD.CreateOutStream(EmailOutStream);
                    // TempBlobCOD.CreateInStream(EmailInStream);
                    // CustomReportLayout.Reset();
                    // CustomReportLayout.SetRange("Report ID", 50102);
                    // CustomReportLayout.SetRange(Type, CustomReportLayout.Type::Word);
                    // if CustomReportLayout.FindFirst() then begin
                    //     ReportLayoutSelection.SetTempLayoutSelected(CustomReportLayout.Code);
                    //     PostedSalesInvoiceEmail.SetTableView("Sales Invoice Header");
                    //     PostedSalesInvoiceEmail.SaveAs('', ReportFormat::Html, EmailOutStream);
                    //     ReportLayoutSelection.SetTempLayoutSelected('');
                    //     //  EmailInStream.ReadText(BodyText);
                    //     // EmailMessageCOD.AddAttachment('Customer Invoice' + "Sales Invoice Header"."No." + '.pdf', '.pdf', EmailInStream);
                    // end;
                end;
                EmailCOD.Send(EmailMessageCOD);
            end;
        }
    }


}