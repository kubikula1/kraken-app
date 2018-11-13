
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
    property string tit: "Market"

    Shortcut {
        sequences: ["Esc", "Back"]
        enabled: stackView.depth > 1
        onActivated: {
            stackView.pop()
        }
    }

    property var delegateComponentMap: {
        "StyleDelegate": itemDelegateSetting,
    }

    header: ToolBar {

        RowLayout {
            anchors.fill: parent
            spacing:20

            ToolButton {
                icon.name: "back"
                opacity: stackView.depth > 1 ? 1 : 0
                onClicked: {
                    stackView.pop()
                    mainWindow.tit = view.currentItem.tit
                }
            }

            Label {
                id: titleLabel
                text: mainWindow.tit
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }



            ToolButton {
                icon.name: "menu"
                onClicked: {
                    optionsMenu.open()
                }

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

    StackView {
        id: stackView
        anchors.fill: parent
        focus: true
        Keys.onReleased: if (event.key === Qt.Key_Back && stackView.depth > 1) {
                             stackView.pop();
                             event.accepted = true;
                         }
        initialItem: Item {

            SwipeView {
                id: view
                currentIndex: 0
                anchors.fill: parent

                onCurrentIndexChanged: {
                    mainWindow.tit = currentItem.tit
                }

                Item {
                    id: marketPage
                    property string tit: "Market"

                    Label {
                        id: xxx
                        text: "Market"
                        font.pixelSize: 20
                        elide: Label.ElideRight

                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                        Layout.fillWidth: true
                    }
                }

                Item {
                    id: settingPage
                    property string tit: "Settings"


                    ListView {
                        id: list
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        model: ListModel {
                            ListElement { title: "Change style"; type: "StyleDelegate"; txt: "Style"; source:"qrc:/styleSettingPage.qml" }
                            ListElement { title: "Change refresh"; type: "StyleDelegate"; txt: "Refresh value"; source: "qrc:/refrestSettingPage.qml" }
                        }

                        anchors.fill: parent
                        delegate: Component {
                            id: itemDelegateSetting
                            ItemDelegate {
                                text: txt
                                width: parent.width
                                MouseArea {
                                    anchors.fill: parent
                                        onClicked:{
                                            stackView.push(model.source)
                                            mainWindow.tit = model.title
                                        }
                                }
                                Image {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 15
                                    anchors.verticalCenter: parent.verticalCenter
                                    source: "qrc:/icons/kraken/20x20/next.png"
                                }
                            }
                        }
                     }
                }
            }
            PageIndicator {
                id: indicator
                count: view.count
                currentIndex: view.currentIndex
                anchors.bottom: view.bottom
                anchors.horizontalCenter: parent.horizontalCenter
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
