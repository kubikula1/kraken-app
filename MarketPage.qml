
import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1
import Qt.labs.settings 1.0


Item {

    id: marketPage
    property string errorMsg: ""
    property string tit: "Market"
    property int time: 0

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
            text: "Updated: " + marketPage.time + " sec(s) ago"
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
        anchors.top: marketPage.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.topMargin: 50
        visible: marketPage.errorMsg !== undefined
        text: marketPage.errorMsg
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
                    //onClicked: stackView.push(model.source)
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

    function getData() {
        var xmlhttp = new XMLHttpRequest();
        var url = "https://api.kraken.com/0/public/Ticker?pair= BCHEUR, BCHXBT, DASHEUR, DASHXBT, EOSEUR, EOSXBT";
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState === XMLHttpRequest.DONE) {
                var parsedData = xmlhttp.responseText ? JSON.parse(xmlhttp.responseText) : null
                if (parsedData) {
                    // uspech
                    marketPage.errorMsg = ""
                    marketPage.time = 0
                    busyIndication.running = false
                    updateTimeout.stop()
                    listview.model.clear()
                    for (var prop in parsedData.result) {
                        var percent =100- (parsedData.result[prop].a[0]/parsedData.result[prop].o)*100
                        percent = percent.toFixed(2)
                        console.log(percent)
                        listview.model.append({curency: prop, value:parsedData.result[prop].a[0], variace: percent})
                     }
                } else {
                    // problem s komunikaci
                    if (xmlhttp.status === 0) {
                        // neni pripojeni k internetu
                        marketPage.errorMsg = "Unable connect to server"
                    } else if (parsedData && parsedData.message) {
                        // server odpovedel ale dotaz nebyl zpracovan
                        marketPage.errorMsg = parsedData.message
                    } else {
                        marketPage.errorMsg = "Request error: " + xmlhttp.status + " / " + xmlhttp.statusText
                    }
                }
                updateTimeout.start()
            }
        }

        xmlhttp.open("GET", url, true);
        xmlhttp.send();
    }
    function myFunction(json) {
        var obj = JSON.parse(json);
        console.log(obj.result);
        listview.model.append( {jsondata: obj.a +" "+ obj.b })
    }
}

