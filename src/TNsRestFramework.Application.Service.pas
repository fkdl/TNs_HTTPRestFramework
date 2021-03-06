unit TNsRestFramework.Application.Service;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$include synopse.inc}

interface

uses
{$IFnDEF FPC}
  System.SysUtils,
  System.Types,
{$ELSE}
  Sysutils,
  Types,
  syncobjs,
{$ENDIF}
{$IFNDEF MSWINDOWS}
  cthreads,
{$ENDIF}
  TNsRestFramework.Infrastructure.TaskFactory,
  TNsRestFramework.Infrastructure.HTTPServerFactory,
  TNsRestFramework.Infrastructure.HTTPControllerFactory,
  TNsRestFramework.Infrastructure.LoggerFactory;

type

  { TApplicationService }

  TApplicationService = class
    private
      class procedure AliveTask(Sender : TSynBackground; Event : TWaitResult; const Msg : TSynBackgroudString);
      class procedure InitBrokers;
      class procedure InitLogging;
      class procedure InitControllers;
      class procedure InitServer(ListeningPort : string);
      class procedure Log(const msg : string; errror : Boolean);
    public
      class procedure Init(ListeningPort : string);
      class procedure Stop;
  end;

implementation

{ TApplicationService }

class procedure TApplicationService.InitBrokers;
begin
  TTaskFactory.Init;
  //TTaskFactory.NewTask('Alive').Enable(AliveTask, 1);
  //Add background tasks if you need or use the factory instance
end;

class procedure TApplicationService.InitControllers;
begin
  THTTPControllerFactory.Init;
end;

class procedure TApplicationService.AliveTask(Sender: TSynBackground;
  Event: TWaitResult; const Msg: TSynBackgroudString);
begin
  Log('Application check... Is alive.', False);
end;

class procedure TApplicationService.Init(ListeningPort : string);
begin
  //Init
  InitLogging;
  InitBrokers;
  InitControllers;
  InitServer(ListeningPort);
end;

class procedure TApplicationService.InitLogging;
begin
  TLoggerFactory.Init;
  Log('TNs Publish Manager server init', False);
end;

class procedure TApplicationService.InitServer(ListeningPort : string);
begin
  THTTPServerFactory.Init(ListeningPort);
  THTTPServerFactory.GetCurrent.Start;
end;

class procedure TApplicationService.Log(const msg : string; errror: Boolean);
begin
  TLoggerFactory.GetInstance.Log(msg, errror);
end;

class procedure TApplicationService.Stop;
begin
  //TO-DO Stop Service
  Log('Service Stopped', False);
end;

end.
