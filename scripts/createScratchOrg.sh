#! /bin/bash
# ECHO COMMAND
while [ ! -n "$ORG_NAME"  ]
do
    echo "Please enter a alias name for your scratch org:"
    read ORG_NAME
done
echo "🚀 Building your org, please wait..."
RES=$(sf org create scratch -f config/project-scratch-def.json -d -y 3 -a "${ORG_NAME}" -v cloudbatDevHub --json)
if [ "$?" = "1" ]
then
  echo "💀 "
    echo "💀 ERROR: Can't create your org."
  echo "💀 "
    exit
fi
echo "🤘 Scratch org created successfully..."

echo "🤘 Deploying custom Big Objects and their permissions in scratch org..."
RES=$(sf project deploy start -o "${ORG_NAME}" -c -d "force-app/main/default")
echo "Deployment successfully..."

echo "Assigning permission set...."
sf org assign permset -n Big_Objects_Field_Access -o ${ORG_NAME}

echo "🤘 Loading Account data into scratch org..."
sf force data bulk upsert -s Account -f "dataImportFiles\Account.csv" -i External_Id__c -w 5 -o "${ORG_NAME}" 

echo "⏲ Installing package, please wait. It may take a while."
sf package install -p 04t7F000005IyZo -o "${ORG_NAME}" -w 5

if [ "$?" = "1" ]
then
  echo "🐼 "
    echo "🐼 ERROR: Installing Package"
  echo "🐼 "
    read -n 1 -s -r -p "🐼 Press any key to continue"
    exit
fi
echo "🤘 Deploying LWC tab and flexi page in scratch org..."
sf project deploy start -c -d "force-app\main\post" -o "${ORG_NAME}" 

echo -e "\n Assigning Big_Object_Utility_Tab_Access permission set...."
sf org assign permset -n Big_Object_Utility_Tab_Access -o "${ORG_NAME}"