import QtQuick 2.1
import QtQuick.Dialogs 1.0

FileDialog {
        id: fileDialogOpen
        folder: "~"
        title: "Choose a file to open"
        selectMultiple: true
        nameFilters: [ "Text files (*.xml *.txt)", "All files (*)" ]

        onAccepted: { console.log("Accepted: " + filePaths) }
    }
