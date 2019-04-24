#!/bin/bash

################## FUNCTIONS START 

# create fucntion
create()
{
    PASSWORD=league2019!
    DOMAIN=michaelou23gmail.onmicrosoft.com
    userdisplayname=$1
    usersubscription=$2
    userprincipalname=$userdisplayname@$DOMAIN
    
    # validate arguments
    if [ -z "$userdisplayname" ]; then
        echo "no display name please put one in" 1>&2
        exit 1
    elif [ -z "$usersubscription" ]; then
        echo "no subscription please put one in" 1>&2
        exit 1
    fi

    # check if the user already exists
    user=$(az ad user list \
        --query [].userPrincipalName \
        | grep -E $userprincipalname)

    if [ -z "$user" ]; then
        az ad user create \
        --display-name $userdisplayname \
        --password $PASSWORD \
        --user-principal-name $userprincipalname \
        --force-change-password-next-login \
        --subscription $usersubscription
        exit 0
    fi

    echo "this user already exists" 1>&2
    exit 1
}

## Assigns roles to a user
role()
{
    action="$1"
    username=$2
    role="$3"

    # validates arguments existence
    if [ -z $action ]; then
        echo "please give an action " 1>&2
        exit 1
    fi
    
    if [ -z $username ]; then
        echo "please give a username" 1>&2
        exit 1
    fi

    if [ -z $role ]; then
        echo "please give a role" 1>&2
        exit 1
    fi

    # validates action
    if [ $action != "create" ] && [ $action != "delete" ]; then
        echo "You can only create or delete. Please put in either 'create' or 'delete'" 1>&2
        exit 1
    fi

    az role assignment $action --assignee $username --role $role
    # az role assignment "create" --assignee \
    # puppersthree@michaelou23gmail.onmicrosoft.com --role "Contributor"

    # az role assignment list --assignee pupperstwo@michaelou23gmail.onmicrosoft.com \
    # --query [].roleDefinitionName

    # Command for checking what role the user is
    # az role assignment list --assignee $username --query [].roleDefinitionName
    assignedrole=$(az role assignment list --assignee $username --query [].roleDefinitionName)
    echo "$assignedrole"
}

## Deletes a non-admin user
delete()
{

    username=$1
    DOMAIN=@michaelou23gmail.onmicrosoft.com

    # validates arguments
    if [ -z "$username" ]; then
        echo "You did not provide a username. please provide a username!" 1>&2
        exit 1
    fi

    # checks if the username given is an admin
    admincheck=$(az role assignment list \
        --include-classic-administrators \
        --query "[?id=='NA(classic admins)'].principalName" \
        | grep -E $username)

    if [ -n "$admincheck" ]; then
        echo "This is an admin please do not delete" 1>&2
        exit 1
    fi

    # user verification block and delete statement
    user=$(az ad user list \
        --query [].userPrincipalName \
        | grep -E $username)

    if [ -z "$user" ]; then
        echo "User does not exist" 1>&2
        exit 1
    fi

    az ad user delete --upn-or-object-id $username
    echo "User has been deleted"

}
################## FUNCTIONS END 



################## VARIABLES START 

command=$1

################## VARIABLES END



################## MAIN START 
adminusername=$(az account show \
  --query user.name)

# admin check (requrirement: "must be admin")
echo "Requirement check: user 'must be admin'."

check=$(az role assignment list \
    --include-classic-administrators \
    --query "[?id=='NA(classic admins)'].principalName" \
    | grep -E $adminusername)

if [ -z "$check" ]; then
  echo "You are not the admin please sqitch to an admin accoutn" 1>&2
  exit 1
fi

echo "You are verified as the admin"
################## MAIN END



################## CASE START 
# To switch cases use: 'create'/'role'/'delete'
# Should look like this:
# ./part3working.sh 'create' puppersthree Revature
# ./part3working.sh 'role' "create" puppersthree@michaelou23gmail.onmicrosoft.com "Reader"
# ./part3working.sh 'delete' puppersthree@michaelou23gmail.onmicrosoft.com

case "$command" in
    "create")
        username=$2
        subscription=$3
        create $username $subscription
    ;;
    "role")
        action=$2
        username=$3
        role=$4
        role $action $username $role
    ;;
    "delete")
        username=$2
        delete $username
    ;;
    *)
        echo "please use 'create', 'role', or 'delete'" 1>&2
        exit 1
    ;;
esac
################## CASE END