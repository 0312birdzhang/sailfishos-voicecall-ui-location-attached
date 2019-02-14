import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import Nemo.Notifications 1.0
import io.thp.pyotherside 1.5

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

    Notification{
        id: notification
        function show(message, icn) {
            replacesId = 0
            previewSummary = ""
            previewBody = message
            icon = icn ? icn : ""
            publish()
        }
        expireTimeout: 2000
    }

    Python{
        id: py

        signal updated(bool flag)

        Component.onCompleted: {
            setHandler('updated', updated);
            addImportPath(Qt.resolvedUrl('.'));
            py.importModule('main', function () {

            })
        }

        function queryNum(num){
            py.call("main.getLocation",[num],function(ret){
                signalCenter.querySucceed(ret);
            });
        }

        onError: {
            console.log('Error: ' + traceback)
            notification.show("发生了错误");
            running = false;
        }
    }

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: content.height

        PullDownMenu{
            MenuItem {
                text: "查询手机号"
                onClicked: pageStack.push(queryPhone)
            }
        }

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

    Component{
        id: queryPhone
        Page{

            SilicaFlickable{
                id: flick
                anchors.fill: parent
                contentHeight: column.height + retLabel.height
                Column{
                    id: column
                    anchors { left: parent.left; right: parent.right }
                    spacing: Theme.paddingLarge
                    Item {
                        height: Theme.itemSizeMedium
                        width: parent.width
                    }
                    TextField {
                        id: phonenum
                        anchors { left: parent.left; right: parent.right }
                        label: "输入号码"
                        focus: true;
                        inputMethodHints:Qt.ImhDigitsOnly
                        placeholderText: label
                        EnterKey.enabled: text && text.length > 2
                        EnterKey.iconSource: "image://theme/icon-m-search"
                        EnterKey.onClicked: {
                            py.queryNum(text)
                        }
                    }

                    Button{
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                        }
                        text: "查询"
                        enabled: phonenum.text && phonenum.text.length > 2
                        onClicked: {
                            py.queryNum(phonenum.text)
                        }
                    }
                }

                Label {
                    id:retLabel
                    anchors{
                        top:column.bottom
                        topMargin: Theme.paddingLarge * 4
                        horizontalCenter: parent.horizontalCenter
                    }
                    width: column.width
                    color: Theme.highlightColor
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font.pixelSize: Theme.fontSizeExtraSmall
                }
            }

            Connections{
                target: signalCenter
                onQuerySucceed:{
                    retLabel.text = ret;
                }
                onQueryFailed: {
                    retLabel.text = "查询失败！"
                }
            }

            Component.onCompleted: {
                if(Clipboard.hasText && !isNaN(Clipboard.text)){
                    flick.children[0].text = Clipboard.text
                }
            }

        }
    }
}
