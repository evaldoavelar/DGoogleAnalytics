unit Google.Model.Analytics.UserData;

interface

uses
  Google.Model.Analytics.Interfaces, System.JSON, System.Hash,
  Google.Controller.Analytics.Interfaces;

type
  TModelGoogleModelUserData = Class(TInterfacedObject, iModelUserData)
  private
    FUserDataCity: String;
    FUserDataFirstName: String;
    FUserDataPostalCode: String;
    FUserDataRegion: String;
    FUserDataCountry: String;
    FUserDataEmailAdrress: String;

  public
    constructor Create();
    destructor Destroy; override;
    class function New(): iModelUserData;

    function UserDataEmailAdrress: String; overload;
    function UserDataEmailAdrress(Value: String): iModelUserData; overload;
    function UserDataCity: String; overload;
    function UserDataCity(Value: String): iModelUserData; overload;
    function UserDataFirstName: String; overload;
    function UserDataFirstName(Value: String): iModelUserData; overload;
    function UserDataPostalCode: String; overload;
    function UserDataPostalCode(Value: String): iModelUserData; overload;
    function UserDataRegion: String; overload;
    function UserDataRegion(Value: String): iModelUserData; overload;
    function UserDataCountry: String; overload;
    function UserDataCountry(Value: String): iModelUserData; overload;
    function ToJson: TJsonObject;
  End;

implementation

function TModelGoogleModelUserData.UserDataCity: String;
begin
  result := FUserDataCity;
end;

function TModelGoogleModelUserData.ToJson: TJsonObject;
var
  LJSONAdress: TJsonObject;
begin
  result := TJsonObject.Create;
  if self.UserDataEmailAdrress <> '' then
    result.AddPair('sha256_email_address', self.UserDataEmailAdrress);

  LJSONAdress := TJsonObject.Create;
  if self.UserDataFirstName <> '' then
    LJSONAdress.AddPair('sha256_first_name', self.UserDataFirstName);
  if self.UserDataCity <> '' then
    LJSONAdress.AddPair('city', self.UserDataCity);
  if self.UserDataCountry <> '' then
    LJSONAdress.AddPair('country', self.UserDataCountry);
  if self.UserDataRegion <> '' then
    LJSONAdress.AddPair('region', self.UserDataRegion);
  if self.UserDataPostalCode <> '' then
    LJSONAdress.AddPair('postal_code', self.UserDataPostalCode);

  result.AddPair('address', LJSONAdress);
end;

function TModelGoogleModelUserData.UserDataCity(
  Value: String): iModelUserData;
begin
  result := self;

  FUserDataCity := Value;
end;

function TModelGoogleModelUserData.UserDataCountry: String;
begin
  result := FUserDataCountry;
end;

function TModelGoogleModelUserData.UserDataCountry(
  Value: String): iModelUserData;
begin
  result := self;

  FUserDataCountry := Value;
end;

function TModelGoogleModelUserData.UserDataEmailAdrress(
  Value: String): iModelUserData;
begin
  result := self;

  FUserDataEmailAdrress := THashSHA2.GetHashString(Value);
end;

function TModelGoogleModelUserData.UserDataEmailAdrress: String;
begin
  result := FUserDataEmailAdrress;
end;

function TModelGoogleModelUserData.UserDataFirstName(
  Value: String): iModelUserData;
begin
  result := self;

  FUserDataFirstName := THashSHA2.GetHashString(Value);
end;

function TModelGoogleModelUserData.UserDataFirstName: String;
begin
  result := FUserDataFirstName;
end;

function TModelGoogleModelUserData.UserDataPostalCode: String;
begin
  result := FUserDataPostalCode;
end;

function TModelGoogleModelUserData.UserDataPostalCode(
  Value: String): iModelUserData;
begin
  result := self;

  FUserDataPostalCode := Value;
end;

function TModelGoogleModelUserData.UserDataRegion: String;
begin
  result := FUserDataRegion;
end;

function TModelGoogleModelUserData.UserDataRegion(
  Value: String): iModelUserData;
begin
  result := self;

  FUserDataRegion := Value;
end;

constructor TModelGoogleModelUserData.Create;
begin

end;

destructor TModelGoogleModelUserData.Destroy;
begin

  inherited;
end;

class function TModelGoogleModelUserData.New(): iModelUserData;
begin
  result := self.Create();
end;

end.
