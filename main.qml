import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id: mainWindow;
    visible: true
    width: 480;
    height: 800;
    title: qsTr("Move Detector")

    //header rectangle
    header: Rectangle{
        id: headerBar;
        width: mainWindow.width;
        implicitHeight: menuImage.height+menuImage.anchors.margins*2;
        gradient: headerGradient;

        //menu button image
        Image{
            id: menuImage;
            source: "qrc:/icons/menu.png";
            width: 60;
            height: 60;
            anchors.margins: 5;
            anchors.top: parent.top;
            anchors.left: parent.left;
            anchors.bottom: parent.bottom;
            smooth: true;

            MouseArea{
                anchors.fill: parent;
                onClicked: {
                    console.log("menu image clicked");
                    mainMenu.visible=true;
                }
            }
        }

        //header title text
        Text{
            anchors.centerIn: parent;
            font.pointSize: 25;
            horizontalAlignment: Text.AlignHCenter;
            text: "Move Detector";
        }

        //header gradient
        Gradient{
            id: headerGradient;
            GradientStop{
                position: 0;
                color:"steelblue";
            }
            GradientStop{
                position: 0.4;
                color: "lightsteelblue";
            }
            GradientStop{
                position: 0.8;
                color: "lightblue";
            }
        }

    }

    //main menu
    Menu{
        id: mainMenu;
        visible: false;
        font.pointSize: 15;
        spacing: 10;
        onAboutToShow: {
            menuAnimation.running=true;
        }
        onAboutToHide: menuAnimation.running=false;

//        MenuItem{
//            Text{
//                text: qsTr("Settings");
//                anchors.left: parent.left;
//                anchors.verticalCenter: parent.verticalCenter;
//                anchors.margins: 10;
//                horizontalAlignment: Text.AlignHCenter;
//                font.pointSize: 20;
//            }
//            onTriggered: {
//            }
//        }
//        MenuItem{
//            Text{
//                text: qsTr("Results");
//                anchors.left: parent.left;
//                anchors.verticalCenter: parent.verticalCenter;
//                anchors.margins: 10;
//                horizontalAlignment: Text.AlignHCenter;
//                font.pointSize: 20;
//            }
//            onTriggered: {
//            }
//        }
        MenuItem{
            Text{
                text: qsTr("Quit");
                anchors.left: parent.left;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.margins: 10;
                horizontalAlignment: Text.AlignHCenter;
                font.pointSize: 20;
            }
            onTriggered: Qt.quit();
        }
    }

    //main menu height animation
    PropertyAnimation{
        id: menuAnimation;
        target: mainMenu;
        properties: "height";
        from: 0;
        to: mainMenu.height;
        duration: 300;
    }

    //start button Rectangle
    Rectangle{
        id: startButton;
        visible: true;
        width: mainWindow.width/2;
        height: width/2;
        anchors.centerIn: parent;
        smooth: true;
        radius: 10;
        gradient: releasedGradient;
        border{
            color: "black";
            width: 1;
        }
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                startButton.visible=false;
                loaderRect.visible=true;
                headerBar.enabled=false;
                resultTxt.text="";
                moveHandler.slotStart();
            }
            onPressed: {
                parent.gradient=pressedGradient;
            }
            onReleased: {
                parent.gradient=releasedGradient;
            }
        }
        Text{
            anchors.centerIn: parent;
            horizontalAlignment: Text.AlignHCenter;
            font.pointSize: 25;
            text: qsTr("Start");
        }
    }

    //loader rectangle
    Rectangle{
        id: loaderRect;
        anchors.centerIn: parent;
        width: parent.width/3;
        height: width;
        visible: false;

        Column{
            anchors.fill: parent;
            anchors.margins: 10;
            spacing: 10;
            BusyIndicator{
                width: parent.width;
                height: width;
                anchors.horizontalCenter: parent.horizontalCenter;
            }
            Text{
                anchors.horizontalCenter: parent.horizontalCenter;
                horizontalAlignment: Text.AlignHCenter;
                font.pointSize: 24;
                text: qsTr("Running\nClick to stop");
            }
        }
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                loaderRect.visible=false;
                startButton.visible=true;
                headerBar.enabled=true;

                moveHandler.slotStop();
            }
        }
    }

    //footer rectangle
    footer: Rectangle{
        width: parent.width;
        height: resultTxt.height+resultTxt.anchors.margins*2;
        Text{
            id: resultTxt;
            anchors.centerIn: parent;
            anchors.margins: 5;
            font.pointSize: 20;
        }
    }

    //start button pressed gradient;
    Gradient{
        id: pressedGradient;
        GradientStop{
            position: 0;
            color: "lightblue";
        }
        GradientStop{
            position: 0.4;
            color: "lightsteelblue";
        }
        GradientStop{
            position: 0.8;
            color: "steelblue";
        }
    }

    //start button release gradient
    Gradient{
        id: releasedGradient;
        GradientStop{
            position: 0;
            color:"steelblue";
        }
        GradientStop{
            position: 0.4;
            color: "lightsteelblue";
        }
        GradientStop{
            position: 0.8;
            color: "lightblue";
        }
    }

    //connections
    Connections{
        target: moveHandler;
        onSignalStop: {
            resultTxt.text="Work time: " + hms(workTime) + "\nMove time: " + hms(moveTime);
        }
    }

    //js function seconds to hh:mm:ss format
    function hms(seconds) {
      return [3600, 60]
        .reduceRight(
          (p, b) => r => [Math.floor(r / b)].concat(p(r % b)),
          r => [r]
        )(seconds)
        .map(a => a.toString().padStart(2, '0'))
        .join(':');
    }
}
