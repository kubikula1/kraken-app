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
        width: parent.width
        height: parent.height
        model: ListModel {
            ListElement { data: "0"; }
             ListElement { data: "5"; }
             ListElement { data: "10"; }
             ListElement { data: "30"; }
             ListElement { data: "60"; }
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
    }
}
