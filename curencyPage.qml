import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1


Item {
    property string curency

    id : curencyDetail
    anchors.fill: parent

    Label {
        id: name
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.right: parent.right
        text: "Today info about: " +curency
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
    }


    RowLayout {
        id: row1
        anchors.top: name.bottom
        anchors.left:  parent.left
        anchors.right:  parent.right

        anchors.topMargin: 10
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        Layout.fillWidth: true

        Label {
            id: low
            text: "Low: "
        }

        Label {
            anchors.right: parent.right
            id: low_value
        }
    }

    RowLayout {
        id: row2
        anchors.top: row1.bottom
        anchors.left: parent.left
        anchors.right:  parent.right
        anchors.topMargin: 10
        anchors.leftMargin: 15
        anchors.rightMargin: 15

        Label {
            id: high
            text: "High: "
        }

        Label {
            anchors.right: parent.right
            id: high_value
        }
    }

    RowLayout {
        id: row3
        anchors.top: row2.bottom
        anchors.left: parent.left
        anchors.right:  parent.right
        anchors.topMargin: 10
        anchors.leftMargin: 15
        anchors.rightMargin: 15

        Label {
            id: open
            text: "Open: "
        }

        Label {
            anchors.right: parent.right
            id: open_value
        }
    }

    RowLayout {
        id: row4
        anchors.top: row3.bottom
        anchors.left: parent.left
        anchors.right:  parent.right
        anchors.topMargin: 10
        anchors.leftMargin: 15
        anchors.rightMargin: 15

        Label {
            id: volume
            text: "Volume: "
        }

        Label {
            anchors.right: parent.right
            id: volume_value
        }
    }


    Component.onCompleted: {
        getDetail();
    }

    function getDetail() {
        var xmlhttp = new XMLHttpRequest();
        var url = "https://api.kraken.com/0/public/Ticker?pair=" + curency;
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState === XMLHttpRequest.DONE) {
                var parsedData = xmlhttp.responseText ? JSON.parse(xmlhttp.responseText) : null
                if (parsedData) {
                    // uspech
                    for (var prop in parsedData.result) {
                        var pom = parsedData.result[prop].a[0];
                        pom = parseFloat(pom)
                        low_value.text = pom.toFixed(5)

                        pom = parsedData.result[prop].h[0];
                        pom = parseFloat(pom)
                        high_value.text = pom.toFixed(5)

                        pom = parsedData.result[prop].o;
                        pom = parseFloat(pom)
                        open_value.text = pom.toFixed(5)

                        pom = parsedData.result[prop].v[0];
                        pom = parseFloat(pom)
                        volume_value.text = pom.toFixed(5)
                     }
                } else {
                    // problem s komunikaci
                    if (xmlhttp.status === 0) {
                        // neni pripojeni k internetu
                        curencyName.errorMsg = "Unable connect to server"
                    } else if (parsedData && parsedData.message) {
                        // server odpovedel ale dotaz nebyl zpracovan
                        curencyName.errorMsg = parsedData.message
                    } else {
                        curencyName.errorMsg = "Request error: " + xmlhttp.status + " / " + xmlhttp.statusText
                    }
                }
            }
        }

        xmlhttp.open("GET", url, true);
        xmlhttp.send();
    }
}
