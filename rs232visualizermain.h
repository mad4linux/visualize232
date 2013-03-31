#ifndef RS232VISUALIZERMAIN_H
#define RS232VISUALIZERMAIN_H

#include <QObject>
#include "SerialPortThread.h"

class RS232VisualizerMain : public QObject
{
    Q_OBJECT

public:
    explicit RS232VisualizerMain(QObject *parent = 0);
    virtual ~RS232VisualizerMain();

signals:
    void openSerialPort();
    void closeSerialPort();
    void threadStart();
    void threadStop();

public slots:
    void closeSerialPortThread();
    void openSerialPortThread();
    void setSerialThreadStatus(bool);

private:
    int createSerialPortThread(QString portName = "/dev/ttyUSB0", QString settings = "1200,8,n,1");
    SerialPortThread* mainSerialThread;
    bool serPortThreadStatus;

private slots:
    void destroySerialPortThread();
    void newSerialPortSet(QString);

};

#endif // RS232VISUALIZERMAIN_H
