import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import Nemo.Notifications 1.0


Page {
    id: page

    property bool running: false

    Notification{
        id: notification
        function show(message, icn) {
            replacesId = 0
            previewSummary = ""
            previewBody = message
            icon = icn ? icn : ""
            publish()
        }
        expireTimeout: 3000
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height
        Column {
            id: content
            width: parent.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: "来电归属地"
            }

            SectionHeader{
                text: "关于"
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                textFormat: Text.StyledText
                linkColor:Theme.primaryColor
                horizontalAlignment: Text.AlignHCenter
                text: "本程序由0312birdzhang制作，\n"+
                      "部分数据来自<a href=\"https://github.com/xluohome/phonedata\">https://github.com/xluohome/phonedata</a>,部分来自网络。\n"
                     +"不保证数据的完全准确性,请知悉。"
            }

            SectionHeader {
                text: "更新数据"
            }

            Button {
                text: "更新"
                enabled: !running
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    notification.show("暂未实现，敬请期待！")
                }
            }
        }
    }
}
