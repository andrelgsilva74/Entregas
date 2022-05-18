unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  uRESTDWBaseIDQX,
  uDWConsts,
  uDWJSONObject,
  uDWJSONTools,
  ServerUtils,
  DataSet.Serialize.Config;

type
  TFrmPrincipal = class(TForm)
    memo: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    RestDWServerQuickX: TRESTDWServerQXID;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses DataModule.Global, Controllers.Remessa;




procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    RestDWServerQuickX := TRESTDWServerQXID.Create(nil);

    // Autenticacao...
    RestDWServerQuickX.AuthenticationOptions.AuthorizationOption := TRDWAuthOption.rdwAOBasic;
    TRDWAuthOptionBasic(RestDWServerQuickX.AuthenticationOptions.OptionParams).Username := '99coders';
    TRDWAuthOptionBasic(RestDWServerQuickX.AuthenticationOptions.OptionParams).Password := '112233';

    // CORS...
    RestDWServerQuickX.CORS := true;
    RestDWServerQuickX.CORS_CustomHeaders.Clear;
    RestDWServerQuickX.CORS_CustomHeaders.Add('Access-Control-Allow-Origin=*');
    RestDWServerQuickX.CORS_CustomHeaders.Add('Access-Control-Allow-Methods=GET, POST, PATCH, PUT, DELETE, OPTIONS');
    RestDWServerQuickX.CORS_CustomHeaders.Add('Access-Control-Allow-Headers=Content-Type, Origin, Accept, Authorization, X-CUSTOM-HEADER');


    // Configura o Dataset Serialize...
    TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;

    // Conectar com o banco...
    try
        DmGlobal.ConectarBanco;
        memo.Lines.Add('Conexão com banco de dados: OK');
    except on ex:exception do
        memo.Lines.Add('Erro: ' + ex.Message);
    end;

    // Registrar as rotas...
    Controllers.Remessa.RegistrarRotas(RestDWServerQuickX);


    // Subir a aplicacao...
    RestDWServerQuickX.Bind(3000, False);
end;

procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    RestDWServerQuickX.Active := false;
    RestDWServerQuickX.Free;
end;

end.
