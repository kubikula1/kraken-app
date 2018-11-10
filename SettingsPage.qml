
import QtQuick 2.6
import QtQuick.Controls 2.0

Item {
    id: mainPage

    Label {
        width: aboutDialog.availableWidth
        text: "Nastavení aplikace "
        wrapMode: Label.Wrap
        font.pixelSize: 12
        horizontalAlignment: Label.AlignJustify
        verticalAlignment: Label.AlignJustify
    }
}
