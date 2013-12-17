import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Controls.Styles 1.0


ApplicationWindow {
    id: mainwin
    title: "RS232 Visualizer"
    width: 720
    height: 540

    property int getSystemPorts: 0


    // signals to C++
    signal guiOpenSerial()
    signal guiCloseSerial()
    signal guiSetSerialSettingsPort(string port)
    signal guiSetSerialSettingsBaud(string baud)
    signal guiSetSerialSettingsBit(string bit)
    signal guiSetSerialSettingsParity(string parity)
    signal guiSetSerialSettingsStopbits(string stopbits)
    signal guiSetSerialSettingsFlowcontrol(string flowcontrol)
    signal guiGetAvailableSerialPorts(bool withSystem)
    signal guiSendSerialData(string dataToSend)

    // UI internal signals


    // UI internal bindings
    Component.onCompleted: {
        loadSettings()
        mainwin.guiSendSerialData.connect(serialDataView.deleteTextInputField)
    }

    onClosing: {
        saveSettings()
    }

    function loadSettings() {
        mainwin.setX(staticSettings.value("MainWindow/x") )
        mainwin.setY(staticSettings.value("MainWindow/y") )
        mainwin.setWidth(staticSettings.value("MainWindow/width") )
        mainwin.setHeight(staticSettings.value("MainWindow/height") )

    }

    function saveSettings() {
        staticSettings.setValue("MainWindow/x", mainwin.x )
        staticSettings.setValue("MainWindow/y", mainwin.y )
        staticSettings.setValue("MainWindow/width", mainwin.width)
        staticSettings.setValue("MainWindow/height", mainwin.height)

    }



    function sendSerialClose() {
        guiCloseSerial()
        serialDataView.state = "serialClosed"
        startupTextSerialClosed.state = "serialClosed"

    }


    function getStatusText(newStatusText) {
        statusBarLabel.text = newStatusText
    }



    function serialPortOpenSlot() {
        serialDataView.state = "serialOpen"
        startupTextSerialClosed.state = "serialOpen"
    }

    function newSerialDataSlot() {
        serialDataView.appendNewSerialData(serialPortC.newSerialData)
    }

    function copy() {
        if (serialDataView.visible  ) {
            serialDataView.copy()  //copies text to clipboard
        }
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Open...")
                shortcut: "Ctrl+O"
                onTriggered: fileDialogLoad.open();
            }
            MenuItem {
                text: qsTr("Save as...")
                shortcut: "Ctrl+S"
                onTriggered: fileDialogSaveAs.open();
            }
            MenuItem {
                text: qsTr("Quit")
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit()
            }
        }
        Menu {
            title: qsTr("Edit")
            MenuItem {
                text: qsTr("Copy")
                shortcut: "Ctrl+C"
                onTriggered: copy()
            }
        /*    MenuItem {
                text: qsTr("Paste")
                shortcut: "Ctrl+V"
            } */
        }
        Menu {
                    title: qsTr("Serial Port")
                    MenuItem {
                        text: "Open"
                        shortcut: "Ctrl+Alt+O"
                        onTriggered: serialSettingsView.sendSerialOpen()
                    }
                    MenuItem {
                        text: "Close"
                        shortcut: "Ctrl+Alt+Q"
                        onTriggered: sendSerialClose()
                    }
                    MenuItem {
                        text: qsTr("Settings")
                        shortcut: "Ctrl+Alt+S"
                        onTriggered: {
                            serialSettingsView.state = "visible"
                            guiGetAvailableSerialPorts(serialSettingsView.includeSystemPorts)
                        }
                    }
        }
    }

    statusBar: StatusBar {
        id: mainStatusBar
        Label {
            id: statusBarLabel
            text: "Welcome. Have a lot of fun ..."
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
        }
    }

    FileDialogOpen{
        id: fileDialogLoad

    }

    FileDialogSave {
        id: fileDialogSaveAs
    }

    Text {
        id: startupTextSerialClosed
        state: "serialClosed"
        anchors.topMargin: 5
        text: "Please navigate to the \"Serial Port\" menu to adjust settings and open a serial port"

        states: [
            State {
                name: "serialClosed"
                PropertyChanges {
                    target: startupTextSerialClosed; visible:true
                }
            },
            State {
                name: "serialOpen"
                PropertyChanges {
                    target: startupTextSerialClosed; visible:false
                }
            }
        ]
    }

    SerialDataTerminal{
        id: serialDataView
        state: "serialClosed"

        states: [
            State {
                name: "serialClosed"
                PropertyChanges {
                    target: serialDataView; visible:false
                }
            },
            State {
                name: "serialOpen"
                PropertyChanges {
                    target: serialDataView; visible:true
                }
            }
        ]

    }

    SerialPortSettingsDialog{
        id: serialSettingsView
        state: "invisible"


        states: [
            State {
                name: "invisible"
                PropertyChanges {
                    target: serialSettingsView; visible:false
                }
            },
            State {
                name: "visible"
                PropertyChanges {
                    target: serialSettingsView; visible:true
                }
            }
        ]

    }
}

