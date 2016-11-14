import QtQuick 2.5

Rectangle {
    property alias textId: textId
    property alias placeholderId: placeholderId

    function invalidInput() {
        color = "red"
    }

    function validInput() {
        color = "#383838"
    }

    height: 40
    radius: 5
    opacity: 0.5
    color: "#383838"
    TextInput {
        id: textId
        anchors.fill: parent
        anchors.margins: 10
        selectByMouse: true
        color: "white"
        font.pointSize: 16
        clip: true
        selectionColor: "#128DD4"
        onTextChanged: validInput()
    }
    Text {
        id: placeholderId
        anchors.fill: parent
        anchors.margins: 10
        color: "white"
        font.pointSize: 16
    }
}
