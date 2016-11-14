#include <QApplication>
#include <QQmlApplicationEngine>
#include <QWidget>
#include <QIcon>
#include <QQmlContext>
#include "user.h"
#include "company.h"
#include "src/SmtpMime"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    if (qApp->devicePixelRatio() >= 2) { // Retina display
        qApp->setAttribute(Qt::AA_UseHighDpiPixmaps);
    }

    //app.setWindowIcon(QIcon(("../Resources/icon.svg"))); // Set application icon

    QQmlApplicationEngine engine;

    QQmlContext* rootContext = engine.rootContext();

    User user;
    rootContext->setContextProperty("userClass",&user);

    Company company;
    rootContext->setContextProperty("companyClass",&company);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
