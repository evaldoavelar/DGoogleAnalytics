unit Google.Model.Analytics.Exception;

interface

uses
  Google.Model.Analytics.Interfaces,
  Google.Controller.Analytics.Interfaces;

type
  TModelGoogleAnalyticsException = Class(TInterfacedObject, iModelGoogleException, iCommand)
  private
    [weak]
    FParent: iControllerGoogleAnalytics;
    FDescription: String;
    FisFatal: Boolean;
  public
    constructor Create(AParent: iControllerGoogleAnalytics);
    destructor Destroy; override;
    class function New(AParent: iControllerGoogleAnalytics): iModelGoogleException;

    // iModelGoogleException
    function Description: String; overload;
    function Description(Value: String): iModelGoogleException; overload;
    function isFatal: Boolean; overload;
    function isFatal(Value: Boolean): iModelGoogleException; overload;
    function Send: iCommand;

    // iCommand
    function Execute: iCommand;
  End;

implementation

{ TModelGoogleAnalyticsException }

uses
  System.Net.HttpClientComponent, System.Classes, System.SysUtils,
  System.StrUtils, System.JSON, Winapi.Windows;

constructor TModelGoogleAnalyticsException.Create(AParent: iControllerGoogleAnalytics);
begin
  FParent := AParent;
end;

function TModelGoogleAnalyticsException.Description: String;
begin
  Result := FDescription;
end;

function TModelGoogleAnalyticsException.Description(
  Value: String): iModelGoogleException;
begin
  Result := Self;

  FDescription := Value;
end;

destructor TModelGoogleAnalyticsException.Destroy;
begin

  inherited;
end;

function TModelGoogleAnalyticsException.Execute: iCommand;
var
  HTTPClient: TNetHTTPClient;
  JSONObj: TJSONObject;
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
    JSONEvent.AddPair('name', 'exception');
    JSONParams := TJSONObject.Create;
    JSONParams.AddPair('description', FDescription);
    JSONParams.AddPair('fatal', IfThen(FisFatal, '1', '0'));
    JSONParams.AddPair('app_name', Format('%s %s', [FParent.AppInfo.AppName, FParent.AppInfo.AppVersion]));
    JSONParams.AddPair('screen_resolution', FParent.ScreenResolution);
    JSONEvent.AddPair('params', JSONParams);

    JSONArray := TJSONArray.Create;
    JSONArray.Add(JSONEvent);
    JSONObj.AddPair('events', JSONArray);


    try
      JSON := TStringStream.Create(JSONObj.ToString, TEncoding.UTF8);
      //OutputDebugString(PWideChar(JSONObj.ToString));

      HTTPClient.ContentType := 'application/json';
      HTTPClient.AcceptEncoding := 'utf-8';
      var
      status := HTTPClient.Post(FParent.URL, JSON);

      //OutputDebugString(PWideChar(status.StatusCode.ToString));
      //OutputDebugString(PWideChar(status.ContentAsString(TEncoding.UTF8)));
    except
    end;
  finally
    HTTPClient.Free;
    JSONObj.Free;
    if Assigned(JSON) then
      JSON.Free;
  end;
end;

function TModelGoogleAnalyticsException.isFatal: Boolean;
begin
  Result := FisFatal;
end;

function TModelGoogleAnalyticsException.isFatal(
  Value: Boolean): iModelGoogleException;
begin
  Result := Self;

  FisFatal := Value;
end;

class function TModelGoogleAnalyticsException.New(AParent: iControllerGoogleAnalytics): iModelGoogleException;
begin
  Result := Self.Create(AParent);
end;

function TModelGoogleAnalyticsException.Send: iCommand;
begin
  Result := Self;
end;

end.
