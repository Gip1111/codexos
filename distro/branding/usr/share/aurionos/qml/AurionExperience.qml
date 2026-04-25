import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

ApplicationWindow {
    id: root
    width: 1120
    height: 680
    minimumWidth: 980
    minimumHeight: 620
    visible: true
    flags: Qt.Window | Qt.FramelessWindowHint
    title: "Aurion Experience"
    color: "#00000000"

    property color bg: "#081014"
    property color panel: "#10181d"
    property color panel2: "#151f25"
    property color line: "#273740"
    property color textColor: "#eef8f8"
    property color muted: "#9dadb5"
    property color teal: "#35d0cf"
    property color gold: "#f2bf63"
    property color green: "#56df8e"

    function action(name) {
        Qt.openUrlExternally("aurion-action://" + encodeURIComponent(name))
    }

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: root.bg
        border.color: root.line

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 52
            color: "#10161b"
            border.color: root.line

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 14
                spacing: 12

                Image {
                    source: "file:///usr/share/icons/hicolor/scalable/apps/aurion-experience.svg"
                    Layout.preferredWidth: 34
                    Layout.preferredHeight: 34
                    fillMode: Image.PreserveAspectFit
                }

                ColumnLayout {
                    spacing: 0
                    Text { text: "Aurion Experience"; color: root.textColor; font.pixelSize: 16; font.bold: true }
                    Text { text: "Command Center"; color: root.gold; font.pixelSize: 11; font.bold: true }
                }

                Item { Layout.fillWidth: true }

                Button { text: "-"; onClicked: root.showMinimized() }
                Button { text: "x"; onClicked: Qt.quit() }
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.topMargin: 52
            spacing: 0

            Rectangle {
                Layout.preferredWidth: 155
                Layout.fillHeight: true
                color: "#0b1216"
                border.color: root.line

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    Repeater {
                        model: [
                            ["Panoramica", "experience"],
                            ["Sistema", "status"],
                            ["Rete", "hardware"],
                            ["Sicurezza", "security"],
                            ["Software", "store"],
                            ["Servizi", "diagnostics"],
                            ["Impostazioni", "settings"]
                        ]
                        delegate: Button {
                            Layout.fillWidth: true
                            text: modelData[0]
                            onClicked: action(modelData[1])
                        }
                    }

                    Item { Layout.fillHeight: true }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 62
                        radius: 8
                        color: "#151f25"
                        border.color: root.line
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            Image {
                                source: "file:///usr/share/icons/hicolor/scalable/apps/aurionos.svg"
                                Layout.preferredWidth: 38
                                Layout.preferredHeight: 38
                            }
                            ColumnLayout {
                                spacing: 1
                                Text { text: "AurionOS Alpha"; color: root.textColor; font.pixelSize: 12 }
                                Text { text: "v0.1"; color: root.muted; font.pixelSize: 10 }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: root.bg

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.margins: 24
                        spacing: 14

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            ColumnLayout {
                                Layout.fillWidth: true
                                RowLayout {
                                    spacing: 6
                                    Text { text: "Ciao! Sono"; color: root.textColor; font.pixelSize: 28; font.bold: true }
                                    Text { text: "Aurion."; color: root.gold; font.pixelSize: 28; font.bold: true }
                                }
                                Text { text: "Il tuo ambiente. Le tue regole."; color: root.muted; font.pixelSize: 15 }
                            }
                            Canvas {
                                Layout.preferredWidth: 310
                                Layout.preferredHeight: 80
                                onPaint: {
                                    var ctx = getContext("2d")
                                    ctx.clearRect(0, 0, width, height)
                                    var g = ctx.createLinearGradient(0, 40, width, 40)
                                    g.addColorStop(0, "rgba(53,208,207,0)")
                                    g.addColorStop(0.45, "rgba(53,208,207,1)")
                                    g.addColorStop(1, "rgba(242,191,99,1)")
                                    ctx.strokeStyle = g
                                    ctx.lineWidth = 3
                                    ctx.beginPath()
                                    ctx.moveTo(0, 52)
                                    ctx.bezierCurveTo(95, 70, 125, 5, 210, 40)
                                    ctx.bezierCurveTo(250, 56, 265, 8, 310, 18)
                                    ctx.stroke()
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 96
                            radius: 8
                            color: root.panel
                            border.color: root.line
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 12
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Text { text: "Dimmi cosa vuoi fare?"; color: root.muted; font.pixelSize: 22 }
                                    Text { text: "Esempi: installa LibreOffice, pulisci la cache, mostra spazio disco"; color: root.muted; font.pixelSize: 12 }
                                }
                                Button { text: "Invia"; onClicked: action("ai") }
                            }
                        }

                        Text { text: "Azioni rapide"; color: root.textColor; font.pixelSize: 13 }
                        GridLayout {
                            Layout.fillWidth: true
                            columns: 4
                            columnSpacing: 10
                            rowSpacing: 10
                            Repeater {
                                model: [
                                    ["aurion-browser.svg", "Leggi email", "Apri il tuo client di posta", "email"],
                                    ["aurion-store.svg", "Installa app", "Trova e installa nuove applicazioni", "store"],
                                    ["aurion-hardware.svg", "Controlla Wi-Fi", "Verifica lo stato della connessione", "hardware"],
                                    ["aurion-terminal.svg", "Diagnosi", "Controlla lo stato del sistema", "diagnostics"]
                                ]
                                delegate: Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 116
                                    radius: 8
                                    color: root.panel2
                                    border.color: root.line
                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 12
                                        spacing: 6
                                        Image {
                                            source: "file:///usr/share/icons/hicolor/scalable/apps/" + modelData[0]
                                            Layout.preferredWidth: 32
                                            Layout.preferredHeight: 32
                                        }
                                        Text { text: modelData[1]; color: root.textColor; font.pixelSize: 13; font.bold: true }
                                        Text { text: modelData[2]; color: root.muted; font.pixelSize: 11; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                                    }
                                    MouseArea { anchors.fill: parent; onClicked: action(modelData[3]) }
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 12
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: 8
                                color: root.panel
                                border.color: root.line
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    Text { text: "Attivita recenti"; color: root.textColor; font.pixelSize: 13; font.bold: true }
                                    Text { text: "Sistema aggiornato                                      ora"; color: root.muted; font.pixelSize: 12 }
                                    Text { text: "Hardware Center pronto                              ora"; color: root.muted; font.pixelSize: 12 }
                                    Text { text: "Store alpha disponibile                            ora"; color: root.muted; font.pixelSize: 12 }
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
                                    anchors.margins: 12
                                    Text { text: "Suggerimenti"; color: root.textColor; font.pixelSize: 13; font.bold: true }
                                    Text { text: "Attiva il backup automatico"; color: root.textColor; font.pixelSize: 13; font.bold: true }
                                    Text { text: "Proteggi i dati con snapshot programmati."; color: root.muted; font.pixelSize: 12; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                                    Button { text: "Configura ora"; onClicked: action("backup") }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 245
                        Layout.fillHeight: true
                        color: "#0c1317"
                        border.color: root.line

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 10

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 112
                                radius: 8
                                color: root.panel
                                border.color: root.line
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    Text { text: "Assistente AI"; color: root.textColor; font.pixelSize: 13; font.bold: true }
                                    Text { text: "Modalita: Locale (Privacy attiva)"; color: root.green; font.pixelSize: 11; font.bold: true }
                                    Text { text: "Nessun dato lascia il tuo dispositivo."; color: root.muted; font.pixelSize: 11 }
                                    Button { Layout.fillWidth: true; text: "Nuova conversazione"; onClicked: action("ai") }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 168
                                radius: 8
                                color: root.panel
                                border.color: root.line
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    Text { text: "Stato sistema"; color: root.textColor; font.pixelSize: 13; font.bold: true }
                                    Text { text: "CPU                         12%"; color: root.textColor; font.pixelSize: 12 }
                                    Text { text: "RAM                         27%"; color: root.textColor; font.pixelSize: 12 }
                                    Text { text: "Disco                       36%"; color: root.textColor; font.pixelSize: 12 }
                                    Text { text: "Temperatura                 49 C"; color: root.green; font.pixelSize: 12 }
                                    Button { Layout.fillWidth: true; text: "Dettagli sistema"; onClicked: action("status") }
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
                                    anchors.margins: 12
                                    Text { text: "Suggerimenti installazioni"; color: root.textColor; font.pixelSize: 13; font.bold: true }
                                    Repeater {
                                        model: [["OBS Studio", "install-obs"], ["GIMP", "install-gimp"], ["VLC Media Player", "install-vlc"]]
                                        delegate: RowLayout {
                                            Layout.fillWidth: true
                                            Text { Layout.fillWidth: true; text: modelData[0]; color: root.textColor; font.pixelSize: 12 }
                                            Button { text: "Installa"; onClicked: action(modelData[1]) }
                                        }
                                    }
                                    Button { Layout.fillWidth: true; text: "Mostra altre app"; onClicked: action("store") }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
