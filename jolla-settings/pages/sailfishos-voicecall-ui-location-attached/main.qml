import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height
        interactive: contentHeight > height

        Column {
	    id: content
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: "来电归属地"
            }
			
	    Label {
                width: parent.width
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                text: "Created by 0312birdzhang"
            }
						
	    Item {
		    width: 1
               	    height: 70
		}	
			
	    Label {
                text: "Update Datas"
                width: parent.width
		wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
            }

            Button {
                text: "更新数据"
                width: 200
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                //
		}
            }		
        }
    }
}
