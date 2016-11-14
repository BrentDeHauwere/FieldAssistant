import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Window 2.2 // Screen
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id: loginWindowId

    title: "Field Assistant"
    visible: true
    width: Screen.width
    minimumWidth: Screen.width/2
    height: Screen.height
    minimumHeight: Screen.height/2

    Loader {
        id: pageLoaderId

        property bool valid: item !== null

        anchors.fill: parent
        source: "LoginPage.qml"
        focus: true
    }

    //Component.onCompleted: userClass.doMessage()

    DesignInformationBar {
        id: msgId;
    }

    Connections { // Listens to the loaded page
        ignoreUnknownSignals: true
        target: pageLoaderId.valid ? pageLoaderId.item : null
        onGoToRegister: pageLoaderId.source = "RegisterPage.qml"
        onGoToRegister2: pageLoaderId.source = "RegisterPage2.qml"
        onGoToForgotPassword: pageLoaderId.source = "ForgotPasswordPage.qml"
        onGoToLogin: pageLoaderId.source = "LoginPage.qml"
        onGoToDashboard: pageLoaderId.source = "DashboardPage.qml"
        onForgotPassword: pageLoaderId.source = "ResetPasswordPage.qml"
        onConfirmReset: pageLoaderId.source = "LoginPage.qml"
        onMsg: {msgId.errorMsg = errorMsg; msgId.infoMsg = infoMsg; msgId.textMsg = text; msgId.running = false; msgId.running = true}
    }

    Connections { // Listens to the C++ class "User
        ignoreUnknownSignals: true
        target: userClass
        onMsg: {msgId.errorMsg = errorMsg; msgId.infoMsg = infoMsg; msgId.textMsg = text; msgId.running = false; msgId.running = true}
    }
}
