#include "serialconnect.h"
#include <QtSerialPort/QSerialPort>
#include <QtSerialPort/QSerialPortInfo>
#include <QStringList>
#include <QVariant>
#include <QDebug>
#include <QTimerEvent>

SerialConnect::SerialConnect(QObject *parent) :
    QObject(parent)
{
    serial = new QSerialPort;
    connectSerialPort();
    availablePortsList.append("-");
}

void SerialConnect::connectSerialPort() {
    connect(serial, SIGNAL(baudRateChanged(qint32,QSerialPort::Directions)), this, SLOT(storeSerialSettings(qint32,QSerialPort::Directions)));
    connect(serial, SIGNAL(dataBitsChanged(QSerialPort::DataBits)), this, SLOT(storeSerialSettings(QSerialPort::DataBits)));
            connect(serial, SIGNAL(flowControlChanged(QSerialPort::FlowControl)), this, SLOT(storeSerialSettings(QSerialPort::FlowControl)));
            connect(serial, SIGNAL(parityChanged(QSerialPort::Parity)), this, SLOT(storeSerialSettings(QSerialPort::Parity)));
            connect(serial, SIGNAL(stopBitsChanged(QSerialPort::StopBits)), this, SLOT(storeSerialSettings(QSerialPort::StopBits)));
            connect(serial,SIGNAL(readyRead()), this, SLOT(read()));

}

/*********************************************
 *
 *    Signals are only declared in Header file
 *
 ********************************************/


/*********************************************
 *
 *    Slots
 *
 ********************************************/


void SerialConnect::open() {
  qDebug() << "serialConnect:open() slot called";
  QString statusTextTemp;

  if(serial->isOpen()) {
      statusTextTemp = "Serial port ";
      statusTextTemp.append(serial->portName());
      statusTextTemp.append(" is already open");
  }
  else {
      //settings("/dev/ttyACM0", 9600, 8, 0, 1, 0);
      //settings("/dev/ttyACM0", 1200);
      if (serial->open(QIODevice::ReadWrite)) {
          statusTextTemp = "Serial port opened: ";
          statusTextTemp.append(serial->portName());
          opened();
      }
      else {
          statusTextTemp = "Error opening serial port: ";
          statusTextTemp.append(serial->errorString() );
          statusTextTemp.append(" - port: ");
          statusTextTemp.append(serial->portName());
      }
  }
  sendStatusText( statusTextTemp );
  qDebug() << statusTextTemp;
}

void SerialConnect::close() {
    QString statusTextTemp;
    if(serial->isOpen()) {
        serial->close();
        statusTextTemp = "Serial port closed";
    }
    else {
        statusTextTemp = "No serial port open";
    }
    sendStatusText( statusTextTemp );
    qDebug() << statusTextTemp;
}

void SerialConnect::getPortSettings(QString port) {
    serial->setPortName(port);
}

void SerialConnect::write(const QString data) {
    QByteArray dataArray;
    dataArray.append(data);
    qint64 bytesWritten = serial->write(dataArray);
//    serial->write("\r");
    if (bytesWritten == (-1)) {
        qDebug() << "Error writing data to serial port: " << serial->errorString();
    }
    qDebug() << "SerialConnect::write(QString) Text received: " << data;
    qDebug() << "SerialConnect::write(QString) Text sent as QByteArray: " << dataArray;
    qDebug() << "Number of bytes written: " << bytesWritten;

}

void SerialConnect::write(const QByteArray &data) {
    qint64 bytesWritten = serial->write(data);
    if (bytesWritten == (-1)) {
        qDebug() << "Error writing data to serial port: " << serial->errorString();
    }
    qDebug() << "SerialConnect::write(QByteArray) Text received: " << data;
    qDebug() << "Number of bytes written: " << bytesWritten;

}

void SerialConnect::reduceReads() {
    if(timer.isActive()) {
        return;
    }
    else {
        timer.start(50, this);
    }

}

void SerialConnect::read() {
    newSerialDataString = serial->readAll();
    serialDataString.append(newSerialDataString);
    serialDataChanged();
//    qDebug() << "Data in QByteArray = " << newdata;
//    qDebug() << "Data in serialDataString = " << serialDataString;
}

void SerialConnect::getBaudSettings(qint32 baud) {
    if (!serial->setBaudRate(baud)) {
        qDebug() << "When setting baud rate: " << baud << " - error: " << serial->errorString();
    }
}

void SerialConnect::getBaudSettings(QString baud) {
    if (!serial->setBaudRate(baud.toInt())) {
        qDebug() << "When setting baud rate: " << baud.toInt() << " - error: " << serial->errorString();
    }
}

void SerialConnect::getBitSettings(qint8 bit) {
    if (!serial->setDataBits(static_cast<QSerialPort::DataBits>(bit))) {
        qDebug() << "When setting data bits: "  << bit << " - error: " << serial->errorString();
    }

}

void SerialConnect::getBitSettings(QString bit) {
    if (!serial->setDataBits(static_cast<QSerialPort::DataBits>(bit.toInt()))) {
        qDebug() << "When setting data bits: "  << bit.toInt() << " - error: " << serial->errorString();
    }
}

void SerialConnect::getParitySettings(qint8 parity) {
    if (!serial->setParity(static_cast<QSerialPort::Parity>(parity))) {
        qDebug() << "When setting parity: " <<  parity << " - error: " << serial->errorString();
    }
}

void SerialConnect::getParitySettings(QString parity) {
    if (!serial->setParity(static_cast<QSerialPort::Parity>(parity.toInt()))) {
        qDebug() << "When setting parity: " <<  parity.toInt() << " - error: " << serial->errorString();
    }
}

void SerialConnect::getStopbitsSettings(qint8 stopbits) {
    if (!serial->setStopBits(static_cast<QSerialPort::StopBits>(stopbits))) {
        qDebug() << "When setting stop bits: "  << stopbits << " - error: " << serial->errorString();
    }
}

void SerialConnect::getStopbitsSettings(QString stopbits) {
    if (!serial->setStopBits(static_cast<QSerialPort::StopBits>(stopbits.toInt()))) {
        qDebug() << "When setting stop bits: "  << stopbits.toInt() << " - error: " << serial->errorString();
    }
}

void SerialConnect::getFlowcontrolSettings(qint8 flowcontrol) {
    if (!serial->setFlowControl(static_cast<QSerialPort::FlowControl>(flowcontrol))) {
        qDebug() << "When setting flow control: "  << flowcontrol << " - error: " << serial->errorString();
    }
}

void SerialConnect::getFlowcontrolSettings(QString flowcontrol) {
    if (!serial->setFlowControl(static_cast<QSerialPort::FlowControl>(flowcontrol.toInt()))) {
        qDebug() << "When setting flow control: "  << flowcontrol.toInt() << " - error: " << serial->errorString();
    }
}

void SerialConnect::storeSerialSettings(qint32 baudRate, QSerialPort::Directions dir) {
    currentSettings.baudRate = baudRate;
    QString statusTextTemp;
    statusTextTemp = "Baud rate changed: ";
    statusTextTemp.append(QString("%1").arg(currentSettings.baudRate));
    sendStatusText( statusTextTemp );
    qDebug() << statusTextTemp;
}

void SerialConnect::storeSerialSettings(QSerialPort::DataBits dataBits) {
    currentSettings.dataBits = dataBits;
    QString statusTextTemp;
    statusTextTemp = "Data bits changed: ";
    statusTextTemp.append(QString("%1").arg(currentSettings.dataBits));
    sendStatusText( statusTextTemp );
    qDebug() << statusTextTemp;

}

void SerialConnect::storeSerialSettings(QSerialPort::Parity parity) {
    currentSettings.parity = parity;
    QString statusTextTemp;
    statusTextTemp = "Parity changed: ";
    statusTextTemp.append(QString("%1").arg(currentSettings.parity));
    sendStatusText( statusTextTemp );
    qDebug() << statusTextTemp;

}

void SerialConnect::storeSerialSettings(QSerialPort::StopBits stopbits) {
    currentSettings.stopBits = stopbits;
    QString statusTextTemp;
    statusTextTemp = "Stop bits changed: ";
    statusTextTemp.append(QString("%1").arg(currentSettings.stopBits));
    sendStatusText( statusTextTemp );
    qDebug() << statusTextTemp;

}

void SerialConnect::storeSerialSettings(QSerialPort::FlowControl flowcontrol) {
    currentSettings.flowControl = flowcontrol;
    QString statusTextTemp;
    statusTextTemp = "Flow control changed: ";
    statusTextTemp.append(QString("%1").arg(currentSettings.flowControl));
    sendStatusText( statusTextTemp );
    qDebug() << statusTextTemp;

}

void SerialConnect::findAvailablePorts(bool withSystemPorts) {
    qDebug() << "SerialConnect::findAvailablePorts() called withSystemPorts = " << withSystemPorts;
    availablePortsList.clear();

    foreach (const QSerialPortInfo &info, QSerialPortInfo::availablePorts()) {
        if(!withSystemPorts) {
            qDebug() << "SerialConnect::findAvailablePorts(): omitting system port";
            if(!info.portName().contains("ttyS")) {
                availablePortsList.append(info.portName());
                //sendAvailablePort((QVariant) info.portName());
            }
        }
        else {
            availablePortsList.append(info.portName());
            //sendAvailablePort((QVariant) info.portName());
        }
    }
    availablePortsChanged();
    qDebug() << "SerialConnect::availablePortsList = "<< availablePortsList;
    // further info functions provided by serail class but not used  info.systemLocation() << info.description() << info.manufacturer() << (info.vendorIdentifier() ? QString::number(info.vendorIdentifier(), 16) : QString()) << (info.productIdentifier() ? QString::number(info.productIdentifier(), 16) : QString());

}

void SerialConnect::timerEvent(QTimerEvent *event)
{
    if (event->timerId() == timer.timerId()) {
        // timer event is from timer set by object
        timer.stop();
        read();
    } /*else {
        QWidget::timerEvent(event); //if you want to use widgets in an application, uncomment this line
    }*/
}

 /******************************************************
  *
  *    Private Functions
  *
  *****************************************************/
