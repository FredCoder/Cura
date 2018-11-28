// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import UM 1.3 as UM
import Cura 1.0 as Cura

Rectangle
{
    property var total_height: popupItemHeader.height + popupItemContent.height + footerControll.height + UM.Theme.getSize("narrow_margin").height * 2
    id: popupItemWrapper
    height: total_height

    border.width: UM.Theme.getSize("default_lining").width
    border.color: UM.Theme.getColor("lining")

    Item
    {
        id: popupItemHeader
        height: 36

        anchors
        {
            top: parent.top
            right: parent.right
            left: parent.left
        }

        Label
        {
            id: popupItemHeaderText
            text: catalog.i18nc("@label", "Print settings");
            font: UM.Theme.getFont("default")
            renderType: Text.NativeRendering
            verticalAlignment: Text.AlignVCenter
            color: UM.Theme.getColor("text")
            height: parent.height

            anchors
            {
                topMargin: UM.Theme.getSize("sidebar_margin").height
                left: parent.left
                leftMargin: UM.Theme.getSize("narrow_margin").height
            }
        }

        Rectangle
        {
            width: parent.width
            height: UM.Theme.getSize("default_lining").height
            anchors.top: popupItemHeaderText.bottom
            color: UM.Theme.getColor("action_button_border")


        }

        Button
        {
            id: closeButton;
            width: UM.Theme.getSize("message_close").width;
            height: UM.Theme.getSize("message_close").height;

            anchors
            {
                right: parent.right;
                rightMargin: UM.Theme.getSize("default_margin").width;
                top: parent.top;
                topMargin: 10
            }

            UM.RecolorImage
            {
                anchors.fill: parent;
                sourceSize.width: width
                sourceSize.height: width
                color: UM.Theme.getColor("message_text")
                source: UM.Theme.getIcon("cross1")
            }

            onClicked: base.togglePopup() // Will hide the popup item

            background: Rectangle
            {
                color: UM.Theme.getColor("message_background")
            }
        }
    }

    Rectangle
    {
        id: popupItemContent
        width: parent.width
        height: tabBar.height + sidebarContents.height

        anchors
        {
            top: popupItemHeader.bottom
            topMargin: UM.Theme.getSize("narrow_margin").height
            right: parent.right
            left: parent.left
            leftMargin: UM.Theme.getSize("default_margin").width
            rightMargin: UM.Theme.getSize("default_margin").width
        }

        UM.TabRow
        {
            id: tabBar
            anchors.topMargin: UM.Theme.getSize("default_margin").height
            onCurrentIndexChanged: Cura.ExtruderManager.setActiveExtruderIndex(currentIndex)
            z: 1
            Repeater
            {
                model: extrudersModel
                delegate: UM.TabRowButton
                {
                    contentItem: Rectangle
                    {
                        z: 2
                        Cura.ExtruderIcon
                        {
                            anchors.horizontalCenter: parent.horizontalCenter
                            materialColor: model.color
                            extruderEnabled: model.enabled
                            width: parent.height
                            height: parent.height
                        }
                    }

                    background: Rectangle
                    {

                        width: parent.width
                        z: 1
                        border.width: UM.Theme.getSize("default_lining").width * 2
                        border.color: UM.Theme.getColor("action_button_border")

                        visible:
                        {
                            return index == tabBar.currentIndex
                        }

                        // overlap bottom border
                        Rectangle
                        {
                            width: parent.width - UM.Theme.getSize("default_lining").width * 4
                            height: UM.Theme.getSize("default_lining").width * 4
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: - (UM.Theme.getSize("default_lining").width * 2)
                            anchors.leftMargin: UM.Theme.getSize("default_lining").width * 2
                            anchors.left: parent.left

                        }
                    }
                }
            }
        }

        Rectangle
        {
            id: sidebarContents
            anchors.top: tabBar.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: UM.Theme.getSize("print_setup_widget").height

            border.width: UM.Theme.getSize("default_lining").width * 2
            border.color: UM.Theme.getColor("action_button_border")

            RecommendedPrintSetup
            {
                anchors.topMargin: UM.Theme.getSize("print_setup_content_top_margin").height
                anchors.fill: parent
                visible: currentModeIndex != 1
                onShowTooltip: base.showTooltip(item, location, text)
                onHideTooltip: base.hideTooltip()
            }

            CustomPrintSetup
            {
                anchors.topMargin: UM.Theme.getSize("print_setup_content_top_margin").height
                anchors.bottomMargin: 2 //don't overlap bottom border
                anchors.fill: parent
                visible: currentModeIndex == 1
                onShowTooltip: base.showTooltip(item, location, text)
                onHideTooltip: base.hideTooltip()
            }
        }
    }

    Item
    {
        id: footerControll
        anchors.top: popupItemContent.bottom
        anchors.topMargin: UM.Theme.getSize("narrow_margin").height * 2
        width: parent.width
        height: settingControlButton.height + UM.Theme.getSize("default_lining").height * 4
        Rectangle
        {
            width: parent.width
            height: UM.Theme.getSize("default_lining").height
            color: UM.Theme.getColor("action_button_border")
        }

        Cura.ActionButton
        {
            id: settingControlButton
            leftPadding: UM.Theme.getSize("default_margin").width
            rightPadding: UM.Theme.getSize("default_margin").width
            height: UM.Theme.getSize("action_panel_button").height
            text: catalog.i18nc("@button", "Custom")
            color: UM.Theme.getColor("secondary")
            hoverColor: UM.Theme.getColor("secondary")
            textColor: UM.Theme.getColor("primary")
            textHoverColor: UM.Theme.getColor("text")
            iconSourceRight: UM.Theme.getIcon("arrow_right")
            width: UM.Theme.getSize("print_setup_action_button").width
            fixedWidthMode: true
            visible: currentModeIndex == 0
            anchors
            {
                top: parent.top
                topMargin: UM.Theme.getSize("narrow_margin").height * 2
                bottomMargin: UM.Theme.getSize("narrow_margin").height * 2
                right: parent.right
                rightMargin: UM.Theme.getSize("narrow_margin").height
            }

            onClicked: currentModeIndex = 1
        }

        Cura.ActionButton
        {
            height: UM.Theme.getSize("action_panel_button").height
            text: catalog.i18nc("@button", "Recommended")
            color: UM.Theme.getColor("secondary")
            hoverColor: UM.Theme.getColor("secondary")
            textColor: UM.Theme.getColor("primary")
            textHoverColor: UM.Theme.getColor("text")
            iconSource: UM.Theme.getIcon("arrow_left")
            width: UM.Theme.getSize("print_setup_action_button").width
            fixedWidthMode: true
            visible: currentModeIndex == 1
            anchors
            {
                top: parent.top
                topMargin: UM.Theme.getSize("narrow_margin").height * 2
                bottomMargin: UM.Theme.getSize("narrow_margin").height * 2
                left: parent.left
                leftMargin: UM.Theme.getSize("narrow_margin").height
            }

            MouseArea {
                anchors.fill: parent
                onClicked: currentModeIndex = 0
            }
        }
    }

    Component.onCompleted:
    {
        var index = Math.round(UM.Preferences.getValue("cura/active_mode"))

        if(index != null && !isNaN(index))
        {
            currentModeIndex = index
        }
        else
        {
            currentModeIndex = 0
        }
    }
}