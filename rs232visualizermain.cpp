#include <QtWidgets/QApplication>
#include <QtQml>
#include <QtQuick/QQuickView>
#include <QIcon>
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
    startSerialPort();
    startGUI();
    connectionsGUIserial();
    initializeSettings();
    //connect serialDataChanged to this and engine->rootContext()->setContextProperty("serialPortC",serialPort); again to update properties

}

RS232VisualizerMain::~RS232VisualizerMain()
{

}

void RS232VisualizerMain::initializeSettings() {
    QCoreApplication::setOrganizationName("gaesstec");
    QCoreApplication::setOrganizationDomain("gaess.ch");
    QCoreApplication::setApplicationName("visualize232");

    appSettings = new QSettings;
}

int RS232VisualizerMain::startGUI() {
    engine = new QQmlEngine;

    //export context properties to qml
    engine->rootContext()->setContextProperty("serialPortC",serialPort);
    engine->rootContext()->setContextProperty("appSettings",appSettings);

    component = new QQmlComponent(engine);
    component->loadUrl(QUrl("qrc:/qml/main.qml"));
    if ( !component->isReady() ) {
        qWarning("%s", qPrintable(component->errorString()));
        return 1;
    }
    topLevel = component->create();
    window = qobject_cast<QQuickWindow *>(topLevel);
    if ( !window ) {
        qWarning("Error: Your root item has to be a Window.");
        return 1;
    }
    window->show();
    window->setIcon(QIcon(":/bitmaps/RS232VisIcon.png"));

    QObject::connect(engine, SIGNAL(quit()),QCoreApplication::instance(), SLOT(quit()));
    return 0;
}

void RS232VisualizerMain::startSerialPort() {
    serialPort = new SerialConnect;
    connect(this, SIGNAL(openSerialPort()), serialPort, SLOT(open()));
    connect(this, SIGNAL(closeSerialPort()), serialPort, SLOT(close()));
}

void RS232VisualizerMain::connectionsGUIserial() {
    connect(topLevel, SIGNAL(guiOpenSerial()),serialPort,SLOT(open()));
    connect(topLevel, SIGNAL(guiCloseSerial()),serialPort,SLOT(close()));
    connect(topLevel, SIGNAL(guiSendSerialData(QString)), serialPort, SLOT(write(QString)));
    connect(topLevel, SIGNAL(guiSetSerialSettingsPort(QString)),serialPort,SLOT(getPortSettings(QString)));
    connect(topLevel, SIGNAL(guiSetSerialSettingsBaud(QString)),serialPort,SLOT(getBaudSettings(QString)));
    connect(topLevel, SIGNAL(guiSetSerialSettingsBit(QString)),serialPort,SLOT(getBitSettings(QString)));
    connect(topLevel, SIGNAL(guiSetSerialSettingsParity(QString)),serialPort,SLOT(getParitySettings(QString)));
    connect(topLevel, SIGNAL(guiSetSerialSettingsStopbits(QString)),serialPort,SLOT(getStopbitsSettings(QString)));
    connect(topLevel, SIGNAL(guiSetSerialSettingsFlowcontrol(QString)),serialPort,SLOT(getFlowcontrolSettings(QString)));
    connect(topLevel, SIGNAL(guiGetAvailableSerialPorts(bool)),serialPort,SLOT(findAvailablePorts(bool)));

    connect(serialPort,SIGNAL(sendStatusText(QVariant)),topLevel, SLOT(getStatusText(QVariant)));
    connect(serialPort,SIGNAL(opened()),topLevel,SLOT(serialPortOpenSlot()));
    connect(serialPort,SIGNAL(serialDataChanged()),topLevel, SLOT(newSerialDataSlot()));

}

/***********************************************************
 *
 * public slots
 *
 ***********************************************************/



/***********************************************************
 *
 * private :
 *
 ***********************************************************/


/****************************************************************
 *
 * private slots :
 *
 ***************************************************************/

/* void RS232VisualizerMain::newSerialPortSet(QString newPort)
{
  qDebug() << "newSerialPortSet called. New Port is "<< newPort;
  if (serPortStatus) {  // is serial port open?
    emit(closeSerialPort());
  }
    qDebug() << "create new Serial port with port " << newPort;
    setSerial(newPort);
    emit(openSerialPort());
}

void RS232VisualizerMain::destroySerialPort() {
  qDebug() << "Finished signal";
  serialPort->disconnect();
  delete serialPort;
} */

