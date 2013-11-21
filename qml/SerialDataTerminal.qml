import QtQuick 2.1
import QtQuick.Controls 1.0



Rectangle {
    id: serialDataTerminal

    property bool sendCarriageReturn: false

    function appendNewSerialData(text) {
            serialDataCommunication.appendSameLine(text)
        }

    function deleteTextInputField() {
        serialDataInput.text = ""
    }

    function serialDataSend(text) {
        if (serialDataView.sendCarriageReturn) {
            text += "\r"
        }
        guiSendSerialData(text)
    }

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


    TextAreaOwn {
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
        onCheckedStateChanged: { sendCarriageReturn = checked }
    }
}
