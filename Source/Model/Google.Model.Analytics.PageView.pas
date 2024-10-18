unit Google.Model.Analytics.PageView;

interface

uses
  Google.Model.Analytics.Interfaces,
  Google.Controller.Analytics.Interfaces;

type
  TModelGoogleAnalyticsPageView = Class(TInterfacedObject, iModelGooglePageView, iCommand)
  private
    [weak]
    FParent: iControllerGoogleAnalytics;

    FHostName: String;
    FPage: String;
    FTitle: String;
  public
    constructor Create(AParent: iControllerGoogleAnalytics);
    destructor Destroy; override;
    class function New(AParent: iControllerGoogleAnalytics): iModelGooglePageView;

    // iModelGooglePageView
    function DocumentHostName: String; overload;
    function DocumentHostName(Value: String): iModelGooglePageView; overload;
    function Page: String; overload;
    function Page(Value: String): iModelGooglePageView; overload;
    function Title: String; overload;
    function Title(Value: String): iModelGooglePageView; overload;
    function Send: iCommand;

    // iCommand
    function Execute: iCommand;
  End;

implementation

{ TModelGoogleAnalyticsPageView }

uses
  System.Net.HttpClientComponent, System.Classes, System.SysUtils, System.JSON, Winapi.Windows;

constructor TModelGoogleAnalyticsPageView.Create(AParent: iControllerGoogleAnalytics);
begin
  FParent := AParent;
end;

destructor TModelGoogleAnalyticsPageView.Destroy;
begin

  inherited;
end;

function TModelGoogleAnalyticsPageView.Execute: iCommand;
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
    JSONEvent.AddPair('name', 'page_view');
    JSONParams := TJSONObject.Create;
    JSONParams.AddPair('screen_class', FPage);
    JSONParams.AddPair('screen_name', FTitle);
    JSONParams.AddPair('app_name', Format('%s %s', [FParent.AppInfo.AppName, FParent.AppInfo.AppVersion]));
    JSONParams.AddPair('screen_resolution', FParent.ScreenResolution);
    JSONEvent.AddPair('params', JSONParams);

    JSONArray := TJSONArray.Create;
    JSONArray.Add(JSONEvent);
    JSONObj.AddPair('events', JSONArray);

    try
      JSON := TStringStream.Create(JSONObj.ToString, TEncoding.UTF8);
      //OutputDebugString(PWideChar(JSONObj.ToString));
      //OutputDebugString(PWideChar(FParent.URL));

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

function TModelGoogleAnalyticsPageView.DocumentHostName: String;
begin
  Result := FHostName;
end;

function TModelGoogleAnalyticsPageView.DocumentHostName(
  Value: String): iModelGooglePageView;
begin
  Result := Self;

  FHostName := Value;
end;

class
  function TModelGoogleAnalyticsPageView.New(AParent: iControllerGoogleAnalytics): iModelGooglePageView;
begin
  Result := Self.Create(AParent);
end;

function TModelGoogleAnalyticsPageView.Page(
  Value: String): iModelGooglePageView;
begin
  Result := Self;

  FPage := Value;
end;

function TModelGoogleAnalyticsPageView.Page: String;
begin
  Result := FPage;
end;

function TModelGoogleAnalyticsPageView.Send: iCommand;
begin
  Result := Self;
end;

function TModelGoogleAnalyticsPageView.Title(
  Value: String): iModelGooglePageView;
begin
  Result := Self;

  FTitle := Value;
end;

function TModelGoogleAnalyticsPageView.Title: String;
begin
  Result := FTitle;
end;

end.
