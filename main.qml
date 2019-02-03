
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
    property int time: 0
    property string errorMsg: ""



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
                icon.source:"qrc:/icons/kraken/36x36/back.png"
                opacity: stackView.depth > 1 ? 1 : 0
                onClicked: {
                    stackView.pop()
                    mainWindow.tit = view.currentItem.tit
                }
            }

            Label {
                id: titleLabel
                text: mainWindow.tit
                font.pixelSize: 28
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }



            ToolButton {
                icon.source: "qrc:/icons/kraken/36x36/menu.png"
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

                    Component.onCompleted: refreshBtn.clicked()

                    width: 200
                    height: 150

                    Settings {
                        id: settings
                        property int refresh: 5
                    }

                    Timer {
                        id: timeCount
                        interval: 1000; running: true; repeat: true
                        onTriggered: time++
                    }

                    Timer {
                        id: updateTimeout
                        interval: (settings.refresh *1000); running: true; repeat: true
                        onTriggered: {
                            refreshBtn.clicked()
                        }
                    }

                    RowLayout {
                        anchors.fill: parent
                        spacing:20

                        Label {
                            anchors.top: parent.top
                            anchors.topMargin: 15
                            anchors.left: parent.left
                            anchors.leftMargin: 15
                            id: lastUpdateTxt
                            text: "Updated: " + time + " sec(s) ago"
                            elide: Label.ElideRight
                            Layout.fillWidth: true
                        }


                        BusyIndicator {
                           id: busyIndication
                           running: false
                           anchors.horizontalCenter: parent.horizontalCenter
                           anchors.verticalCenter: parent.verticalCenter
                        }


                        ToolButton {
                            id: refreshBtn
                            anchors.right: parent.right
                            anchors.rightMargin: 15
                            anchors.top:  parent.top
                            icon.source: "qrc:/icons/kraken/36x36/refresh.png"
                            opacity: !busyIndication.running
                            onClicked:   {
                                busyIndication.running = true
                                getData()
                            }
                        }
                    }

                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.topMargin: 50
                        visible: errorMsg !== undefined
                        text: errorMsg
                    }

                    ListModel {
                        id: model
                    }

                    ListView {
                        id: listview
                        interactive: false
                        anchors.fill: parent
                        anchors.topMargin: 80
                        model: model
                        delegate:Component {
                            id: modelData
                            ItemDelegate {
                                width: parent.width
                                Item{

                                    anchors.topMargin: 15
                                    //anchors.verticalCenter: parent.verticalCenter
                                    anchors.fill: parent

                                    anchors.leftMargin: 10
                                    anchors.left: parent.left
                                    Label{
                                        id: data;
                                        text: curency
                                    }
                                }
                                Item {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.fill: parent
                                    anchors.topMargin: 15

                                    anchors.leftMargin: 80
                                    anchors.left: parent.left
                                    Label {
                                        text: value
                                    }
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: stackView.push( Qt.createComponent("qrc:/curencyPage.qml").createObject(null, {"curency" : curency}))
                                   /* onClicked: stackView.push("qrc:/curencyPage.qml")
                                    {item: Qt.resolvedUrl("MyRectangle.qml"), properties: {"color" : "red"}});*/
                                }
                                Image {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 10
                                    anchors.verticalCenter: parent.verticalCenter
                                    source: "qrc:/icons/kraken/36x36/next.png"
                                }
                                Item {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.fill: parent
                                    anchors.left: parent.left
                                    anchors.leftMargin:  220
                                    anchors.topMargin: 15

                                    Label {
                                        text: variace + " %"
                                    }
                                }

                                Image {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 50
                                    anchors.verticalCenter: parent.verticalCenter
                                    source: variace > 0 ?   "qrc:/icons/kraken/36x36/up.png" :"qrc:/icons/kraken/36x36/down.png"
                                }
                            }
                        }
                    }
                }

                Item {
                    id: settingPage
                    property string tit: "Settings"

                    ListView {
                        id: list
                        interactive: false
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
                                    onClicked: stackView.push(model.source)
                                }
                                Image {
                                    anchors.right: parent.right
                                    anchors.rightMargin: 15
                                    anchors.verticalCenter: parent.verticalCenter
                                    source: "qrc:/icons/kraken/36x36/next.png"
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
                text: "Tato aplikace vznikla jako školní projekt do předmětu Mobilní technologie na fakultě informatiky ve Zlíně. "
                      +"Jedná se o aplikaci zobrazující data z crypto burzy Kraken"
                wrapMode: Label.Wrap
                font.pixelSize: 14
                horizontalAlignment: Label.AlignJustify
                verticalAlignment: Label.AlignJustify
            }

            Label {
                width: aboutDialog.availableWidth
                text: "Apliace vyžaduje pro svou funkčnost přístup k internetu. "
                    + "Můžou být účtovány poplatky za datový provoz dle váší smlouvy s operátorem.\n\n"
                    + "Autor nenese žádnou odpovědnost za škody vzniklé  použiváním této aplikace"
                wrapMode: Label.Wrap
                font.pixelSize: 14
            }
        }
    }

    function getData() {
        var xmlhttp = new XMLHttpRequest();
        var url = "https://api.kraken.com/0/public/Ticker?pair= BCHEUR, BCHXBT, DASHEUR, DASHXBT, EOSEUR, EOSXBT";
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState === XMLHttpRequest.DONE) {
                var parsedData = xmlhttp.responseText ? JSON.parse(xmlhttp.responseText) : null
                if (parsedData) {
                    // uspech
                    errorMsg = ""
                    time = 0
                    busyIndication.running = false
                    updateTimeout.stop()
                    listview.model.clear()
                    for (var prop in parsedData.result) {
                        var percent = 100- (parsedData.result[prop].a[0]/parsedData.result[prop].o)*100
                        percent = percent.toFixed(2)
                        listview.model.append({curency: prop, value:parsedData.result[prop].a[0], variace: percent})
                     }
                } else {
                    // problem s komunikaci
                    if (xmlhttp.status === 0) {
                        // neni pripojeni k internetu
                        errorMsg = "Unable connect to server"
                    } else if (parsedData && parsedData.message) {
                        // server odpovedel ale dotaz nebyl zpracovan
                        errorMsg = parsedData.message
                    } else {
                        errorMsg = "Request error: " + xmlhttp.status + " / " + xmlhttp.statusText
                    }
                }
                updateTimeout.start()
            }
        }

        xmlhttp.open("GET", url, true);
        xmlhttp.send();
    }
}

