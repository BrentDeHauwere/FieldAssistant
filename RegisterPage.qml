import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Window 2.0 // Screen

Item {
    id: rootId

    property real responsiveWidth: Screen.width > 450 ? 400 : Screen.width - 20

    signal goToRegister2;
    signal goToLogin;
    signal msg(bool errorMsg, bool infoMsg, string text)

    function validate() {
        if (vatNumberId.validVat && companyNameId.textId.text != "")
        {
            if (userClass.vatNumberExists(vatNumberId.textId.text))
                return;
            companyClass.vatNumber = vatNumberId.textId.text;
            companyClass.companyName = companyNameId.textId.text;
            rootId.goToRegister2();
        }
        else
        {
            msg(true, false, qsTr("Please check the input fields in red."))
            if (!vatNumberId.validVat)
                vatNumberId.invalidInput();
            if (companyNameId.textId.text == "")
                companyNameId.invalidInput();
        }
    }

    anchors.fill: parent
    width: Screen.width
    height: Screen.height

    Connections {
        ignoreUnknownSignals: true
        target: userClass
        onInvalidInput: {
            if (id == "vatNumberId")
                vatNumberId.invalidInput();
            else if (id == "companyNameId")
                companyNameId.invalidInput();
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
            id: vatNumberId

            property bool validVat: false

            function checkVat() {
                if (!textId.focus) {
                    var xmlhttp = new XMLHttpRequest();
                    var dirtyVat = textId.text.replace(/[^\w\d]/g,"")
                    textId.text = dirtyVat
                    var countryCode = dirtyVat.substring(0,2);
                    var vatNumber = dirtyVat.substring(2);
                    var url = "http://brentdehauwere.be/vatValidator/?countryCode=" + countryCode + "&vatNumber=" + vatNumber;

                    xmlhttp.onreadystatechange = function() {
                        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                            var array = JSON.parse(xmlhttp.responseText);
                            if (array['valid'] === true) {
                                companyNameId.textId.text = array['name'];
                                validVat = true
                            }
                            else {
                                companyNameId.textId.text = "";
                                rootId.msg(true,false,qsTr("Invalid VAT number"));
                                validVat = false
                            }
                        }
                        else if (xmlhttp.readyState == 4 && xmlhttp.status == 0) {
                            companyNameId.textId.text = "";
                            rootId.msg(true,false,qsTr("Invalid VAT number"));
                            validVat = false
                        }
                        else if (xmlhttp.readyState == 4) { // Other status
                            companyNameId.textId.text = "";
                            rootId.msg(true,false,qsTr("Error VAT validator: ") + xmlhttp.statusText);
                            validVat = false
                        }
                    }

                    xmlhttp.open("GET", url, true);
                    xmlhttp.send();
                }
            }

            width: responsiveWidth
            anchors.top: logoId.bottom
            placeholderId.text: textId.text == "" ? qsTr("VAT number") : ""
            KeyNavigation.tab: companyNameId.textId
            textId.focus: true
            textId.onFocusChanged: checkVat()
        }

        DesignTextInput {
            id: companyNameId
            width: responsiveWidth
            anchors.top: vatNumberId.bottom
            anchors.topMargin: 10
            placeholderId.text: textId.text == "" ? qsTr("Company name") : ""
            textId.onAccepted: validate()
        }

        DesignButton {
            id: registerButtonId
            width: responsiveWidth
            anchors.top: companyNameId.bottom
            anchors.topMargin: 30
            text: qsTr("Register (step 1/2)")
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

