import QtQuick 2.0

Rectangle {
    property alias text: textId.text
    property alias mouseAreaId: mouseAreaId

    height: 35
    radius: 17.5
    color: mouseAreaId.containsMouse ? "#0577BA" : "#128DD4"
    FontLoader {
        id: openSansId
        source: "fonts/OpenSans-Regular.ttf"
    }

    Text {
        id: textId
        anchors.centerIn: parent
        color: "white"
        font.pointSize: 20
        font.family: openSansId.name
    }
    MouseArea {
        id: mouseAreaId
        anchors.fill: parent
        hoverEnabled: true
    }
}

