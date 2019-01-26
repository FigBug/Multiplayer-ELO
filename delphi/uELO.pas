unit uELO;

interface

uses
  SysUtils, System.Generics.Collections;

type
  EELOException = class(Exception);

  TELOPlayer = class
  private
    FName: string;
    FEloChange: integer;
    FEloPost: integer;
    FEloPre: integer;
    FPlace: integer;
    FId: integer;
  public
    property Id: integer read FId write FId;
    property Name: string read FName write FName;
    property Place: integer read FPlace write FPlace;
    property EloPre: integer read FEloPre write FEloPre;
    property EloPost: integer read FEloPost write FEloPost;
    property EloChange: integer read FEloChange write FEloChange;

    constructor Create(const AId: integer; const AName: string; const APlace, AELO: integer); virtual;
  end;

  TELOMatch = class
  private
    FErrorOnWrongNames: boolean;
    FPlayers: TObjectList<TELOPlayer>;
    function FindPlayer(const AName: string): TELOPlayer; overload;
    function FindPlayer(const AId: integer): TELOPlayer; overload;
  public
    constructor Create(AErrorOnWrongNames: boolean = false); virtual;
    destructor Destroy; override;

    procedure AddPlayer(const AId: integer; const AName: string; const APlace, AELO: integer);
    function GetElo(const AName: string): integer; overload;
    function GetElo(const AId: integer): integer; overload;
    function GetEloChange(const AName: string): integer; overload;
    function GetEloChange(const AId: integer): integer; overload;
    procedure CalculateELOs;

    property Players: TObjectList<TELOPlayer> read FPlayers;
  end;

implementation

uses
  Math;

{ TELOMatch }

procedure TELOMatch.AddPlayer(const AId: integer; const AName: string; const APlace, AELO: integer);
begin
  if (AName <> '') and (FindPlayer(AName) <> nil) then
  begin
    if FErrorOnWrongNames then
    begin
      raise EELOException.CreateFmt('Player with name %s already exists', [AName]);
    end;
  end
  else if (AId <> -1) and (FindPlayer(AId) <> nil) then
  begin
    if FErrorOnWrongNames then
    begin
      raise EELOException.CreateFmt('Player with id %d already exists', [AId]);
    end;
  end
  else
  begin
    FPlayers.Add(TELOPlayer.Create(AId, AName, APlace, AELO));
  end;
end;

procedure TELOMatch.CalculateELOs;
var
  LPlayerCount: integer;
  LChangeFactor: double;

  i,j: integer;
  LCurPlace, LCurELO: integer;
  LOpponentPlace, LOpponentELO: integer;
  LWinfactor, LEA: double;
begin
  LPlayerCount := FPlayers.Count;
  if LPlayerCount > 1 then
  begin
    LChangeFactor := 32 / (LPlayerCount - 1);

    for i := 0 to LPlayerCount -1 do
    begin
      LCurPlace := FPlayers[i].Place;
      LCurELO := FPlayers[i].EloPre;

      for j := 0 to LPlayerCount -1 do
      begin
        if (i <> j) then
        begin
          LOpponentPlace := FPlayers[j].Place;
          LOpponentELO := FPlayers[j].EloPre;

          if (LCurPlace < LOpponentPlace) then
          begin
            LWinfactor := 1.0;
          end
          else if (LCurPlace = LOpponentPlace) then
          begin
            LWinfactor := 0.5;
          end
          else
          begin
            LWinfactor := 0.0;
          end;

          //work out EA
          LEA := 1 / (1.0 + Math.Power(10, (LOpponentELO - LCurELO) / 400));

          // calculate ELO change vs this one opponent, add it to our change bucket
          // I currently round at this point, this keeps rounding changes
          // symetrical between EA and EB, but changes K more than it should
          FPlayers[i].EloChange := FPlayers[i].EloChange + Round(LChangeFactor * (LWinfactor - LEA));
         end;
      end;

      //add accumulated change to initial ELO for final ELO
      FPlayers[i].EloPost := FPlayers[i].EloPre + FPlayers[i].EloChange;
    end;
  end;
end;

constructor TELOMatch.Create(AErrorOnWrongNames: boolean = false);
begin
  inherited Create;
  FErrorOnWrongNames := AErrorOnWrongNames;
  FPlayers := TObjectList<TELOPlayer>.Create;
end;

destructor TELOMatch.Destroy;
begin
  FPlayers.Free;
end;

function TELOMatch.FindPlayer(const AId: integer): TELOPlayer;
var
  LPlayer: TELOPlayer;
begin
  Result := nil;
  for LPlayer in FPlayers do
    if LPlayer.Id = AId then
      Result := LPlayer;
end;

function TELOMatch.FindPlayer(const AName: string): TELOPlayer;
var
  LPlayer: TELOPlayer;
begin
  Result := nil;
  for LPlayer in FPlayers do
    if SameText(LPlayer.Name, AName) then
      Result := LPlayer;
end;

function TELOMatch.GetElo(const AName: string): integer;
var
  LPlayer: TELOPlayer;
begin
  LPlayer := FindPlayer(AName);
  if not Assigned(LPlayer) then
  begin
    if FErrorOnWrongNames then
    begin
      raise EELOException.CreateFmt('Player with name %s does not exists', [AName]);
    end
    else
    begin
      Result := 1500;
    end;
  end;
  Result := LPlayer.EloPost;
end;

function TELOMatch.GetEloChange(const AName: string): integer;
var
  LPlayer: TELOPlayer;
begin
  LPlayer := FindPlayer(AName);
  begin
    if FErrorOnWrongNames then
    begin
      raise EELOException.CreateFmt('Player with name %s does not exists', [AName]);
    end
    else
    begin
      Result := 0;
    end;
  end;
  Result := LPlayer.EloChange;
end;

function TELOMatch.GetElo(const AId: integer): integer;
var
  LPlayer: TELOPlayer;
begin
  LPlayer := FindPlayer(AId);
  if not Assigned(LPlayer) then
  begin
    if FErrorOnWrongNames then
    begin
      raise EELOException.CreateFmt('Player with id %d does not exists', [AId]);
    end
    else
    begin
      Result := 1500;
    end;
  end;
  Result := LPlayer.EloPost;
end;

function TELOMatch.GetEloChange(const AId: integer): integer;
var
  LPlayer: TELOPlayer;
begin
  LPlayer := FindPlayer(AId);
  begin
    if FErrorOnWrongNames then
    begin
      raise EELOException.CreateFmt('Player with id %d does not exists', [AId]);
    end
    else
    begin
      Result := 0;
    end;
  end;
  Result := LPlayer.EloChange;
end;

{ TELOPlayer }

constructor TELOPlayer.Create(const AId: integer; const AName: string; const APlace, AELO: integer);
begin
  inherited Create;
  FId := AId;
  FName := AName;
  FEloChange := 0;
  FEloPost := 0;
  FEloPre := AELO;
  FPlace := APlace;
end;

end.
