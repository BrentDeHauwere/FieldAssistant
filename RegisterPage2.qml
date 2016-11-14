import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Window 2.0 // Screen

Item {
    id: rootId

    property real responsiveWidth: Screen.width > 450 ? 400 : Screen.width - 20

    signal goToLogin;
    signal goToDashboard;
    signal msg(bool errorMsg, bool infoMsg, string text)

    function validate() {
        var valid = true;
        var passValid = true;
        if (!/[\w]+[\-'\s]*/.test(firstNameId.textId.text))
        {
            firstNameId.invalidInput();
            valid = false;
        }
        if (!/[\w]+[\-'\s]*/.test(lastNameId.textId.text))
        {
            lastNameId.invalidInput();
            valid = false;
        }
        if (!/.+@.+\..+/i.test(emailAddressId.textId.text))
        {
            emailAddressId.invalidInput();
            valid = false;
        }
        if (passwordId.textId.text.length == 0 || passwordId.textId.text != passwordAgainId.textId.text)
        {
            passwordId.invalidInput();
            passwordAgainId.invalidInput();
            passValid = false;
        }
        if (valid && passValid)
        {
            userClass.firstName = firstNameId.textId.text;
            userClass.lastName = lastNameId.textId.text;
            userClass.email = emailAddressId.textId.text;
            userClass.password = passwordId.textId.text;
            userClass.isKeyUser = true;
            if (userClass.registerKeyUser())
                rootId.goToDashboard();
        }
        else if (!passValid)
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
            if (id == "firstNameId")
                firstNameId.invalidInput();
            else if (id == "lastNameId")
                lastNameId.invalidInput();
            else if (id == "emailAddressId")
                emailAddressId.invalidInput();
            else if (id == "passwordId")
                passwordId.invalidInput();
            else if (id == "passwordAgainId")
                passwordAgainId.invalidInput();
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
        height: 540

        DesignLogo {
            id: logoId
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        DesignTextInput {
            id: firstNameId
            width: responsiveWidth
            anchors.top: logoId.bottom
            placeholderId.text: textId.text == "" ? qsTr("First name") : ""
            KeyNavigation.tab: lastNameId.textId
            textId.focus: true
        }

        DesignTextInput {
            id: lastNameId
            width: responsiveWidth
            anchors.top: firstNameId.bottom
            anchors.topMargin: 10
            KeyNavigation.tab: emailAddressId.textId
            placeholderId.text: textId.text == "" ? qsTr("Last name") : ""
        }

        DesignTextInput {
            id: emailAddressId
            width: responsiveWidth
            anchors.top: lastNameId.bottom
            anchors.topMargin: 10
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
            KeyNavigation.tab: passwordAgainId.textId
            placeholderId.text: textId.text == "" ? qsTr("Password") : ""
        }

        DesignTextInput {
            id: passwordAgainId
            width: responsiveWidth
            anchors.top: passwordId.bottom
            anchors.topMargin: 10
            textId.echoMode: TextInput.Password
            textId.onAccepted: validate()
            placeholderId.text: textId.text == "" ? qsTr("Password") : ""
        }

        DesignButton {
            id: registerButtonId
            width: responsiveWidth
            anchors.top: passwordAgainId.bottom
            anchors.topMargin: 30
            text: qsTr("Register (step 2/2)")
            mouseAreaId.onClicked: validate()
        }


        Text {
            id: loginId
            text: qsTr("I already have a login")
            color: "white"
            font.pointSize: 18
            anchors.top: registerButtonId.bottom
            anchors.topMargin: 60
            anchors.horizontalCenter: parent.horizontalCenter
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: loginId.font.underline = true
                onExited: loginId.font.underline = false
                onClicked: rootId.goToLogin()
            }
        }
    }
}
