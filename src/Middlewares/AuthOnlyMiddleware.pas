(*!------------------------------------------------------------
 * Fano Web Framework Skeleton Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-session
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-app-middleware/blob/master/LICENSE (GPL 3.0)
 *------------------------------------------------------------- *)
unit AuthOnlyMiddleware;

interface

uses

    fano;

type

    (*!------------------------------------------------
     * middleware implementation that pass request ony if user
     * is signed in
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAuthOnlyMiddleware = class(TInterfacedObject, IMiddleware, IDependency)
    private
        fSession : ISessionManager;
        fTargetUrlRedirect : string;
    public
        constructor create(const session : ISessionManager; const redirectUrl : string);
        destructor destroy(); override;

        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            var canContinue : boolean
        ) : IResponse;
    end;

implementation

    constructor TAuthOnlyMiddleware.create(const session : ISessionManager; const redirectUrl : string);
    begin
        inherited create();
        fSession := session;
        fTargetUrlRedirect := redirectUrl;
    end;

    destructor TAuthOnlyMiddleware.destroy();
    begin
        fSession := nil;
        inherited destroy();
    end;

    function TAuthOnlyMiddleware.handleRequest(
          const request : IRequest;
          const response : IResponse;
          var canContinue : boolean
    ) : IResponse;
    var sess : ISession;
    begin
        sess := fSession.beginSession(request, 3600);
        canContinue := sess.has('userSignedIn');
        if (canContinue) then
        begin
            writeln('can continue');
            result := response;
        end else
        begin
            writeln('cannot continue');
            result := TRedirectResponse.create(
                response.headers(),
                fTargetUrlRedirect
            );
        end;
    end;

end.
