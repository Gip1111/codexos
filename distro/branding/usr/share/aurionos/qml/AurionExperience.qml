import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

ApplicationWindow {
    id: root
    width: 1180
    height: 720
    minimumWidth: 1000
    minimumHeight: 640
    visible: true
    flags: Qt.Window | Qt.FramelessWindowHint
    title: "Aurion Experience"
    color: "transparent"

    property color bg: "#081014"
    property color panel: "#10181d"
    property color panel2: "#151f25"
    property color line: "#273740"
    property color textColor: "#eef8f8"
    property color muted: "#9dadb5"
    property color teal: "#35d0cf"
    property color gold: "#f2bf63"
    property color green: "#56df8e"
    property string activePage: "home"

    Component.onCompleted: {
        for (var i = 0; i < Qt.application.arguments.length - 1; i++) {
            if (Qt.application.arguments[i] === "--aurion-page") {
                setPage(Qt.application.arguments[i + 1])
            }
        }
    }

    function setPage(page) {
        if (page === "desktop" || page === "experience" || page === "overview") {
            activePage = "home"
        } else if (page === "apps") {
            activePage = "store"
        } else if (page === "assistant" || page === "ai-status") {
            activePage = "ai"
        } else {
            activePage = page || "home"
        }
    }

    function action(name) {
        Qt.openUrlExternally("aurion-action://" + encodeURIComponent(name))
    }

    function handleTask(text) {
        var q = text.toLowerCase()
        if (q.indexOf("mail") >= 0 || q.indexOf("email") >= 0 || q.indexOf("posta") >= 0) action("email")
        else if (q.indexOf("install") >= 0 || q.indexOf("app") >= 0 || q.indexOf("programma") >= 0) setPage("store")
        else if (q.indexOf("wifi") >= 0 || q.indexOf("driver") >= 0 || q.indexOf("hardware") >= 0) setPage("hardware")
        else if (q.indexOf("diagn") >= 0 || q.indexOf("errore") >= 0 || q.indexOf("sistema") >= 0) setPage("diagnostics")
        else if (q.indexOf("ai") >= 0 || q.indexOf("ollama") >= 0) setPage("ai")
        else setPage("control")
    }

    component AurionButton: Button {
        id: aurionButton
        property bool accent: false
        implicitHeight: 34
        leftPadding: 14
        rightPadding: 14
        contentItem: Text {
            text: aurionButton.text
            color: aurionButton.accent ? "#071115" : root.textColor
            font.pixelSize: 12
            font.bold: aurionButton.accent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        background: Rectangle {
            radius: 7
            color: aurionButton.down ? root.gold : (aurionButton.hovered ? "#1c2a30" : (aurionButton.accent ? root.gold : "#121b20"))
            border.color: aurionButton.accent ? root.gold : (aurionButton.hovered ? root.teal : root.line)
        }
    }

    component NavButton: Button {
        id: navButton
        property string pageName: "home"
        Layout.fillWidth: true
        implicitHeight: 40
        leftPadding: 12
        rightPadding: 8
        onClicked: root.setPage(pageName)
        contentItem: Text {
            text: navButton.text
            color: root.textColor
            font.pixelSize: 12
            font.bold: root.activePage === navButton.pageName
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            radius: 7
            color: root.activePage === navButton.pageName ? "#1f2117" : (navButton.hovered ? "#152127" : "transparent")
            border.color: root.activePage === navButton.pageName ? root.gold : "transparent"
        }
    }

    component ActionTile: Rectangle {
        property string iconName: "aurionos.svg"
        property string title: "Action"
        property string body: ""
        property string actionName: ""
        property string pageName: ""
        Layout.fillWidth: true
        Layout.preferredHeight: 118
        radius: 8
        color: root.panel2
        border.color: root.line

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 6
            Image {
                source: "file:///usr/share/icons/hicolor/scalable/apps/" + iconName
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                fillMode: Image.PreserveAspectFit
            }
            Text { text: title; color: root.textColor; font.pixelSize: 13; font.bold: true }
            Text { text: body; color: root.muted; font.pixelSize: 11; wrapMode: Text.WordWrap; Layout.fillWidth: true }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: pageName !== "" ? root.setPage(pageName) : root.action(actionName)
        }
    }

    component InfoCard: Rectangle {
        property string title: ""
        property string body: ""
        property string buttonText: ""
        property string actionName: ""
        property string pageName: ""
        Layout.fillWidth: true
        Layout.preferredHeight: 130
        radius: 8
        color: root.panel
        border.color: root.line

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 8
            Text { text: title; color: root.textColor; font.pixelSize: 15; font.bold: true }
            Text { text: body; color: root.muted; font.pixelSize: 12; wrapMode: Text.WordWrap; Layout.fillWidth: true }
            Item { Layout.fillHeight: true }
            AurionButton {
                visible: buttonText !== ""
                text: buttonText
                onClicked: pageName !== "" ? root.setPage(pageName) : root.action(actionName)
            }
        }
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
                    Text { text: "Native Command Center"; color: root.gold; font.pixelSize: 11; font.bold: true }
                }

                Item { Layout.fillWidth: true }

                RowLayout {
                    spacing: 6
                    AurionButton { text: "1"; implicitWidth: 34; accent: root.activePage === "home"; onClicked: root.setPage("home") }
                    AurionButton { text: "2"; implicitWidth: 34; accent: root.activePage === "store"; onClicked: root.setPage("store") }
                    AurionButton { text: "3"; implicitWidth: 34; accent: root.activePage === "hardware"; onClicked: root.setPage("hardware") }
                    AurionButton { text: "4"; implicitWidth: 34; accent: root.activePage === "ai"; onClicked: root.setPage("ai") }
                }

                AurionButton { text: "-"; implicitWidth: 34; onClicked: root.showMinimized() }
                AurionButton { text: "x"; implicitWidth: 34; onClicked: Qt.quit() }
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.topMargin: 52
            spacing: 0

            Rectangle {
                Layout.preferredWidth: 158
                Layout.fillHeight: true
                color: "#0b1216"
                border.color: root.line

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    NavButton { text: "Panoramica"; pageName: "home" }
                    NavButton { text: "Sistema"; pageName: "control" }
                    NavButton { text: "Rete"; pageName: "hardware" }
                    NavButton { text: "Sicurezza"; pageName: "diagnostics" }
                    NavButton { text: "Software"; pageName: "store" }
                    NavButton { text: "Servizi"; pageName: "control" }
                    NavButton { text: "AI"; pageName: "ai" }

                    Item { Layout.fillHeight: true }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 64
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
                                Text { text: "v0.1 native"; color: root.muted; font.pixelSize: 10 }
                            }
                        }
                    }
                }
            }

            Loader {
                Layout.fillWidth: true
                Layout.fillHeight: true
                sourceComponent: activePage === "store" ? storePage :
                                 activePage === "hardware" ? hardwarePage :
                                 activePage === "diagnostics" ? diagnosticsPage :
                                 activePage === "ai" ? aiPage :
                                 activePage === "control" ? controlPage : homePage
            }
        }
    }

    Component {
        id: homePage
        RowLayout {
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
                            Text { text: "Ciao! Sono"; color: root.textColor; font.pixelSize: 30; font.bold: true }
                            Text { text: "Aurion."; color: root.gold; font.pixelSize: 30; font.bold: true }
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
                    Layout.preferredHeight: 98
                    radius: 8
                    color: root.panel
                    border.color: root.line
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 12
                        ColumnLayout {
                            Layout.fillWidth: true
                            TextField {
                                id: taskInput
                                Layout.fillWidth: true
                                placeholderText: "Dimmi cosa vuoi fare?"
                                color: root.textColor
                                font.pixelSize: 21
                                background: Rectangle { color: "transparent" }
                                onAccepted: root.handleTask(text)
                            }
                            Text { text: "Esempi: installa LibreOffice, pulisci la cache, mostra spazio disco"; color: root.muted; font.pixelSize: 12 }
                        }
                        AurionButton { text: "Go"; accent: true; onClicked: root.handleTask(taskInput.text) }
                    }
                }

                Text { text: "Azioni rapide"; color: root.textColor; font.pixelSize: 13 }
                GridLayout {
                    Layout.fillWidth: true
                    columns: 4
                    columnSpacing: 10
                    rowSpacing: 10
                    ActionTile { iconName: "aurion-browser.svg"; title: "Leggi email"; body: "Apri il browser alla posta"; actionName: "email" }
                    ActionTile { iconName: "aurion-store.svg"; title: "Installa app"; body: "Store integrato"; pageName: "store" }
                    ActionTile { iconName: "aurion-hardware.svg"; title: "Controlla Wi-Fi"; body: "Hardware Center"; pageName: "hardware" }
                    ActionTile { iconName: "aurion-terminal.svg"; title: "Diagnosi"; body: "Report e riparazione guidata"; pageName: "diagnostics" }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 12
                    InfoCard { title: "Attivita recenti"; body: "Sistema aggiornato\nHardware Center pronto\nStore alpha disponibile"; buttonText: "Dettagli"; pageName: "control" }
                    InfoCard { title: "Suggerimenti"; body: "Attiva il backup automatico e prepara il percorso rollback."; buttonText: "Configura"; actionName: "backup" }
                }
            }

            RightRail {}
        }
    }

    Component {
        id: storePage
        RowLayout {
            spacing: 0
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 24
                spacing: 14
                Text { text: "Aurion Store"; color: root.textColor; font.pixelSize: 30; font.bold: true }
                Text { text: "Catalogo app integrato. In alpha non installa in modo silenzioso."; color: root.muted; font.pixelSize: 14 }
                GridLayout {
                    Layout.fillWidth: true
                    columns: 3
                    columnSpacing: 12
                    rowSpacing: 12
                    ActionTile { iconName: "aurion-browser.svg"; title: "Firefox"; body: "Browser web"; actionName: "browser" }
                    ActionTile { iconName: "aurion-store.svg"; title: "LibreOffice"; body: "Documenti e ufficio"; actionName: "install-libreoffice" }
                    ActionTile { iconName: "aurion-store.svg"; title: "VLC"; body: "Lettore multimediale"; actionName: "install-vlc" }
                    ActionTile { iconName: "aurion-store.svg"; title: "OBS Studio"; body: "Registrazione e streaming"; actionName: "install-obs" }
                    ActionTile { iconName: "aurion-files.svg"; title: "GIMP"; body: "Editing immagini"; actionName: "install-gimp" }
                    ActionTile { iconName: "aurion-terminal.svg"; title: "VS Code"; body: "Sviluppo"; actionName: "install-code" }
                }
                InfoCard { title: "Policy installazione"; body: "Flatpak-first, Snap opzionale, .deb solo con conferma chiara, AppImage integrata nel launcher."; buttonText: "Spiega con AI"; pageName: "ai" }
            }
            RightRail {}
        }
    }

    Component {
        id: hardwarePage
        RowLayout {
            spacing: 0
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 24
                spacing: 14
                Text { text: "Hardware Center"; color: root.textColor; font.pixelSize: 30; font.bold: true }
                Text { text: "Compatibilita read-only: nessun driver viene cambiato nella live."; color: root.muted; font.pixelSize: 14 }
                GridLayout {
                    Layout.fillWidth: true
                    columns: 3
                    columnSpacing: 12
                    rowSpacing: 12
                    ActionTile { iconName: "aurion-hardware.svg"; title: "GPU"; body: "Intel, AMD, NVIDIA"; actionName: "hardware-scan" }
                    ActionTile { iconName: "aurion-hardware.svg"; title: "Wi-Fi"; body: "Chipset e driver"; actionName: "hardware-scan" }
                    ActionTile { iconName: "aurion-snapshot.svg"; title: "Secure Boot"; body: "Stato MOK/UEFI"; actionName: "diagnostics-report" }
                    ActionTile { iconName: "aurion-terminal.svg"; title: "Disco"; body: "Spazio e filesystem"; actionName: "status-report" }
                    ActionTile { iconName: "aurion-terminal.svg"; title: "Report"; body: "Diagnostica completa"; pageName: "diagnostics" }
                    ActionTile { iconName: "aurion-assistant.svg"; title: "Spiega"; body: "AI locale o fallback"; pageName: "ai" }
                }
            }
            RightRail {}
        }
    }

    Component {
        id: diagnosticsPage
        RowLayout {
            spacing: 0
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 24
                spacing: 14
                Text { text: "Diagnostics"; color: root.textColor; font.pixelSize: 30; font.bold: true }
                Text { text: "Report leggibile prima di qualsiasi modifica al sistema."; color: root.muted; font.pixelSize: 14 }
                GridLayout {
                    Layout.fillWidth: true
                    columns: 3
                    columnSpacing: 12
                    rowSpacing: 12
                    ActionTile { iconName: "aurion-terminal.svg"; title: "Boot mode"; body: "UEFI o legacy"; actionName: "diagnostics-report" }
                    ActionTile { iconName: "aurion-snapshot.svg"; title: "Secure Boot"; body: "mokutil quando disponibile"; actionName: "diagnostics-report" }
                    ActionTile { iconName: "aurion-experience.svg"; title: "Desktop"; body: "Sessione e QML"; actionName: "desktop-check" }
                    ActionTile { iconName: "aurion-installer.svg"; title: "Installer"; body: "Calamares presente"; actionName: "diagnostics-report" }
                    ActionTile { iconName: "aurion-terminal.svg"; title: "Log errori"; body: "journalctl read-only"; actionName: "diagnostics-report" }
                    ActionTile { iconName: "aurion-assistant.svg"; title: "AI spiega"; body: "Interpreta report"; pageName: "ai" }
                }
            }
            RightRail {}
        }
    }

    Component {
        id: aiPage
        RowLayout {
            spacing: 0
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 24
                spacing: 14
                Text { text: "Assistente AI"; color: root.textColor; font.pixelSize: 30; font.bold: true }
                Text { text: "Locale per default. Cloud disabilitato finche l'utente non lo abilita esplicitamente."; color: root.muted; font.pixelSize: 14 }
                GridLayout {
                    Layout.fillWidth: true
                    columns: 3
                    columnSpacing: 12
                    rowSpacing: 12
                    ActionTile { iconName: "aurion-assistant.svg"; title: "Stato AI"; body: "Ollama e phi4-mini"; actionName: "ai-setup" }
                    ActionTile { iconName: "aurion-assistant.svg"; title: "Istruzioni"; body: "Come abilitare Ollama"; actionName: "ai-instructions" }
                    ActionTile { iconName: "aurion-assistant.svg"; title: "Installa Ollama"; body: "Runtime locale opzionale"; actionName: "ai-install-ollama" }
                    ActionTile { iconName: "aurion-assistant.svg"; title: "Scarica modello"; body: "Conferma esplicita"; actionName: "ai-pull-model" }
                    ActionTile { iconName: "aurion-hardware.svg"; title: "Spiega hardware"; body: "Diagnosi guidata"; pageName: "hardware" }
                    ActionTile { iconName: "aurion-terminal.svg"; title: "Spiega errori"; body: "Leggi diagnostica"; pageName: "diagnostics" }
                    ActionTile { iconName: "aurion-store.svg"; title: "Aiuto app"; body: "Scegli formato installazione"; pageName: "store" }
                }
                InfoCard { title: "Stato alpha"; body: "Se Ollama non e' pronto, Aurion usa il router locale sicuro. Nessun dato lascia il dispositivo."; buttonText: "Nuova conversazione"; actionName: "ai" }
            }
            RightRail {}
        }
    }

    Component {
        id: controlPage
        RowLayout {
            spacing: 0
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 24
                spacing: 14
                Text { text: "Control Center"; color: root.textColor; font.pixelSize: 30; font.bold: true }
                Text { text: "Superfici native per sistema, software, hardware, rollback e AI."; color: root.muted; font.pixelSize: 14 }
                GridLayout {
                    Layout.fillWidth: true
                    columns: 3
                    columnSpacing: 12
                    rowSpacing: 12
                    ActionTile { iconName: "aurion-terminal.svg"; title: "Stato sistema"; body: "aurion-status"; actionName: "status-report" }
                    ActionTile { iconName: "aurion-store.svg"; title: "Store"; body: "Catalogo app"; pageName: "store" }
                    ActionTile { iconName: "aurion-hardware.svg"; title: "Hardware"; body: "Compatibilita"; pageName: "hardware" }
                    ActionTile { iconName: "aurion-snapshot.svg"; title: "Rollback"; body: "Snapshot plan"; actionName: "backup" }
                    ActionTile { iconName: "aurion-assistant.svg"; title: "AI"; body: "Provider locale"; pageName: "ai" }
                    ActionTile { iconName: "aurion-installer.svg"; title: "Installer"; body: "Calamares"; actionName: "installer" }
                }
            }
            RightRail {}
        }
    }

    component RightRail: Rectangle {
        Layout.preferredWidth: 250
        Layout.fillHeight: true
        color: "#0c1317"
        border.color: root.line

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10
            InfoCard { title: "Assistente AI"; body: "Modalita: Locale\nNessun dato lascia il dispositivo."; buttonText: "Apri"; pageName: "ai" }
            InfoCard { title: "Stato sistema"; body: "CPU 12%\nRAM 27%\nDisco 36%\nTemperatura 49 C"; buttonText: "Dettagli"; actionName: "status-report" }
            InfoCard { title: "Suggerimenti"; body: "OBS Studio, GIMP e VLC sono pronti nel catalogo alpha."; buttonText: "Store"; pageName: "store" }
        }
    }
}
