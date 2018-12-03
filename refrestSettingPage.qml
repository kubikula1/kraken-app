import QtQuick 2.6
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0


Pane {
    id: refreshSetting
    padding: 0

    Settings {
        id: settings
        property int refresh: 5
    }

    ButtonGroup {
        id: radioButtonGroup
    }


    ListView {
        id: list
        interactive: false
        width: parent.width
        height: parent.height
        property int ref
        Component.onCompleted: {
            ref = settings.refresh
        }
        model: ListModel {
            ListElement { data: "0"; }
             ListElement { data: "5"; }
             ListElement { data: "10"; }
             ListElement { data: "30"; }
             ListElement { data: "60"; }
             ListElement { data: "300"; }
        }

        anchors.fill: parent
        delegate: Component {
            id: radioDelegateComponent
            RadioDelegate {
                width: list.width
                text: modelData
                ButtonGroup.group: radioButtonGroup
                checked: settings.refresh == modelData
                onClicked: {
                    settings.refresh = modelData
                }
            }
        }
        Label {
            id: label
            opacity: list.ref !== settings.refresh ? 1 : 0
            anchors.bottom:  parent.bottom
            height: 50
            text: "Restart required"
            color: "#e41e25"
            anchors.left: parent.left
            anchors.leftMargin: 15
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
