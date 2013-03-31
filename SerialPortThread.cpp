/*
    <one line to give the library's name and an idea of what it does.>
    Copyright (C) <year>  <name of author>

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

*/
#include <QSerialPort>
#include "SerialPortThread.h"
#include <QDebug>

SerialPortThread::SerialPortThread(QString* initPortName, QString* initSettings, QObject* parent) : QThread(parent), serport(*initPortName, *initSettings) {
  portName = serport.portName();
  settings = serport.portSettings();

}

SerialPortThread::~SerialPortThread()
{

}


void SerialPortThread::run()
{
  exec();
}


void SerialPortThread::closeSerialPort() {
//  this->disconnect();
  serport.close();
  serPortStatusBool = 0;
  serPortStatusText = "Serial Port Closed";

  emit(serialPortStatus(serPortStatusBool));
  emit(serialPortStatusText(serPortStatusText));
}

void SerialPortThread::newSerialPortSet()
{
    closeSerialPort();
    openSerialPort();
 }

void SerialPortThread::onDataReceived() {
  dataBytes.append(serport.read(512));
//  qDebug() << "QByteArray dump: " << dataBytes;
  if ( dataBytes.contains('\n') ) {
    QString data = dataBytes;
    dataBytes.clear();
//    qDebug() << "QString data emit: " << data;
    emit serDataArrived(data);
    return;
  }
}

void SerialPortThread::openSerialPort() {
  qDebug() << "port = " << portName;
  if (!serport.open()) {
    serPortStatusBool = false;
    serPortStatusText.append("Error opening serial port ");
    serPortStatusText.append(portName);
  }
  else {
    serPortStatusBool = true;
    serPortStatusText.append("Serial port ");
    serPortStatusText.append(portName);
    serPortStatusText.append(" opened");
  } 
  connect(&serport, SIGNAL(readyRead()), SLOT(onDataReceived()));

  if ( !serport.setCommTimeouts(TNX::QSerialPort::CtScheme_NonBlockingRead) )
    qWarning("Cannot set communications timeout values at port %s.", qPrintable(serport.portName()));

  emit(serialPortStatus(serPortStatusBool));
  emit(serialPortStatusText(serPortStatusText));
}
 
