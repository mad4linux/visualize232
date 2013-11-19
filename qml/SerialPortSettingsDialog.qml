import QtQuick 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.0

Rectangle {
    id: serialPortSettingsDialog

    property bool includeSystemPorts: false
    property string newPortChoice


    onNewPortChoiceChanged: portChoices.append({ "text": newPortChoice })

    function sendSerialOpen() {
        guiSetSerialSettingsPort(portCombo.currentText)
        guiOpenSerial()
        guiSetSerialSettingsBaud(baudCombo.currentText)
        guiSetSerialSettingsBit(bitCombo.currentText)
        guiSetSerialSettingsParity(parityChoices.get(parityCombo.currentIndex).value)
        guiSetSerialSettingsStopbits(stopbitsCombo.currentText)
        guiSetSerialSettingsFlowcontrol(flowcontrolChoices.get(flowcontrolCombo.currentIndex).value)
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
                model: serialPortC.availablePorts
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
                onClicked: guiGetAvailableSerialPorts(checked)
                onCheckedStateChanged: { includeSystemPorts = checked }
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

}
