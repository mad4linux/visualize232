import QtQuick 2.1
import QtQuick.Dialogs 1.0


FileDialog {
    id: fileDialogSave
    folder: "~"
    title: "Save as..."
    selectExisting: false

    onAccepted: { console.log("Accepted: " + filePath) }
}
