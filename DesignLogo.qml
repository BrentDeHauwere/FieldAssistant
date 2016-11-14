import QtQuick 2.0

Item {
    height: 150
    width: 300
    FontLoader {
        id: gothamId
        source: "fonts/Gotham-Bold.ttf"
    }

    Image {
        id: imageId
        source: "images/icon.svg"
        anchors.left: parent.left
        sourceSize.height: 100
        sourceSize.width: 100
    }
    Text {
        id: textId
        text: "Field\nAssistant"
        color: "white"
        font.pointSize: 30
        anchors.left: imageId.right
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 15
        font.family: gothamId.name
    }
}
