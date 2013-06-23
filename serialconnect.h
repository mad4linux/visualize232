#ifndef SERIALCONNECT_H
#define SERIALCONNECT_H

#include <QObject>
#include <QtSerialPort/QSerialPort>
#include <QVariant>


class SerialConnect : public QObject
{
    Q_OBJECT
public:
    explicit SerialConnect(QObject *parent = 0);

signals:
    void sendStatusText(QVariant);
    void sendAvailablePort(QVariant);
    void clearPortsList();
    void newData(QVariant);
    void opened();
    
public slots:
    void open();
    void close();
    void write(QString);
    void write(const QByteArray&);
    void read();

    void getBaudSettings(qint32);
    void getBitSettings(qint8);
    void getParitySettings(qint8);
    void getStopbitsSettings(qint8);
    void getFlowcontrolSettings(qint8);
    void getPortSettings(QString);
    void getBaudSettings(QString);
    void getBitSettings(QString);
    void getParitySettings(QString);
    void getStopbitsSettings(QString);
    void getFlowcontrolSettings(QString);

    void storeSerialSettings(qint32, QSerialPort::Directions);
    void storeSerialSettings(QSerialPort::DataBits);
    void storeSerialSettings(QSerialPort::Parity);
    void storeSerialSettings(QSerialPort::StopBits);
    void storeSerialSettings(QSerialPort::FlowControl);

    void findAvailablePorts(bool);

private:
    QSerialPort *serial;
    QStringList *availablePortsList;
    void connectSerialPort();
    struct set {
        QString name;
        qint32 baudRate;
        QString stringBaudRate;
        QSerialPort::DataBits dataBits;
        QString stringDataBits;
        QSerialPort::Parity parity;
        QString stringParity;
        QSerialPort::StopBits stopBits;
        QString stringStopBits;
        QSerialPort::FlowControl flowControl;
        QString stringFlowControl;
        bool localEchoEnabled;
    };

    set currentSettings;

};

#endif // SERIALCONNECT_H
