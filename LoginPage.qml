import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Window 2.0 // Screen

Item {
    id: rootId

    property real responsiveWidth: Screen.width > 450 ? 400 : Screen.width - 20

    signal goToRegister
    signal goToForgotPassword
    signal goToDashboard
    signal msg(bool errorMsg, bool infoMsg, string text)

    anchors.fill: parent
    width: Screen.width
    height: Screen.height

    Connections {
        ignoreUnknownSignals: true
        target: userClass
        onInvalidInput: {
            if (id == "emailAddressId")
                emailAddressId.invalidInput();
            else if (id == "passwordId")
                passwordId.invalidInput();
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
            KeyNavigation.tab: passwordId.textId
            textId.focus: true
        }

        DesignTextInput {
            id: passwordId
            width: responsiveWidth
            anchors.top: emailAddressId.bottom
            anchors.topMargin: 10
            textId.echoMode: TextInput.Password
            textId.onAccepted: {
                if (userClass.login(emailAddressId.textId.text, passwordId.textId.text))
                    rootId.goToDashboard()
            }
            placeholderId.text: textId.text == "" ? qsTr("Password") : ""
        }

        DesignButton {
            id: loginButtonId
            width: responsiveWidth
            anchors.top: passwordId.bottom
            anchors.topMargin: 30
            text: qsTr("Login")
            mouseAreaId.onClicked: {
                if (userClass.login(emailAddressId.textId.text, passwordId.textId.text))
                    rootId.goToDashboard()
            }
        }

        Column {
            id: othersColumnId
            width: responsiveWidth
            anchors.top: loginButtonId.bottom
            anchors.topMargin: 60
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 15
            Text {
                id: registerId
                text: qsTr("Register")
                color: "white"
                font.pointSize: 18
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: registerId.font.underline = true
                    onExited: registerId.font.underline = false
                    onClicked: rootId.goToRegister()
                }
            }
            Text {
                id:forgotPasswordId
                text: qsTr("Forgot password")
                color: "white"
                font.pointSize: 18
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: forgotPasswordId.font.underline = true
                    onExited: forgotPasswordId.font.underline = false
                    onClicked: rootId.goToForgotPassword()
                }
            }
        }
    }
}
