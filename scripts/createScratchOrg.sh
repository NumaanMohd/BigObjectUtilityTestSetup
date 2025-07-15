#! /bin/bash
# ECHO COMMAND
while [ ! -n "$ORG_NAME"  ]
do
    echo "Please enter a alias name for your scratch org:"
    read ORG_NAME
done
echo "🚀 Building your org, please wait..."
RES=$(sf org create scratch -f config/project-scratch-def.json -d -y 30 -a "${ORG_NAME}" -v Cloudbat_DevHubOriginal --json)
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
sf org assign permset -n Custom_Big_Objects_Field_Access -o ${ORG_NAME}

echo "🤘 Loading Account data into scratch org..."
sf data upsert bulk --sobject Account --file "dataImportFiles\Account.csv" --external-id External_Id__c -w 5 -o "${ORG_NAME}" 

echo "⏲ Installing package, please wait. It may take a while."
sf package install -p 04tGA000005Viy9 -o "${ORG_NAME}" -w 5

if [ "$?" = "1" ]
then
  echo "🐼 "
    echo "🐼 ERROR: Installing Package"
  echo "🐼 "
    read -n 1 -s -r -p "🐼 Press any key to continue"
    exit
fi
echo "🤘 Deploying LWC tab and flexi page in scratch org..."
sf project deploy start -c -d "force-app\main\postPackageInstall" -o "${ORG_NAME}" 

printf "\n Assigning Custom_Big_Object_Utility_Tab_Access permission set...."
sf org assign permset -n Custom_Big_Object_Utility_Tab_Access -n cloudbat__BigObjectUtilityAppAccess -o "${ORG_NAME}"

echo "🎯Script executed successfully......."

sh ./scripts/batLogo.sh