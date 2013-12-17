#include <QtWidgets/QApplication>
#include <QtQml>
#include <QtQuick/QQuickView>
#include <QIcon>
#include "rs232visualizermain.h"



int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    RS232VisualizerMain mainObject;

    return app.exec();
}
