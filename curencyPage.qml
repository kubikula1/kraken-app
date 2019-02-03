import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1


Item {
    property string curency

    id : curencyDetail
    Label {
        id: pom
        text: "Updated:" + curency +"  sec(s) ago"

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
                        var percent = 100- (parsedData.result[prop].a[0]/parsedData.result[prop].o)*100
                        percent = percent.toFixed(2)
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
}
