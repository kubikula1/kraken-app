
import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1
import Qt.labs.settings 1.0

ApplicationWindow {
    visible: true
    id: mainWindow
    width: 360
    height: 520
    title: qsTr("Kraken")

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            spacing:20

            Label {
                id: titleLabel
                text: "Nadpis"
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ToolButton {
                icon.name: "menu"
                onClicked: optionsMenu.open()

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    MenuItem {
                        text: "O aplikaci"
                        onTriggered: aboutDialog.open()
                    }
                }
            }
        }
    }

    Dialog {
        id: aboutDialog
        modal: true
        focus: true
        title: "O aplikaci"
        x: (mainWindow.width - width) / 2
        y: mainWindow.height / 10
        width: Math.min(mainWindow.width, mainWindow.height) / 3 * 2
        contentHeight: aboutColumn.height

        Column {
            id: aboutColumn
            spacing: 20

            Label {
                width: aboutDialog.availableWidth
                text: "Tato aplikae vznikla jako školní projekt do předmětu Mobilní technologie na fakultě informatiky ve Zlíně. "
                      +"Jedná se o aplikaci zobrazující data z crypto burzy Kraken"
                wrapMode: Label.Wrap
                font.pixelSize: 12
                horizontalAlignment: Label.AlignJustify
                verticalAlignment: Label.AlignJustify
            }

            Label {
                width: aboutDialog.availableWidth
                text: "Apliace vyžaduje pro svou funkčnost přístup k internetu. "
                    + "Můžou být účtovány poplatky za datový provoz dle váší smlouvy s operátorem.\n\n"
                    + "Autor nenese žádnou odpovědnost za škody vzniklé  použiváním této aplikace"
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }
        }
    }
}
