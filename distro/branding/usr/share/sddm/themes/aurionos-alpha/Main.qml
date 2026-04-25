import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0

Rectangle {
    id: root
    color: "#081014"

    Image {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        opacity: 0.85
    }

    Rectangle {
        width: 440
        height: 310
        radius: 10
        color: "#10181dcc"
        border.color: "#f2bf63"
        anchors.centerIn: parent

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 28
            spacing: 14

            Text {
                text: "AurionOS"
                color: "#eef8f8"
                font.pixelSize: 34
                font.bold: true
                Layout.fillWidth: true
            }

            Text {
                text: "Alpha Fast Track v0.1"
                color: "#f2bf63"
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            TextField {
                id: user
                placeholderText: "Utente"
                text: userModel.lastUser
                Layout.fillWidth: true
            }

            TextField {
                id: password
                placeholderText: "Password"
                echoMode: TextInput.Password
                Layout.fillWidth: true
                Keys.onReturnPressed: sddm.login(user.text, password.text, session.currentIndex)
            }

            ComboBox {
                id: session
                model: sessionModel
                textRole: "name"
                Layout.fillWidth: true
            }

            Button {
                text: "Accedi"
                Layout.fillWidth: true
                onClicked: sddm.login(user.text, password.text, session.currentIndex)
            }
        }
    }
}
