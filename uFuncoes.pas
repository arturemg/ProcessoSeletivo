unit uFuncoes;

interface

uses
  Classes, SysUtils, DBXJSON, IdHTTP, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  IdMessage, IdSSL, IdText, IdAttachmentFile,
  Dialogs, xmldom, XMLIntf, msxmldom, XMLDoc;

procedure ValidaCEP(cep: string);
procedure CarregaCep;
procedure LimpaDados;
procedure EnviaEmail(Path: string);
procedure MontaXML(Path: String);

var
  jsonObject: TJsonObject;
  Logad: string;
  Comp: string;
  Bairro: string;
  Cidade: string;
  UF: String;
  Valido: Boolean;

implementation

uses uCad;

procedure ValidaCEP(cep: string);
var
  HTTP: TIdHTTP;
  IDSSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  Resp: TStringStream;
  strRetorno: string;
begin
  Valido := True;
  try
    HTTP := TIdHTTP.Create;
    IDSSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create;
    HTTP.IOHandler := IDSSLHandler;
    Resp := TStringStream.Create('');
    HTTP.Get('https://viacep.com.br/ws/' + cep + '/json', Resp);

    jsonObject := TJsonObject.Create;
    if (HTTP.ResponseCode = 200) and not(Utf8ToAnsi(Resp.DataString)
        = '{'#$A'  "erro": true'#$A'}') then
    begin
      jsonObject := TJsonObject.ParseJSONValue
        (TEncoding.ASCII.GetBytes(Utf8ToAnsi(Resp.DataString)), 0)
        as TJsonObject;
      CarregaCep;
    end
    else
    begin
      LimpaDados;
    end;
  finally
    FreeAndNil(HTTP);
    FreeAndNil(IDSSLHandler);
    Resp.Destroy
  end;
end;

procedure CarregaCep;
begin
  frmCad.edLogad.Text := jsonObject.Get(1).JsonValue.Value;
  frmCad.edCidade.Text := jsonObject.Get(4).JsonValue.Value;
  frmCad.edBairro.Text := jsonObject.Get(3).JsonValue.Value;
  frmCad.edUf.Text := jsonObject.Get(5).JsonValue.Value;
  frmCad.edComp.Text := jsonObject.Get(2).JsonValue.Value;
end;

procedure LimpaDados;
begin
  frmCad.edLogad.Clear;
  frmCad.edCidade.Clear;
  frmCad.edBairro.Clear;
  frmCad.edUf.Clear;
  frmCad.edComp.Clear;
end;

procedure EnviaEmail(Path: string);
var
  IDSSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
  IdText: TIdText;
  sAnexo: string;
begin
  IDSSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create;
  IdSMTP := TIdSMTP.Create;
  IdMessage := TIdMessage.Create;

  try
    IDSSLHandler.SSLOptions.Method := sslvSSLv23;
    IDSSLHandler.SSLOptions.Mode := sslmClient;

    IdSMTP.IOHandler := IDSSLHandler;
    IdSMTP.UseTLS := utUseImplicitTLS;
    IdSMTP.AuthType := satDefault;
    IdSMTP.Port := 465;
    IdSMTP.Host := 'smtp.gmail.com';
    IdSMTP.Username := 'Usuario@gmai.com';
    IdSMTP.Password := 'Senha';

    // Configuração da mensagem (TIdMessage)
    IdMessage.From.Address := 'Usuario@gmail.com';
    IdMessage.From.Name := frmCad.edtNome.Text;
    IdMessage.ReplyTo.EMailAddresses := IdMessage.From.Address;
    IdMessage.Recipients.Add.Text := frmCad.edEmail.Text;
    IdMessage.Subject := 'Cadstro de Cliente';
    IdMessage.Encoding := meMIME;

    // Configuração do corpo do email (TIdText)
    IdText := TIdText.Create(IdMessage.MessageParts);
    IdText.Body.Add('Dados Cadastrais:');
    IdText.Body.Add('Nome:         ' + frmCad.edtNome.Text);
    IdText.Body.Add('RG:           ' + frmCad.edId.Text);
    IdText.Body.Add('CPF:          ' + frmCad.edCpf.Text);
    IdText.Body.Add('Celular:      ' + frmCad.edTel.Text);
    IdText.Body.Add('Email:        ' + frmCad.edEmail.Text);
    IdText.Body.Add('CEP:          ' + frmCad.edCep.Text);
    IdText.Body.Add('Logadouro:    ' + frmCad.edLogad.Text);
    IdText.Body.Add('Número:       ' + frmCad.edNum.Text);
    IdText.Body.Add('Complemento:  ' + frmCad.edComp.Text);
    IdText.Body.Add('Bairro:       ' + frmCad.edBairro.Text);
    IdText.Body.Add('Cidade:       ' + frmCad.edCidade.Text);
    IdText.Body.Add('UF:           ' + frmCad.edUf.Text);
    IdText.Body.Add('Pais:         ' + frmCad.edPais.Text);
    IdText.ContentType := 'text/plain; charset=iso-8859-1';

    // Anexo da mensagem (TIdAttachmentFile)
    sAnexo := Path;
    if FileExists(sAnexo) then
    begin
      TIdAttachmentFile.Create(IdMessage.MessageParts, sAnexo);
    end;

    // Conexão e autenticação
    try
      IdSMTP.Connect;
      IdSMTP.Authenticate;
    except
      on E: Exception do
      begin
        MessageDlg('Erro na conexão ou autenticação: ' + E.Message, mtWarning,
          [mbOK], 0);
        Exit;
      end;
    end;

    // Envio da mensagem
    try
      IdSMTP.Send(IdMessage);
      MessageDlg('Mensagem enviada com sucesso!', mtInformation, [mbOK], 0);
    except
      On E: Exception do
      begin
        MessageDlg('Erro ao enviar a mensagem: ' + E.Message, mtWarning,
          [mbOK], 0);
      end;
    end;
  finally
    IdSMTP.Disconnect;
    UnLoadOpenSSLLibrary;
    FreeAndNil(IdMessage);
    FreeAndNil(IDSSLHandler);
    FreeAndNil(IdSMTP);
  end;
end;

procedure MontaXML(Path: String);
var
  doc: TXMLDocument;
  Raiz, Nome, Rg, Cpf, Cel, Email, cep, Logad, Num, Comp, Bairro, Cidade, UF,
    Pais, Ver, PowerBy: IXMLNode;
begin
  doc.FileName := '';
  doc.XML.Text := '';
  doc.Active := False;
  doc.Active := True;
  doc.Version := '1.0';
  doc.Encoding := 'UTF-8';

  // RAIZ
  Raiz := doc.AddChild('Registros');

  Nome := doc.CreateNode('NOME', ntElement);
  Nome.Text := frmCad.edtNome.Text;
  Raiz.ChildNodes.Add(Nome);

  Rg := doc.CreateNode('RG', ntElement);
  Rg.Text := frmCad.edId.Text;
  Raiz.ChildNodes.Add(Rg);

  Cpf := doc.CreateNode('CPF', ntElement);
  Cpf.Text := frmCad.edCpf.Text;
  Raiz.ChildNodes.Add(Cpf);

  Cel := doc.CreateNode('CELULAR', ntElement);
  Cel.Text := frmCad.edTel.Text;
  Raiz.ChildNodes.Add(Cel);

  Email := doc.CreateNode('EMAIL', ntElement);
  Email.Text := frmCad.edEmail.Text;
  Raiz.ChildNodes.Add(Email);

  cep := doc.CreateNode('Cep', ntElement);
  cep.Text := frmCad.edCep.Text;
  Raiz.ChildNodes.Add(cep);

  Logad := doc.CreateNode('LOGADOURO', ntAttribute);
  Logad.Text := frmCad.edLogad.Text;
  cep.AttributeNodes.Add(Logad);

  Num := doc.CreateNode('NUMERO', ntAttribute);
  Num.Text := frmCad.edNum.Text;
  cep.AttributeNodes.Add(Num);

  Comp := doc.CreateNode('COMPLEMENTO', ntAttribute);
  Comp.Text := frmCad.edComp.Text;
  cep.AttributeNodes.Add(Comp);

  Bairro := doc.CreateNode('BAIRRO', ntAttribute);
  Bairro.Text := frmCad.edBairro.Text;
  cep.AttributeNodes.Add(Bairro);

  Cidade := doc.CreateNode('CIDADE', ntAttribute);
  Cidade.Text := frmCad.edCidade.Text;
  cep.AttributeNodes.Add(Cidade);

  UF := doc.CreateNode('UF', ntAttribute);
  UF.Text := frmCad.edUf.Text;
  cep.AttributeNodes.Add(UF);

  Pais := doc.CreateNode('PAIS', ntAttribute);
  Pais.Text := frmCad.edPais.Text;
  cep.AttributeNodes.Add(Pais);

  doc.SaveToFile(Path);
  doc.Active := False;
end;

end.
