unit Google.Model.Analytics.ScreenView;

interface

uses
  Google.Model.Analytics.Interfaces,
  Google.Controller.Analytics.Interfaces;

type
  TModelGoogleAnalyticsScreenView = Class(TInterfacedObject, iModelGoogleScreeView, iCommand)
  private
    [weak]
    FParent: iControllerGoogleAnalytics;
    FScreenName: String;
  public
    constructor Create(AParent: iControllerGoogleAnalytics);
    destructor Destroy; override;
    class function New(AParent: iControllerGoogleAnalytics): iModelGoogleScreeView;

    // iGoogleScreeView
    function ScreenName: String; overload;
    function ScreenName(Value: String): iModelGoogleScreeView; overload;
    function Send: iCommand;

    // iCommand
    function Execute: iCommand;
  End;

implementation

{ TModelGoogleAnalyticsScreenView }

uses
  System.Net.HttpClientComponent, System.Classes, System.SysUtils, System.JSON, Winapi.Windows;

constructor TModelGoogleAnalyticsScreenView.Create(AParent: iControllerGoogleAnalytics);
begin
  FParent := AParent;
end;

destructor TModelGoogleAnalyticsScreenView.Destroy;
begin

  inherited;
end;

function TModelGoogleAnalyticsScreenView.Execute: iCommand;
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

    JSONObj.AddPair('non_personalized_ads', 'false');

    (* Event *)
    JSONEvent := TJSONObject.Create;
    JSONEvent.AddPair('name', 'screen_view');
    JSONParams := TJSONObject.Create;
    JSONParams.AddPair('screen_name', FScreenName);
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

class function TModelGoogleAnalyticsScreenView.New(AParent: iControllerGoogleAnalytics): iModelGoogleScreeView;
begin
  Result := Self.Create(AParent);
end;

function TModelGoogleAnalyticsScreenView.ScreenName(
  Value: String): iModelGoogleScreeView;
begin
  Result := Self;

  FScreenName := Value;
end;

function TModelGoogleAnalyticsScreenView.Send: iCommand;
begin
  Result := Self;
end;

function TModelGoogleAnalyticsScreenView.ScreenName: String;
begin
  Result := FScreenName;
end;

end.
