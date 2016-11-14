import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Window 2.0 // Screen

Item {
    id: rootId

    property real responsiveWidth: Screen.width > 450 ? 400 : Screen.width - 20

    signal confirmReset;
    signal msg(bool errorMsg, bool infoMsg, string text)

    function validate() {
        var valid = true;
        var validPass = true;
        if (tokenId.textId.text.length == 0)
        {
            tokenId.invalidInput();
            valid = false;
        }
        if (newPasswordId.textId.text.length == 0 || newPasswordId.textId.text != newPasswordAgainId.textId.text)
        {
            newPasswordId.invalidInput();
            newPasswordAgainId.invalidInput();
            validPass = false;
        }
        if (valid && validPass)
        {
            if (userClass.resetPassword(tokenId.textId.text, newPasswordId.textId.text))
                rootId.confirmReset();
        }
        else if (!validPass)
            msg(true, false, qsTr("The two password fields must match and contain a value."));
        else
            msg(true, false, qsTr("Please check the input fields in red."));
    }

    anchors.fill: parent
    width: Screen.width
    height: Screen.height

    Connections {
        ignoreUnknownSignals: true
        target: userClass
        onInvalidInput: {
            if (id == "tokenId")
                tokenId.invalidInput();
            else if (id == "newPasswordId")
                newPasswordId.invalidInput();
            else if (id == "newPasswordAgainId")
                newPasswordAgainId.invalidInput();
        }
    }

    Image {
        id: backgroundImageId
        source: "images/background.jpg"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    Item {
        id: registerItemId
        anchors.centerIn: parent
        width: responsiveWidth
        height: 425

        DesignLogo {
            id: logoId
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        DesignTextInput {
            id: tokenId
            width: responsiveWidth
            anchors.top: logoId.bottom
            placeholderId.text: textId.text == "" ? qsTr("Token") : ""
            KeyNavigation.tab: newPasswordId.textId
            textId.focus: true
        }

        DesignTextInput {
            id: newPasswordId
            width: responsiveWidth
            anchors.top: tokenId.bottom
            anchors.topMargin: 10
            textId.echoMode: TextInput.Password
            placeholderId.text: textId.text == "" ? qsTr("New password") : ""
            KeyNavigation.tab: newPasswordAgainId.textId
        }

        DesignTextInput {
            id: newPasswordAgainId
            width: responsiveWidth
            anchors.top: newPasswordId.bottom
            anchors.topMargin: 10
            textId.echoMode: TextInput.Password
            textId.onAccepted: rootId.confirmReset()
            placeholderId.text: textId.text == "" ? qsTr("New password") : ""
        }

        DesignButton {
            id: registerButtonId
            width: responsiveWidth
            anchors.top: newPasswordAgainId.bottom
            anchors.topMargin: 30
            text: qsTr("Confirm")
            mouseAreaId.onClicked: rootId.confirmReset()
        }


//        Text {
//            id: loginId
//            text: qsTr("I already have a login")
//            color: "white"
//            font.pointSize: 18
//            anchors.top: registerButtonId.bottom
//            anchors.topMargin: 60
//            anchors.horizontalCenter: parent.horizontalCenter
//            MouseArea {
//                anchors.fill: parent
//                hoverEnabled: true
//                onEntered: loginId.font.underline = true
//                onExited: loginId.font.underline = false
//                onClicked: rootId.goToLogin()
//            }
//        }
    }
}

