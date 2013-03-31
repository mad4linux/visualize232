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

#ifndef SERIALPORTTHREAD_H
#define SERIALPORTTHREAD_H

#include <QThread>
#include <QSerialPort>

namespace TNX { class QSerialPort; }

class SerialPortThread : public QThread
{
  Q_OBJECT
  
  public:
    SerialPortThread(QString* initPortName, QString* initSettings, QObject* parent = 0);
    ~SerialPortThread();

  public slots:
    void closeSerialPort();
//    void openCloseSerialPort(QString currentComboBoxText);
    void openSerialPort();
    void newSerialPortSet();
 

  signals:
    void serialPortStatusText(QString serPortStatusText);
    void serialPortStatus(bool serPortStatusBool);
    void serDataArrived(QString newData); 

    
  protected:
    void run();
    QString portName;
    TNX::QPortSettings settings;

  private:
    QString serPortStatusText;
    bool serPortStatusBool;
    QString NewData;
    TNX::QSerialPort serport;
    QByteArray dataBytes;
    
  private slots:
    void onDataReceived();

};

#endif // SERIALPORTTHREAD_H
