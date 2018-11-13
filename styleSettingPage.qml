import QtQuick 2.6
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0


Pane {
    id: styleSetting
    padding: 0

    Settings {
        id: settings
        property string style: "Default"
    }

    ButtonGroup {
        id: radioButtonGroup
    }


    ListView {
        id: list
        width: parent.width
        height: parent.height
        model: availableStyles
        property string stl
        Component.onCompleted: {
            stl = settings.style
        }

        anchors.fill: parent
        delegate: Component {
            id: radioDelegateComponent
            RadioDelegate {
                width: list.width
                text: modelData
                ButtonGroup.group: radioButtonGroup
                checked: settings.style == modelData
                onClicked: {
                    settings.style = modelData
                }
            }
        }
        Label {
            id: label
            opacity: list.stl !== settings.style ? 1 : 0
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
