unit uCad;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, StdCtrls;

type
  TfrmCad = class(TForm)
    Label1: TLabel;
    edtNome: TEdit;
    Label2: TLabel;
    edId: TEdit;
    Label3: TLabel;
    edCpf: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edEmail: TEdit;
    gbEndereco: TGroupBox;
    Label6: TLabel;
    edCep: TEdit;
    Label7: TLabel;
    edLogad: TEdit;
    Label8: TLabel;
    edNum: TEdit;
    Label9: TLabel;
    edComp: TEdit;
    Label10: TLabel;
    edBairro: TEdit;
    Label11: TLabel;
    edCidade: TEdit;
    Label12: TLabel;
    edUf: TEdit;
    Label13: TLabel;
    edPais: TEdit;
    edTel: TMaskEdit;
    btEnviar: TButton;
    procedure edCepExit(Sender: TObject);
    procedure btEnviarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCad: TfrmCad;

implementation

uses uFuncoes;

{$R *.dfm}

procedure TfrmCad.btEnviarClick(Sender: TObject);
var path : string;
begin
  path := ExtractFilePath(Application.ExeName) + '\Registro.xml';
  MontaXML(path);
  EnviaEmail(path);
end;

procedure TfrmCad.edCepExit(Sender: TObject);
begin
  ValidaCEP(edCep.Text);
end;

end.
