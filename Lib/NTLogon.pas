unit NTLogon;

interface
uses Windows, SysUtils;

// Prototype
// function LogonUser(const UserName, Domain, Password: string): boolean;
function CheckWindowsPassword(passwd: String): boolean;

// -------------------------------------------------------------------------
implementation

type
  // Secur32.dll function prototypes
  TQueryPackageInfo = function(PackageName: PChar;
    var PackageInfo: pointer): integer; stdcall;

  TFreeContextBuffer = function(pBuffer: pointer): integer; stdcall;

  TFreeCredentialsHandle = function(var hCred: Int64): integer; stdcall;

  TDeleteSecurityContext = function(var hCred: Int64): integer; stdcall;

  TAcquireCredentialsHandle = function(pszPrincipal: PChar;
    pszPackage: PChar;
    fCredentialUse: DWORD;
    pvLogonID: DWORD;
    pAuthData: pointer;
    pGetKeyFn: DWORD;
    pvGetKeyArgument: pointer;
    var phCredential: Int64;
    var ptsExpiry: DWORD): integer; stdcall;

  TInitializeSecurityContext = function(var phCredential: Int64;
    phContext: pointer;
    pszTargetName: PChar;
    fContextReq: DWORD;
    Reserved1: DWORD;
    TargetDataRep: DWORD;
    pInput: pointer;
    Reserved2: DWORD;
    var phNewContext: Int64;
    pOutput: pointer;
    var pfContextAttr: Int64;
    var ptsExpiry: DWORD): integer; stdcall;

  TAcceptSecurityContext = function(var phCredential: Int64;
    phContext: pointer;
    pInput: pointer;
    fContextReq: DWORD;
    TargetDataRep: DWORD;
    var phNewContext: Int64;
    pOutput: pointer;
    var pfContextAttr: Int64;
    var ptsExpiry: DWORD): integer; stdcall;

  // AcquireCredentialsHandle() Internal Structure
  PAuthIdentity = ^TAuthIdentity;
  TAuthIdentity = packed record
    User: PChar;
    UserLength: DWORD;
    Domain: PChar;
    DomainLength: DWORD;
    Password: PChar;
    PasswordLength: DWORD;
    Flags: DWORD;
  end;

  // QuerySecurityPackageInfo Internal Structure
  PSecPkgInfo = ^TSecPkgInfo;
  TSecPkgInfo = packed record
    Capabilities: DWORD;
    Version: WORD;
    RPCID: WORD;
    MaxToken: DWORD;
    Name: PChar;
    Comment: PChar;
  end;

  // InitializeSecurityContext() Internal structure
  PSecBuffer = ^TSecBuffer;
  TSecBuffer = packed record
    cbBuffer: DWORD;
    BufferType: DWORD;
    pvBuffer: pointer;
  end;

  PSecBuffDesc = ^TSecBuffDesc;
  TSecBuffDesc = packed record
    ulVersion: DWORD;
    cBuffers: DWORD;
    pBuffers: PSecBuffer;
  end;

function WindowsAuth(user, domain, password: String): Boolean;
var
  hUser : THandle;
  res   : Boolean;
begin
   Result := LogonUser(PChar(user),
                    PChar(domain),
                    PChar(password),
                    LOGON32_LOGON_NETWORK,
                    LOGON32_PROVIDER_DEFAULT,
                    hUser);


    if hUser>0 then
      CloseHandle(hUser);
end;
{
function LogonUser(const UserName, Domain, Password: string): boolean;
var
  Retvar: boolean;
  FSecHandle: THandle;
  AuthIdentity: TAuthIdentity;
  pIdentity: PAuthIdentity;
  ContextAttr,
    hcTxt2, hCred2,
    hcTxt, hCred: Int64;
  pBuffer: pointer;
  E: integer;
  MaxToken,
    LifeTime: DWORD;
  InSecBuff, InSecBuff2,
    OutSecBuff, OutSecBuff2: TSecBuffer;
  InBuffDesc, InBuffDesc2,
    OutBuffDesc, OutBuffDesc2: TSecBuffDesc;
  pOut, pOut2,
    pBuffDesc, pBuffDesc2: pointer;
  FQueryPackageInfo: TQueryPackageInfo;
  FFreeContextBuffer: TFreeContextBuffer;
  FAcquireCredHandle: TAcquireCredentialsHandle;
  FFreeCredHandle: TFreeCredentialsHandle;
  FInitSecContext: TInitializeSecurityContext;
  FDelSecContext: TDeleteSecurityContext;
  FAcceptSecContext: TAcceptSecurityContext;
begin
  Retvar := false;
  FSecHandle := LoadLibrary('SECUR32.DLL');
  FQueryPackageInfo := nil;
  FFreeContextBuffer := nil;
  FAcquireCredHandle := nil;
  FFreeCredHandle := nil;
  FInitSecContext := nil;
  FDelSecContext := nil;
  FAcceptSecContext := nil;

  if FSecHandle <> 0 then
  begin
    @FQueryPackageInfo := GetProcAddress(FSecHandle, 'QuerySecurityPackageInfoW');
    @FFreeContextBuffer := GetProcAddress(FSecHandle, 'FreeContextBuffer');
    @FAcquireCredHandle := GetProcAddress(FSecHandle, 'AcquireCredentialsHandleW');
    @FInitSecContext := GetProcAddress(FSecHandle, 'InitializeSecurityContextW');
    @FFreeCredHandle := GetProcAddress(FSecHandle, 'FreeCredentialsHandle');
    @FDelSecContext := GetProcAddress(FSecHandle, 'DeleteSecurityContext');
    @FAcceptSecContext := GetProcAddress(FSecHandle, 'AcceptSecurityContext');
  end;

  if FSecHandle <> 0 then
  begin
    AuthIdentity.User := PChar(UserName);
    AuthIdentity.UserLength := length(UserName);
    AuthIdentity.Domain := PChar(Domain);
    AuthIdentity.DomainLength := length(Domain);
    AuthIdentity.Password := PChar(Password);
    AuthIdentity.PasswordLength := length(Password);
    AuthIdentity.Flags := 1; // SEC_WINNT_AUTH_IDENTITY_ANSI
    pIdentity := @AuthIdentity;

    if FQueryPackageInfo('NTLM', pBuffer) = NO_ERROR then
    begin
      MaxToken := PSecPkgInfo(pBuffer).MaxToken;
      FFreeContextBuffer(pBuffer);

      // Negotiate Client Initialisation
      if FAcquireCredHandle(nil, 'NTLM', 2, 0, pIdentity, 0,
        nil, hCred, LifeTime) = NO_ERROR then
      begin
        pOut := HeapAlloc(GetProcessHeap, 8, MaxToken);
        pOut2 := HeapAlloc(GetProcessHeap, 8, MaxToken);
        OutSecBuff.pvBuffer := pOut;
        OutSecBuff.cbBuffer := MaxToken;
        OutSecBuff.BufferType := 2; // SEC_BUFFER_TOKEN
        OutBuffDesc.ulVersion := 0;
        OutBuffDesc.cBuffers := 1;
        OutBuffDesc.pBuffers := @OutSecBuff;
        pBuffDesc := @OutBuffDesc;
        E := FInitSecContext(hCred, nil, 'AuthSamp', 0, 0, 16, nil, 0,
          hcTxt, pBuffDesc, ContextAttr, LifeTime);

        // Challenge
        if (E >= 0) and
          (FAcquireCredHandle(nil, 'NTLM', 1, 0, nil, 0,
          nil, hCred2, LifeTime) = NO_ERROR) then
        begin

          InSecBuff2.cbBuffer := OutSecBuff.cbBuffer;
          InSecBuff2.pvBuffer := OutSecBuff.pvBuffer;
          InSecBuff2.BufferType := 2; // SEC_BUFFER_TOKEN
          InBuffDesc2.ulVersion := 0;
          InBuffDesc2.cBuffers := 1;
          InBuffDesc2.pBuffers := @InSecBuff2;
          OutSecBuff2.cbBuffer := MaxToken;
          OutSecBuff2.pvBuffer := pOut2;
          OutSecBuff2.BufferType := 2; // SEC_BUFFER_TOKEN
          OutBuffDesc2.ulVersion := 0;
          OutBuffDesc2.cBuffers := 1;
          OutBuffDesc2.pBuffers := @OutSecBuff2;
          pBuffDesc := @InBuffDesc2;
          pBuffDesc2 := @OutBuffDesc2;

          E := FAcceptSecContext(hCred2, nil, pBuffDesc, 0, 16, hcTxt2, pBuffDesc2,
            ContextAttr, LifeTime);
          if E >= 0 then
          begin
            // Authenticate
            InSecBuff.cbBuffer := OutSecBuff2.cbBuffer;
            InSecBuff.pvBuffer := OutSecBuff2.pvBuffer;
            InSecBuff.BufferType := 2;
            InBuffDesc.ulVersion := 0;
            InBuffDesc.cBuffers := 1;
            InBuffDesc.pBuffers := @InSecBuff;
            OutSecBuff.cbBuffer := MaxToken;
            pBuffDesc := @InBuffDesc;
            pBuffDesc2 := @OutBuffDesc;
            E := FInitSecContext(hCred, @hcTxt, 'AuthSamp', 0, 0, 16, pBuffDesc, 0,
              hcTxt, pBuffDesc2, ContextAttr, LifeTime);

            if E >= 0 then
            begin
              InSecBuff2.cbBuffer := OutSecBuff.cbBuffer;
              InSecBuff2.pvBuffer := OutSecBuff.pvBuffer;
              OutSecBuff2.cbBuffer := MaxToken;
              pBuffDesc := @InBuffDesc2;
              pBuffDesc2 := @OutBuffDesc2;

              E := FAcceptSecContext(hCred2, @hcTxt2, pBuffDesc,
                0, 16, hcTxt2, pBuffDesc2,
                ContextAttr, LifeTime);

              Retvar := (E >= 0);
            end;
          end;

          FDelSecContext(hcTxt2);
          FFreeCredHandle(hCred2);
        end;

        FDelSecContext(hcTxt);
        FFreeCredHandle(hCred);
        HeapFree(GetProcessHeap, 0, pOut);
        HeapFree(GetProcessHeap, 0, pOut2);
      end;
    end;
  end;

  if FSecHandle <> 0 then
  try
    FreeLibrary(FSecHandle);
  except
  end;

  Result := Retvar;
end;
}

function CheckWindowsPassword(passwd: String): boolean;
var
  hToken: THandle;
  ptiUser: PSIDAndAttributes;
  cbti: DWORD;
  snu: SID_NAME_USE;
  user, domain: array [0..255] of char;
  luser, ldomain: DWORD;
begin
  ptiUser := nil;
  Result := false;

  luser := sizeof(user);
  ldomain := sizeof(domain);
  ZeroMemory(@user, luser);
  ZeroMemory(@domain, ldomain);

  try
    if (not OpenThreadToken(GetCurrentThread(), TOKEN_QUERY, TRUE,
          hToken)) then
    begin
       if (GetLastError() <> ERROR_NO_TOKEN) then
          exit;
       if (not OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY,
             hToken)) then
          exit;
    end;

    if (GetTokenInformation(hToken, TokenUser, nil, 0, cbti)) then
      exit
    else
      if (GetLastError() <> ERROR_INSUFFICIENT_BUFFER) then
        exit;

    ptiUser :=  HeapAlloc(GetProcessHeap(), 0, cbti);
    if (ptiUser = nil) then
      exit;

    if ( not GetTokenInformation(hToken, TokenUser, ptiUser, cbti, cbti)) then
      exit;

    if ( not LookupAccountSid(nil, ptiUser.Sid, @user,
    luser,
          @domain, ldomain, snu)) then
      exit;
    Result := WindowsAuth(user, domain, passwd);
  finally
    if (hToken > 0) then
       CloseHandle(hToken);

    if (ptiUser <> nil) then
       HeapFree(GetProcessHeap(), 0, ptiUser);
  end;
end;

end.
