import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Window 2.0 // Screen

Item {
    id: rootId

    property real responsiveWidth: Screen.width > 450 ? 400 : Screen.width - 20

    signal goToRegister
    signal forgotPassword
    signal msg(bool errorMsg, bool infoMsg, string text)

    function validate() {
        if (!/.+@.+\..+/i.test(emailAddressId.textId.text))
        {
            emailAddressId.invalidInput();
            msg(true, false, qsTr("Please check the input fields in red."));
        }
        else
        {
            if (userClass.sendResetMail(emailAddressId.textId.text))
                rootId.forgotPassword();
        }
    }

    anchors.fill: parent
    width: Screen.width
    height: Screen.height

    Connections {
        ignoreUnknownSignals: true
        target: userClass
        onInvalidInput: {
            if (id == "emailAddressId")
                emailAddressId.invalidInput();
        }
    }

    Image {
        id: backgroundImageId
        source: "images/background.jpg"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    Item {
        id: loginItemId
        anchors.centerIn: parent
        width: responsiveWidth
        height: 425

        DesignLogo {
            id: logoId
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        DesignTextInput {
            id: emailAddressId
            width: responsiveWidth
            anchors.top: logoId.bottom
            placeholderId.text: textId.text == "" ? qsTr("Email address") : ""
            textId.onAccepted: validate()
            textId.focus: true
        }

        DesignButton {
            id: resetButtonId
            width: responsiveWidth
            anchors.top: emailAddressId.bottom
            anchors.topMargin: 30
            text: qsTr("Reset password")
            mouseAreaId.onClicked: validate()
        }

        Text {
            id: registerId
            text: qsTr("Register")
            color: "white"
            font.pointSize: 18
            anchors.top: resetButtonId.bottom
            anchors.topMargin: 60
            anchors.horizontalCenter: parent.horizontalCenter
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: registerId.font.underline = true
                onExited: registerId.font.underline = false
                onClicked: rootId.goToRegister()
            }
        }
    }
}
