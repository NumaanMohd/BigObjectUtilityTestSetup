#!/bin/bash
while [ ! -n "$ORG_NAME"  ]
do
    echo "Please enter a alias name for your scratch org:"
    read ORG_NAME
done
RES=$(sfdx force:source:deploy -u "${ORG_NAME}" -p "force-app\main\default\objects\Archived_Contact__b,force-app\main\default\permissionsets")
echo "🤘 Scratch org created successfully..."
for USER_NAME in $(sfdx force:data:record:get -u "${ORG_NAME}" -s User -w "FirstName=User" --json | jq -r '.result.Username')
do
echo "Username extracted ---------> ${USER_NAME}"
done
sfdx force:user:permset:assign -u ${ORG_NAME} --permsetname Big_Objects_Field_Access --targetusername ${USER_NAME} --json
echo "$?"
