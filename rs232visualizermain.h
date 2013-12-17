#ifndef RS232VISUALIZERMAIN_H
#define RS232VISUALIZERMAIN_H

#include <QtWidgets/QApplication>
#include <QtQml>
#include <QtQuick/QQuickView>
#include <QIcon>
#include <QObject>
#include "serialconnect.h"
#include "appsettings.h"

class RS232VisualizerMain : public QObject
{
    Q_OBJECT

public:
    explicit RS232VisualizerMain(QObject *parent = 0);
    virtual ~RS232VisualizerMain();

    QQmlEngine *engine;
    QQmlComponent *component;
    QObject *topLevel;
    QQuickWindow *window;


signals:
    void openSerialPort();
    void closeSerialPort();
    void serialObjectChanged();

public slots:
 //   void aboutToQuit();

private:

    SerialConnect* serialPort;
    AppSettings* staticSettings;
    int startGUI();
    void startSerialPort();
    void connectionsGUIserial();
    void connectionsCore();
    void initializeSettings();

private slots:
//    void destroySerialPort();
//    void newSerialPortSet(QString);

};

#endif // RS232VISUALIZERMAIN_H
