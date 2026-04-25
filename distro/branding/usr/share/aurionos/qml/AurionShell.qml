import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: root
    width: 1240
    height: 760
    visible: true
    title: "AurionOS QML Shell Alpha"
    color: "#080d11"

    property color panel: "#10171c"
    property color panel2: "#151f25"
    property color line: "#273741"
    property color textColor: "#edf6f7"
    property color muted: "#9badb5"
    property color teal: "#35d0cf"
    property color gold: "#f2bf63"
    property string activePage: "desktop"

    Component.onCompleted: {
        for (var i = 0; i < Qt.application.arguments.length - 1; i++) {
            if (Qt.application.arguments[i] === "--aurion-page") {
                activePage = Qt.application.arguments[i + 1]
            }
        }
    }

    function action(name) {
        Qt.openUrlExternally("aurion-action://" + encodeURIComponent(name))
    }

    Rectangle {
        anchors.fill: parent
        color: root.color

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 50
            color: "#0b1116"
            border.color: root.line

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 14

                Text {
                    text: "A"
                    color: root.gold
                    font.pixelSize: 24
                    font.bold: true
                }
                Text {
                    text: "AurionOS"
                    color: root.textColor
                    font.pixelSize: 15
                    font.bold: true
                }
                Item { Layout.fillWidth: true }
                Repeater {
                    model: ["Desktop", "Store", "Hardware", "Diagnostics", "AI"]
                    delegate: Button {
                        text: modelData
                        onClicked: activePage = modelData.toLowerCase()
                    }
                }
            }
        }

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 68
            anchors.margins: 18
            spacing: 18

            Rectangle {
                Layout.preferredWidth: 220
                Layout.fillHeight: true
                radius: 8
                color: root.panel
                border.color: root.line

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 10

                    Text {
                        text: "Command Center"
                        color: root.textColor
                        font.pixelSize: 18
                        font.bold: true
                    }
                    Text {
                        text: "Qt/QML alpha bridge"
                        color: root.muted
                        font.pixelSize: 12
                    }
                    Repeater {
                        model: [
                            ["Panoramica", "desktop"],
                            ["Store", "store"],
                            ["Hardware", "hardware"],
                            ["Diagnostica", "diagnostics"],
                            ["Assistente AI", "ai"],
                            ["Controllo", "control"]
                        ]
                        delegate: Button {
                            Layout.fillWidth: true
                            text: modelData[0]
                            onClicked: activePage = modelData[1]
                        }
                    }
                    Item { Layout.fillHeight: true }
                    Text {
                        text: "Secure Boot chain preserved"
                        color: root.teal
                        font.pixelSize: 12
                        wrapMode: Text.WordWrap
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 8
                color: root.panel
                border.color: root.line

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 18

                    Text {
                        text: activePage === "desktop" ? "Ciao! Sono Aurion." :
                              activePage === "store" ? "Aurion Store" :
                              activePage === "hardware" ? "Hardware Center" :
                              activePage === "diagnostics" ? "Diagnostics" :
                              activePage === "ai" ? "Assistente AI locale" :
                              "Control Center"
                        color: root.textColor
                        font.pixelSize: 34
                        font.bold: true
                    }

                    Text {
                        Layout.fillWidth: true
                        text: activePage === "desktop" ? "La shell QML e' il ponte verso il desktop AurionOS finale. La sessione stabile resta LXQt." :
                              activePage === "store" ? "Catalogo app grafico, Flatpak-first, nessuna installazione silenziosa in alpha." :
                              activePage === "hardware" ? "Classificazione hardware read-only: Wi-Fi, GPU, boot e note driver." :
                              activePage === "diagnostics" ? "Report su boot, Secure Boot, installer, disco e log recenti." :
                              activePage === "ai" ? "Ollama con phi4-mini quando disponibile, fallback locale sicuro quando non c'e'." :
                              "Accesso rapido a sistema, Store, diagnostica, hardware, rollback e AI."
                        color: root.muted
                        font.pixelSize: 16
                        wrapMode: Text.WordWrap
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 3
                        rowSpacing: 12
                        columnSpacing: 12

                        Repeater {
                            model: [
                                ["Leggi email", "email"],
                                ["Installa app", "store"],
                                ["Controlla Wi-Fi", "hardware"],
                                ["Diagnosi", "diagnostics"],
                                ["Stato AI", "ai-setup"],
                                ["Installer", "installer"]
                            ]
                            delegate: Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 120
                                radius: 8
                                color: root.panel2
                                border.color: root.line

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 8

                                    Text {
                                        text: modelData[0]
                                        color: root.textColor
                                        font.pixelSize: 16
                                        font.bold: true
                                    }
                                    Text {
                                        text: "aurion-action://" + modelData[1]
                                        color: root.muted
                                        font.pixelSize: 12
                                        wrapMode: Text.WordWrap
                                    }
                                    Item { Layout.fillHeight: true }
                                    Button {
                                        text: "Apri"
                                        onClicked: action(modelData[1])
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 92
                        radius: 8
                        color: "#0b1116"
                        border.color: root.gold

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 16
                            Text {
                                Layout.fillWidth: true
                                text: "Alpha policy: QML e labwc sono preview. La ISO deve continuare a bootare e installare con la sessione LXQt stabile."
                                color: root.textColor
                                font.pixelSize: 14
                                wrapMode: Text.WordWrap
                            }
                            Button {
                                text: "Apri Experience"
                                onClicked: action("experience")
                            }
                        }
                    }
                }
            }
        }
    }
}
