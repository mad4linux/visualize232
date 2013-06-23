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


    function sendSerialOpen() {
        guiSetSerialSettingsPort(portCombo.currentText)
        guiOpenSerial()
        guiSetSerialSettingsBaud(baudCombo.currentText)
        guiSetSerialSettingsBit(bitCombo.currentText)
        guiSetSerialSettingsParity(parityChoices.get(parityCombo.currentIndex).value)
        guiSetSerialSettingsStopbits(stopbitsCombo.currentText)
        guiSetSerialSettingsFlowcontrol(flowcontrolChoices.get(flowcontrolCombo.currentIndex).value)
    }

    function sendSerialClose() {
        guiCloseSerial()
        serialDataView.state = "serialClosed"
        startupTextSerialClosed.state = "serialClosed"

    }


    function getStatusText(newStatusText) {
        statusBarLabel.text = newStatusText
    }

    function getAvailablePort(newAvailablePort) {
        portChoices.append({ "text": newAvailablePort })
    }

    function clearSerialPortsList() {
        portChoices.clear()
    }

    function serialDataSend(text) {
        if (sendCarriageReturnCheck.checked) {
            text += "\r"
        }

        guiSendSerialData(text)
        serialDataInput.text = ""
    }

    function displaySerialData(text) {
        serialDataCommunication.insert(serialDataCommunication.length,text)
    }

    function serialPortOpenSlot() {
        serialDataView.state = "serialOpen"
        startupTextSerialClosed.state = "serialOpen"
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
                        onTriggered: sendSerialOpen()
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
                            guiGetAvailableSerialPorts(includeSystemPortsCheck.checked)
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


    FileDialog {
        id: fileDialogLoad
        folder: "~"
        title: "Choose a file to open"
        selectMultiple: true
        nameFilters: [ "Text files (*.xml *.txt)", "All files (*)" ]

        onAccepted: { console.log("Accepted: " + filePaths) }
    }

    FileDialog {
        id: fileDialogSaveAs
        folder: "~"
        title: "Save as..."
        selectExisting: false

        onAccepted: { console.log("Accepted: " + filePath) }
    }

    Text {
        id: startupTextSerialClosed
        state: "serialClosed"
        anchors.topMargin: 5
        text: "Navigate to \"serial port\" menu to adjust settings and open serial port"

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

    Rectangle {
        id: serialDataView
        state: "serialClosed"
        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#c0c9cf";
            }
            GradientStop {
                position: 1.00;
                color: "#e3ecee";
            }
        }
        border.color: "#b4bbbe"
        anchors.fill: parent
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.top: parent.top
            height: 30
            width: 80
            verticalAlignment: TextInput.AlignVCenter
            wrapMode: Text.WordWrap
            text: "Serial communication"
        }

        TextArea {
            id: serialDataCommunication
            anchors.top: parent.top
            anchors.topMargin: 2
            anchors.right: parent.right
            anchors.rightMargin: 5
            height: parent.height-100
            width: parent.width-100
            highlightOnFocus: false
            readOnly: true
        }
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            height: 30
            width: 80
            verticalAlignment: TextInput.AlignVCenter
            wrapMode: Text.WordWrap
            text: "Send over serial port:"
        }

        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            height: 30
            width: parent.width-100
            color: "#000000"
            border.color: "#a0a0a0"
            TextInput {
                id: serialDataInput
                anchors.fill: parent
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                onAccepted: serialDataSend(text)
                color: "#aaaaaa"
                verticalAlignment: TextInput.AlignVCenter
            }
        }
        CheckBox {
                id: sendCarriageReturnCheck
                anchors.left: parent.left
                anchors.leftMargin: 100
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                text: qsTr("send carriage return when pressing enter")
            }

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

    ListModel {
            id: portChoices
            ListElement { text: "ttyACM0" }
        }

    ListModel {
            id: baudChoices
            ListElement { text: "38400" }
            ListElement { text: "19200" }
            ListElement { text: "9600" }
            ListElement { text: "4800" }
            ListElement { text: "2400" }
            ListElement { text: "1200" }
        }

    ListModel {
            id: bitChoices
            ListElement { text: "7" }
            ListElement { text: "8" }
        }

    ListModel {
            id: parityChoices
            ListElement { text: "no"; value: "0" }
            ListElement { text: "even"; value: "2" }
            ListElement { text: "odd"; value: "3" }
            ListElement { text: "space"; value: "4" }
            ListElement { text: "mark";  value: "5" }
        }

    ListModel {
            id: stopbitsChoices
            ListElement { text: "0" }
            ListElement { text: "1" }
        }

    ListModel {
            id: flowcontrolChoices
            ListElement { text: "No"; value: "0" }
            ListElement { text: "Hardware (RTS/CTS)"; value: "1" }
            ListElement { text: "Software (XON/XOFF)"; value: "2" }
        }


    Rectangle {
        id: serialSettingsView
        state: "invisible"
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin:0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        width: 265
        gradient: Gradient {
            GradientStop {
                position: 0.00
                 color: "#d6d1d1"
            }
            GradientStop {
                position: 1.00
                color: "#eeeeee"
            }
        }
        border.color: "#e6e1e1"
        border.width: 1
        ColumnLayout {
            spacing: 10
            anchors.fill: parent
            anchors.leftMargin: 10
            Text {
                text: qsTr("Serial port settings")
            }
            Rectangle {
                width: serialSettingsView.width-10
                height: 1
            }

            RowLayout {
                id:selectSerialRow
                Text {
                    id:selectSerialText
                    text: qsTr("Select serial port")
                    height: portCombo.height
                    verticalAlignment: Text.AlignVCenter
                }
                ComboBox {
                    id: portCombo;
                    model: portChoices;
                    currentIndex: 0
                }
                Image {
                    source: "images/refresh-icon-shadow.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: guiGetAvailableSerialPorts(includeSystemPortsCheck.checked)
                    }
                }
            }
            CheckBox {
                    id: includeSystemPortsCheck
                    text: qsTr("include system ports")
                    onClicked: guiGetAvailableSerialPorts(includeSystemPortsCheck.checked)
                }

            RowLayout {
                spacing: 40
                Text {
                    text: qsTr("Baud rate")
                    height: baudCombo.height
                    verticalAlignment: Text.AlignVCenter
                }
                ComboBox {
                    id: baudCombo;
                    model: baudChoices;
                    currentIndex: 2
                }
            }
            RowLayout {
                spacing: 43
                Text {
                    text: qsTr("Data bits")
                    height: bitCombo.height
                    verticalAlignment: Text.AlignVCenter
                }
                ComboBox {
                    id: bitCombo;
                    model: bitChoices;
                    currentIndex: 1
                }
            }
            RowLayout {
                spacing: 57
                Text {
                    text: qsTr("Parity")
                    height: parityCombo.height
                    verticalAlignment: Text.AlignVCenter
                }
                ComboBox {
                    id: parityCombo;
                    model: parityChoices;
                    currentIndex: 0
                }
            }
            RowLayout {
                spacing: 43
                Text {
                    text: qsTr("Stop bits")
                    height: stopbitsCombo.height
                    verticalAlignment: Text.AlignVCenter
                }
                ComboBox {
                    id: stopbitsCombo;
                    model: stopbitsChoices;
                    currentIndex: 1
                }
            }
            RowLayout {
                spacing: 25
                Text {
                    text: qsTr("Flow control")
                    height: flowcontrolCombo.height
                    verticalAlignment: Text.AlignVCenter
                }
                ComboBox {
                    id: flowcontrolCombo;
                    model: flowcontrolChoices;
                    currentIndex: 0
                }
            }
            RowLayout{
                spacing: 1
                Button {
                    id: serialSettingsCancel
                    text: qsTr("Close")
                    onClicked: serialSettingsView.state = "invisible"
                }
                Button {
                    id: serialSettingsSet
                    text: qsTr("Set")
                    onClicked: sendSerialOpen()
                }
                Button {
                    id: serialSettingsOK
                    text: qsTr("OK")
                    onClicked: {
                        sendSerialOpen()
                        serialSettingsView.state = "invisible"
                    }
                }
            }
        }
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

