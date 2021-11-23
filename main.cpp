#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "MoveHandler.h"

#ifdef Q_OS_ANDROID
#include <QtAndroid>

//"android.permission.WRITE_SETTINGS"
//"android.permission.ACCESS_FINE_LOCATION"
//"android.permission.ACCESS_BACKGROUND_LOCATION"

const QVector<QString> permissions({"android.permission.ACCESS_COARSE_LOCATION",
                                   "android.permission.ACCESS_FINE_LOCATION"});
#endif

int main(int argc, char *argv[])
{

#if defined (Q_OS_ANDROID)
    //Request requiered permissions at runtime
    for(const QString &permission : permissions){
        auto result = QtAndroid::checkPermission(permission);
        if(result == QtAndroid::PermissionResult::Denied){
            auto resultHash = QtAndroid::requestPermissionsSync(QStringList({permission}));
            if(resultHash[permission] == QtAndroid::PermissionResult::Denied)
                return 0;
        }
    }
#endif
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QQmlContext* pCtx=engine.rootContext();
    MoveHandler* pMoveHandler=new MoveHandler;
    pCtx->setContextProperty("moveHandler", pMoveHandler);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
