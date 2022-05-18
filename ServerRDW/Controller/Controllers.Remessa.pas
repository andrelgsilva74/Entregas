unit Controllers.Remessa;

interface

uses System.JSON,
    System.Classes,
    ServerUtils,
    System.SysUtils,
    uRESTDWBaseIDQX,
    uDWConsts,
    uDWJSONObject,
    Controllers.Comum,
    DAO.Remessa,
    DataModule.Global;

procedure RegistrarRotas(RestDWServerQuickX: TRESTDWServerQXID);
procedure ListarMinhasRemessas(Sender: TObject; RequestHeader: TStringList;
                            Const Params: TDWParams; Var ContentType: String;
                            Var Result: String; Const RequestType: TRequestType;
                            Var StatusCode: Integer; Var ErrorMessage: String;
                            Var OutCustomHeader : TStringList);
procedure ListarEntregasDisponiveis(Sender: TObject; RequestHeader: TStringList;
                            Const Params: TDWParams; Var ContentType: String;
                            Var Result: String; Const RequestType: TRequestType;
                            Var StatusCode: Integer; Var ErrorMessage: String;
                            Var OutCustomHeader : TStringList);
procedure ListarHistorico(Sender: TObject; RequestHeader: TStringList;
                            Const Params: TDWParams; Var ContentType: String;
                            Var Result: String; Const RequestType: TRequestType;
                            Var StatusCode: Integer; Var ErrorMessage: String;
                            Var OutCustomHeader : TStringList);
procedure CadastrarRemessa(Sender: TObject; RequestHeader: TStringList;
                            Const Params: TDWParams; Var ContentType: String;
                            Var Result: String; Const RequestType: TRequestType;
                            Var StatusCode: Integer; Var ErrorMessage: String;
                            Var OutCustomHeader : TStringList);
procedure EditarRemessa(Sender: TObject; RequestHeader: TStringList;
                            Const Params: TDWParams; Var ContentType: String;
                            Var Result: String; Const RequestType: TRequestType;
                            Var StatusCode: Integer; Var ErrorMessage: String;
                            Var OutCustomHeader : TStringList);
procedure ExcluirRemessa(Sender: TObject; RequestHeader: TStringList;
                            Const Params: TDWParams; Var ContentType: String;
                            Var Result: String; Const RequestType: TRequestType;
                            Var StatusCode: Integer; Var ErrorMessage: String;
                            Var OutCustomHeader : TStringList);
procedure AlterarStatusRemessa(Sender: TObject; RequestHeader: TStringList;
                            Const Params: TDWParams; Var ContentType: String;
                            Var Result: String; Const RequestType: TRequestType;
                            Var StatusCode: Integer; Var ErrorMessage: String;
                            Var OutCustomHeader : TStringList);
procedure RotasRemessas(Sender: TObject; RequestHeader: TStringList;
                            Const Params: TDWParams; Var ContentType: String;
                            Var Result: String; Const RequestType: TRequestType;
                            Var StatusCode: Integer; Var ErrorMessage: String;
                            Var OutCustomHeader : TStringList);

implementation

procedure RotasRemessas(Sender: TObject; RequestHeader: TStringList;
                            Const Params: TDWParams; Var ContentType: String;
                            Var Result: String; Const RequestType: TRequestType;
                            Var StatusCode: Integer; Var ErrorMessage: String;
                            Var OutCustomHeader : TStringList);
begin
    case RequestType of
        rtGet: ListarMinhasRemessas(Sender, RequestHeader, Params, ContentType, Result,
                                    RequestType, StatusCode, ErrorMessage, OutCustomHeader);

        rtPut: EditarRemessa(Sender, RequestHeader, Params, ContentType, Result,
                             RequestType, StatusCode, ErrorMessage, OutCustomHeader);

        rtPost: CadastrarRemessa(Sender, RequestHeader, Params, ContentType, Result,
                                 RequestType, StatusCode, ErrorMessage, OutCustomHeader);

        rtDelete: ExcluirRemessa(Sender, RequestHeader, Params, ContentType, Result,
                                 RequestType, StatusCode, ErrorMessage, OutCustomHeader);
    end;
end;

procedure RegistrarRotas(RestDWServerQuickX: TRESTDWServerQXID);
begin
    with RestDWServerQuickX do
    begin
        AddUrl('remessas/disponivel', [crGet], ListarEntregasDisponiveis, true);
        AddUrl('remessas/historico', [crGet], ListarHistorico, true);
        AddUrl('remessas/status', [crPut], AlterarStatusRemessa, true);
        AddUrl('remessas', [crGet, crPost, crPut, crDelete], RotasRemessas, true);
    end;
end;

procedure ListarMinhasRemessas(Sender: TObject; RequestHeader: TStringList;
                            Const Params: TDWParams; Var ContentType: String;
                            Var Result: String; Const RequestType: TRequestType;
                            Var StatusCode: Integer; Var ErrorMessage: String;
                            Var OutCustomHeader : TStringList);
var
    rem: TRemessa;
    jsonArray: TJSONArray;
begin
    try
        try
            rem := TRemessa.Create(DmGlobal.conn);

            try
                rem.ID_REMESSA := Params.ItemsString['0'].AsInteger;
            except
                rem.ID_REMESSA := 0;
            end;

            try
                rem.ID_USUARIO := Params.ItemsString['id_usuario'].AsInteger;
            except
                rem.ID_USUARIO := 0;
            end;

            try
                rem.STATUS := Params.ItemsString['status'].AsString;
            except
                rem.STATUS := '';
            end;

            jsonArray := rem.ListarMinhasRemessas;
            Result := jsonArray.ToJSON;
            jsonArray.DisposeOf;

            StatusCode := 200;

        except on ex:exception do
            begin
                Result := ex.message;
                StatusCode := 500;
            end;
        end;
    finally
        rem.DisposeOf;
    end;
end;

procedure ListarEntregasDisponiveis(Sender: TObject; RequestHeader: TStringList;
                            Const Params: TDWParams; Var ContentType: String;
                            Var Result: String; Const RequestType: TRequestType;
                            Var StatusCode: Integer; Var ErrorMessage: String;
                            Var OutCustomHeader : TStringList);
var
    rem: TRemessa;
    jsonArray: TJSONArray;
begin
    try
        try
            rem := TRemessa.Create(DmGlobal.conn);

            try
                rem.ID_USUARIO := Params.ItemsString['id_usuario'].AsInteger;
            except
                rem.ID_USUARIO := 0;
            end;

            jsonArray := rem.ListarRemessasDisponiveis;
            Result := jsonArray.ToJSON;
            jsonArray.DisposeOf;

            StatusCode := 200;

        except on ex:exception do
            begin
                Result := ex.message;
                StatusCode := 500;
            end;
        end;
    finally
        rem.DisposeOf;
    end;
end;

procedure ListarHistorico(Sender: TObject; RequestHeader: TStringList;
                            Const Params: TDWParams; Var ContentType: String;
                            Var Result: String; Const RequestType: TRequestType;
                            Var StatusCode: Integer; Var ErrorMessage: String;
                            Var OutCustomHeader : TStringList);
var
    rem: TRemessa;
    jsonArray: TJSONArray;
begin
    try
        try
            rem := TRemessa.Create(DmGlobal.conn);

            try
                rem.ID_USUARIO := Params.ItemsString['id_usuario'].AsInteger;
            except
                rem.ID_USUARIO := 0;
            end;

            jsonArray := rem.ListarHistorico;
            Result := jsonArray.ToJSON;
            jsonArray.DisposeOf;

            StatusCode := 200;

        except on ex:exception do
            begin
                Result := ex.message;
                StatusCode := 500;
            end;
        end;
    finally
        rem.DisposeOf;
    end;
end;

procedure CadastrarRemessa(Sender: TObject; RequestHeader: TStringList;
                            Const Params: TDWParams; Var ContentType: String;
                            Var Result: String; Const RequestType: TRequestType;
                            Var StatusCode: Integer; Var ErrorMessage: String;
                            Var OutCustomHeader : TStringList);
var
    rem: TRemessa;
    body: System.JSON.TJSONValue;
    json: TJSONObject;
begin
    try
        try
            rem := TRemessa.Create(DmGlobal.conn);

            body := ParseBody(Params.RawBody.AsString);
            rem.DESCRICAO := body.GetValue<string>('descricao', '');
            rem.ORIGEM := body.GetValue<string>('origem', '');
            rem.DESTINO := body.GetValue<string>('destino', '');
            rem.VALOR := body.GetValue<double>('valor', 0);
            rem.ORIGEM_LATITUDE := body.GetValue<double>('origem_latitude', 0);
            rem.ORIGEM_LONGITUDE := body.GetValue<double>('origem_longitude', 0);
            rem.ID_USUARIO := body.GetValue<integer>('id_usuario', 0);
            body.DisposeOf;

            rem.Inserir;

            // Montar json de retorno...
            json := TJSONObject.Create;
            json.AddPair('id_remessa', TJSONNumber.Create(rem.ID_REMESSA));

            Result := json.ToJSON;
            StatusCode := 201;

            json.Free;

        except on ex:exception do
            begin
                Result := ex.message;
                StatusCode := 500;
            end;
        end;
    finally
        rem.DisposeOf;
    end;
end;

procedure EditarRemessa(Sender: TObject; RequestHeader: TStringList;
                            Const Params: TDWParams; Var ContentType: String;
                            Var Result: String; Const RequestType: TRequestType;
                            Var StatusCode: Integer; Var ErrorMessage: String;
                            Var OutCustomHeader : TStringList);
var
    rem: TRemessa;
    body: System.JSON.TJSONValue;
    json: TJSONObject;
begin
    try
        try
            rem := TRemessa.Create(DmGlobal.conn);

            try
                rem.ID_REMESSA := Params.ItemsString['0'].AsInteger;
            except
                rem.ID_REMESSA := 0;
            end;

            body := ParseBody(Params.RawBody.AsString);
            rem.DESCRICAO := body.GetValue<string>('descricao', '');
            rem.ORIGEM := body.GetValue<string>('origem', '');
            rem.DESTINO := body.GetValue<string>('destino', '');
            rem.VALOR := body.GetValue<double>('valor', 0);
            rem.ORIGEM_LATITUDE := body.GetValue<double>('origem_latitude', 0);
            rem.ORIGEM_LONGITUDE := body.GetValue<double>('origem_longitude', 0);

            rem.Editar;

            // Montar json de retorno...
            json := TJSONObject.Create;
            json.AddPair('id_remessa', TJSONNumber.Create(rem.ID_REMESSA));

            Result := json.ToJSON;
            StatusCode := 200;

            json.Free;

        except on ex:exception do
            begin
                Result := ex.message;
                StatusCode := 500;
            end;
        end;
    finally
        rem.DisposeOf;
    end;
end;

procedure ExcluirRemessa(Sender: TObject; RequestHeader: TStringList;
                            Const Params: TDWParams; Var ContentType: String;
                            Var Result: String; Const RequestType: TRequestType;
                            Var StatusCode: Integer; Var ErrorMessage: String;
                            Var OutCustomHeader : TStringList);
var
    rem: TRemessa;
    json: TJSONObject;
begin
    try
        try
            rem := TRemessa.Create(DmGlobal.conn);

            try
                rem.ID_REMESSA := Params.ItemsString['0'].AsInteger;
            except
                rem.ID_REMESSA := 0;
            end;

            rem.Excluir;

            // Montar json de retorno...
            json := TJSONObject.Create;
            json.AddPair('id_remessa', TJSONNumber.Create(rem.ID_REMESSA));

            Result := json.ToJSON;
            StatusCode := 200;

            json.Free;

        except on ex:exception do
            begin
                Result := ex.message;
                StatusCode := 500;
            end;
        end;
    finally
        rem.DisposeOf;
    end;
end;

procedure AlterarStatusRemessa(Sender: TObject; RequestHeader: TStringList;
                            Const Params: TDWParams; Var ContentType: String;
                            Var Result: String; Const RequestType: TRequestType;
                            Var StatusCode: Integer; Var ErrorMessage: String;
                            Var OutCustomHeader : TStringList);
var
    rem: TRemessa;
    body: System.JSON.TJSONValue;
    json: TJSONObject;
begin
    try
        try
            rem := TRemessa.Create(DmGlobal.conn);

            try
                rem.ID_REMESSA := Params.ItemsString['0'].AsInteger;
            except
                rem.ID_REMESSA := 0;
            end;

            body := ParseBody(Params.RawBody.AsString);
            rem.ID_ENTREGADOR := body.GetValue<integer>('id_entregador', 0);
            rem.STATUS := body.GetValue<string>('status', '');
            body.DisposeOf;

            if rem.STATUS = 'P' then
                rem.CancelarColetarRemessa
            else
            if rem.STATUS = 'E' then
                rem.ColetarRemessa
            else
            if rem.STATUS = 'F' then
                rem.FinalizarEntrega
            else
                raise Exception.Create('Status inválido');

            // Montar json de retorno...
            json := TJSONObject.Create;
            json.AddPair('id_remessa', TJSONNumber.Create(rem.ID_REMESSA));

            Result := json.ToJSON;
            StatusCode := 200;

            json.Free;

        except on ex:exception do
            begin
                Result := ex.message;
                StatusCode := 500;
            end;
        end;
    finally
        rem.DisposeOf;
    end;
end;

end.
