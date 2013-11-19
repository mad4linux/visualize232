/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Components project.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Controls.Styles 1.0
//import "gui"

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
        mainwin.guiSendSerialData.connect(serialDataView.deleteTextInputField)
    }

/*    function newSerialDataSlot() {
        serialDataView.appendNewSerialData(serialPortC.newSerialData)
    } */

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

    //serialPortC.onNewSerialDataChanged: serialDataView.appendNewSerialData(serialPortC.newSerialData)


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
            }
            MenuItem {
                text: qsTr("Paste")
                shortcut: "Ctrl+V"
            }
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

