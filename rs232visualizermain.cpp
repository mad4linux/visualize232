#include <QDebug>
#include "rs232visualizermain.h"


/***********************************************************
 *
 * public
 *
 ***********************************************************/

RS232VisualizerMain::RS232VisualizerMain(QObject *parent) :
    QObject(parent)
{
//    createSerialPortThread();
}

RS232VisualizerMain::~RS232VisualizerMain()
{
  closeSerialPortThread();
}


/***********************************************************
 *
 * public slots
 *
 ***********************************************************/
void RS232VisualizerMain::closeSerialPortThread() {
  mainSerialThread->exit();
}

void RS232VisualizerMain::openSerialPortThread() {
  qDebug() << "OpenSerialPortThread Slot called";
  if(!serPortThreadStatus) {
    emit(openSerialPort());
  }
}



void RS232VisualizerMain::setSerialThreadStatus(bool serPortStatus)
{
  serPortThreadStatus = serPortStatus;
}



/***********************************************************
 *
 * private :
 *
 ***********************************************************/

int RS232VisualizerMain::createSerialPortThread(QString portName, QString settings) {
  mainSerialThread = new SerialPortThread(&portName,&settings, this);
//  connect(mainSerialThread, SIGNAL(serialPortStatusText(QString)), this, SLOT(setStatusText(QString)));
  connect(this, SIGNAL(threadStart()), mainSerialThread, SLOT(start()));
  connect(mainSerialThread, SIGNAL(started()), this, SLOT(openSerialPortThread()));
  connect(this, SIGNAL(threadStop()), mainSerialThread, SLOT(quit()));
  connect(this, SIGNAL(openSerialPort()), mainSerialThread, SLOT(openSerialPort()));
  connect(this, SIGNAL(closeSerialPort()), mainSerialThread, SLOT(closeSerialPort()));
//  connect(mainSerialThread, SIGNAL(serDataArrived(QString)), this, SLOT(onDataReceivedRedirect(QString)));

  emit(threadStart());
  return 0;
}

/****************************************************************
 *
 * private slots :
 *
 ***************************************************************/

void RS232VisualizerMain::newSerialPortSet(QString newPort)
{
  qDebug() << "newSerialPortSet called. New Port is "<< newPort;
  if (serPortThreadStatus) {  // is serial port open?
    emit(closeSerialPort());
    closeSerialPortThread();
  }
    qDebug() << "create new Serial port thread with port " << newPort;
    createSerialPortThread(newPort);
}

void RS232VisualizerMain::destroySerialPortThread() {
  qDebug() << "Finished signal";
  mainSerialThread->disconnect();
  delete mainSerialThread;
}

