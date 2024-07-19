unit Google.Model.Analytics.Login;

interface

uses
  Google.Model.Analytics.Interfaces,
  Google.Controller.Analytics.Interfaces;

type
  TModelGoogleAnalyticsLogin = Class(TInterfacedObject, iModelGoogleLogin, iCommand)
  private
    [weak]
    FParent: iControllerGoogleAnalytics;
    FMethod: String;
  public
    constructor Create(AParent: iControllerGoogleAnalytics);
    destructor Destroy; override;
    class function New(AParent: iControllerGoogleAnalytics): iModelGoogleLogin;

    // iModelGoogleLogin
    function Method: String; overload;
    function Method(Value: String): iModelGoogleLogin; overload;
    function Send: iCommand;

    // iCommand
    function Execute: iCommand;
  End;

implementation

uses
  System.Net.HttpClientComponent, System.Classes, System.SysUtils,
  System.StrUtils, System.JSON, Winapi.Windows;

{ TModelGoogleAnalyticsException }

constructor TModelGoogleAnalyticsLogin.Create(
  AParent: iControllerGoogleAnalytics);
begin
  FParent := AParent;
end;

destructor TModelGoogleAnalyticsLogin.Destroy;
begin

  inherited;
end;

function TModelGoogleAnalyticsLogin.Execute: iCommand;
var
  HTTPClient: TNetHTTPClient;
  JSONObj: TJSONObject;
  JSONUserData: TJSONObject;
  JSONEvent: TJSONObject;
  JSONParams: TJSONObject;
  JSONArray: TJSONArray;
  JSON: TStringStream;
begin
  Result := Self;
  JSON := nil;
  HTTPClient := TNetHTTPClient.Create(nil);
  try
    JSONObj := TJSONObject.Create;

    JSONObj.AddPair('client_id', FParent.ClienteID);

    if FParent.UserID <> '' then
      JSONObj.AddPair('user_id', FParent.UserID);

    // JSONObj.AddPair('non_personalized_ads', 'false');

    (* Event *)
    JSONEvent := TJSONObject.Create;
    JSONEvent.AddPair('name', 'login');
    JSONParams := TJSONObject.Create;
    JSONParams.AddPair('method', FMethod);
    JSONParams.AddPair('app_name', Format('%s %s', [FParent.AppInfo.AppName, FParent.AppInfo.AppVersion]));
    JSONEvent.AddPair('params', JSONParams);

    JSONArray := TJSONArray.Create;
    JSONArray.Add(JSONEvent);
    JSONObj.AddPair('events', JSONArray);


    try
      JSON := TStringStream.Create(JSONObj.ToString, TEncoding.UTF8);
      OutputDebugString(PWideChar(JSONObj.ToString));

      HTTPClient.ContentType := 'application/json';
      HTTPClient.AcceptEncoding := 'utf-8';
      var
      status := HTTPClient.Post(FParent.URL, JSON);

      OutputDebugString(PWideChar(status.StatusCode.ToString));
      OutputDebugString(PWideChar(status.ContentAsString(TEncoding.UTF8)));
    except
    end;
  finally
    HTTPClient.Free;
    JSONObj.Free;
    if Assigned(JSON) then
      JSON.Free;
  end;

end;

function TModelGoogleAnalyticsLogin.Method: String;
begin
  Result := FMethod;
end;

function TModelGoogleAnalyticsLogin.Method(
  Value: String): iModelGoogleLogin;
begin
  Result := Self;

  FMethod := Value;
end;

class function TModelGoogleAnalyticsLogin.New(
  AParent: iControllerGoogleAnalytics): iModelGoogleLogin;
begin
  Result := Self.Create(AParent);
end;

function TModelGoogleAnalyticsLogin.Send: iCommand;
begin
  Result := Self;
end;

end.
