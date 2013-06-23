#ifndef RS232VISUALIZERMAIN_H
#define RS232VISUALIZERMAIN_H

#include <QtWidgets/QApplication>
#include <QtQml>
#include <QtQuick/QQuickView>
#include <QIcon>
#include <QObject>
#include "serialconnect.h"

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

public slots:

private:
 //   int setSerial(QString portName = "/dev/ttyUSB0", QString baud = "1200", QString bit = "8", QString parity ="n", QString stop = "1");
    SerialConnect* serialPort;
//    bool serPortStatus;
    int startGUI();
    void startSerialPort();
    void connectionsGUIserial();

private slots:
//    void destroySerialPort();
//    void newSerialPortSet(QString);

};

#endif // RS232VISUALIZERMAIN_H
