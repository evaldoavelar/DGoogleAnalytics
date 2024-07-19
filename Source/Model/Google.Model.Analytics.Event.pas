unit Google.Model.Analytics.Event;

interface

uses
  Google.Model.Analytics.Interfaces,
  Google.Controller.Analytics.Interfaces;

type
  TModelGoogleAnalyticsEvent = Class(TInterfacedObject, iModelGoogleEvent, iCommand)
  private
    [weak]
    FParent: iControllerGoogleAnalytics;

    FCategory: String;
    FAction: String;
    FEventLabel: String;
    FEventValue: Integer;
  public
    constructor Create(AParent: iControllerGoogleAnalytics);
    destructor Destroy; override;
    class function New(AParent: iControllerGoogleAnalytics): iModelGoogleEvent;

    // iModelGoogleEvent
    function Category: String; overload;
    function Category(Value: String): iModelGoogleEvent; overload;
    function Action: String; overload;
    function Action(Value: String): iModelGoogleEvent; overload;
    function EventLabel: String; overload;
    function EventLabel(Value: String): iModelGoogleEvent; overload;
    function EventValue: Integer; overload;
    function EventValue(Value: Integer): iModelGoogleEvent; overload;
    function Send: iCommand;

    // iCommand
    function Execute: iCommand;
  End;

implementation

{ TModelGoogleAnalyticsEvent }

uses
  System.Net.HttpClientComponent, System.Classes, System.SysUtils, System.JSON, Winapi.Windows;

function TModelGoogleAnalyticsEvent.Action(Value: String): iModelGoogleEvent;
begin
  Result := Self;

  FAction := Value;
end;

function TModelGoogleAnalyticsEvent.Action: String;
begin
  Result := FAction;
end;

function TModelGoogleAnalyticsEvent.Category: String;
begin
  Result := FCategory;
end;

function TModelGoogleAnalyticsEvent.Category(Value: String): iModelGoogleEvent;
begin
  Result := Self;

  FCategory := Value;
end;

constructor TModelGoogleAnalyticsEvent.Create(AParent: iControllerGoogleAnalytics);
begin
  FParent := AParent;
end;

destructor TModelGoogleAnalyticsEvent.Destroy;
begin

  inherited;
end;

function TModelGoogleAnalyticsEvent.EventLabel(
  Value: String): iModelGoogleEvent;
begin
  Result := Self;

  FEventLabel := Value;
end;

function TModelGoogleAnalyticsEvent.EventLabel: String;
begin
  Result := FEventLabel;
end;

function TModelGoogleAnalyticsEvent.EventValue: Integer;
begin
  Result := FEventValue;
end;

function TModelGoogleAnalyticsEvent.EventValue(
  Value: Integer): iModelGoogleEvent;
begin
  Result := Self;

  FEventValue := Value;
end;

function TModelGoogleAnalyticsEvent.Execute: iCommand;
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
    JSONEvent.AddPair('name', FCategory);
    JSONParams := TJSONObject.Create;
    JSONParams.AddPair('action', FAction);
    JSONParams.AddPair(FEventLabel, FEventValue.ToString);
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

class function TModelGoogleAnalyticsEvent.New(AParent: iControllerGoogleAnalytics): iModelGoogleEvent;
begin
  Result := Self.Create(AParent);
end;

function TModelGoogleAnalyticsEvent.Send: iCommand;
begin
  Result := Self;
end;

end.
