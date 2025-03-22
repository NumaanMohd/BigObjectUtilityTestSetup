#! /bin/bash
# ECHO COMMAND
printf "Package uninstall in progress..."
while true; do
    read -p "Do you wish to uninstall this program? Have you unassigned Big Object Utility App Access permission set?" yn
    case $yn in
        [Yy]* ) make install; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
while [ ! -n "$ORG_NAME"  ]
do
    echo "Please enter a alias name for your scratch org:"
    read ORG_NAME
done
echo "🤘 Removing reference from LWC tab and flexi page in scratch org..."
sf project deploy start -c -d "force-app\main\packageUninstall" -o "${ORG_NAME}" 


echo "⏲ Uninstalling package, please wait. It may take a while."
sf package uninstall -p 04t7F000005Iyb1 -o "${ORG_NAME}" -w 5