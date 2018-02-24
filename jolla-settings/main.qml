import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import Nemo.Notifications 1.0
import io.thp.pyotherside 1.5

Page {
    id: page

    property bool running: false
    property int tmpversion;

    ConfigurationGroup {
        id: config
        path: "/apps/phone.birdzhang"
        property int version: 20180223
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
        expireTimeout: 3000
    }

    Python{
        id: py

        signal updated(bool flag)

        Component.onCompleted: {
            setHandler('updated', updated);
            addImportPath('.');
            py.importModule('main', function () {

            })
        }

        function checkVersion(){
            py.call_sync("main.getVersion",[],function(ret){
                if ( ret == 20180131){
                    notification.show("检查版本出错");
                    running = false;
                    return false;
                }
                if ( ret > config.version){
                    tmpversion = ret;
                    return true;
                }else{
                    return false;
                }
            })
        }

        function updateDB(version){
            py.call("main.updateDB",[version],function(ret){});
        }

        onUpdated:{
            if(flag){
                config.version = tmpversion;
                flickable.children[0].children[4].text = "更新";
                notification.show("更新成功")
                running = false;
            }else{
                notification.show("发生了错误");
                flickable.children[0].children[4].text = "更新";
                running = false;
            }
            
        }

        onError: {
            console.log('Error: ' + traceback)
            notification.show("发生了错误");
            flickable.children[0].children[4].text = "更新";
            running = false;
        }
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
                text: "本程序由0312birdzhang制作，\n"+
                      "部分数据来自<a href=\"https://github.com/xluohome/phonedata\">https://github.com/xluohome/phonedata</a>,部分来自网络。\n"
                     + "不保证数据的完全准确性,请知悉。\n\n"
                     + "当前数据库版本：" + config.version;
                onLinkActivated: {
                    Qt.openUrlExternally(link);
                }
            }

            SectionHeader {
                text: "更新数据"
            }

            Button {
                text: "更新"
                enabled: !running
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    if(py.checkVersion()){
                        running = true;
                        py.updateDB(tmpversion);
                        text = "更新中..."
                        notification.show("正在更新，请勿关闭页面");
                    }else{
                        notification.show("已是最新版本，无需更新")
                    }
                }
            }
        }
    }
}
