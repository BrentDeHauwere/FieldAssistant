import QtQuick 2.0
import QtQuick.Window 2.0

Rectangle {
    id: rootId

    property bool errorMsg: false
    property bool infoMsg: false
    property alias textMsg: textId.text
    property alias running: animationId.running

    width: Screen.width
    height: 30
    y: -50
    z: 1
    color: errorMsg === true ? "#f9f2f4" : "#DFF0D8"
    border.color: errorMsg === true ? "#c7254e" : "#468847"
    anchors.left: parent.left
    anchors.right: parent.right
    SequentialAnimation {
        id: animationId
        PropertyAnimation {
            target: rootId
            property: "y"
            to: 0
            duration: 1000
        }
        PauseAnimation {
            duration: 5000
        }
        PropertyAnimation {
            target: rootId
            property: "y"
            to: -50
            duration: 1000
        }
    }
    Image {
        id: imageId
        source: errorMsg === true ? "images/error.svg" : "images/info.svg"
        anchors.right: textId.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        sourceSize.height: 22
        sourceSize.width: 22

    }
    Text {
        id: textId
        anchors.centerIn: parent
        color: errorMsg === true ? "#c7254e" : "#468847"
    }
}
