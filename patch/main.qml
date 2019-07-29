import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

Page {
    id: page

    property bool running: false
    property int tmpversion;

    QtObject{
        id:signalCenter;
        signal querySucceed(string ret);
        signal queryFailed;
    }

    ConfigurationGroup {
        id: config
        path: "/apps/phone.birdzhang"
        property int version: 20181128
    }

    SilicaFlickable {
        id: flickable
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
                text: "本程序由0312birdzhang制作，"+
                      "部分数据来自<a href=\"https://github.com/xluohome/phonedata\">https://github.com/xluohome/phonedata</a>，部分来自网络，"
                      + "不保证数据的完全准确性,请知悉。<br/>";
                onLinkActivated: {
                    Qt.openUrlExternally(link);
                }
            }
        }
    }
}
