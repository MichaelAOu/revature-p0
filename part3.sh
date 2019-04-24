#!/bin/bash

# create function
create()
{
    pass=league2019!
    domain=michaelou23.onmicrosoft.com
    userdisplayname=$1
    usersubscription=$2
    userprincipalname=$userdisplayname@$DOMAIN

    # validate arguments
    if [ -z $userdisplayname ]; then
        echo "no display name please put one in" 1>&2
        exit 1
    fi

    if [ -z $usersubscription ]; then
        echo "no subscription please put one in" 1>&2
        exit 1
    fi
    
    # user variable
    user=$(az ad user list \
        --query [].userPrincipalName \
        | grep -E $userprincipalname)

    if [ -z $user ]; then
        az ad user create \
        --display-name $userdisplayname \
        --password $PASSWORD \
        --user-principal-name $userprincipalname \
        --force-change-password-next-login \
        --subscription "${usersubscription}"
    else
        echo "this user already exists" 1>&2
        exit 1
    fi
}

# user role function
role()
{
    action=$1
    username=$2
    role=$(echo "$3" | tr '[:upper:]' '[:lower:]')

    # check if arguments are given
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
        echo "plese enter create or delete" 1>&2
        exit 1
    fi

    # validates user role
    if [ $role != "reader" ] && [ $role != "contributer" ]; then
        echo "invalid role. please use reader or contributor" 1>&2
        exit 1
    fi

    # az command for role assignment
    az role assignemnt $action --assignee $username --role $role
}

# delete function 
delete()
{
    username=$1
    domain=@michaelou23.onmicrosoft.com

    # validation block
    if [ -z $username ]; then
        echo "must provide username" 1>&2
        exit 1
    fi

    # admin check
    admincheck=$(az role assignment list \
        --include-classic-administrators \
        --query "[?id=='NA(classic admins)'].principalName" \
        | grep -E $userprincipalname)
    
    if [ -z $admincheck ]; then
        echo "This is an admin please do not delete" 1>&2
        exit 1
    fi

     # user verification block and deletion statement
    user=$(az ad user list \
        --query [].userPrincipalName \
        | grep -E $userprincipalname)

    if [ -z $user ]; then
        echo "user does not exist" 1>&2
        exit 1
    else
        az ad user delete --upn-or-object-id $userprincipalname
        echo "user deleted"
    fi

}

# check if user is admin
# grab the username of the current 'logged-in' user
adminuser=$(az account show \
  --query user.name)

# grab the admin role information
check=$(az role assignment list \
    --include-classic-administrators \
    --query "[?id=='NA(classic admins)'].principalName" \
    | grep -E $adminusername)

if [ -z "$check" ]; then
  echo "you are not the admin pleae switch to admin to run the script" 1>&2
  exit 1
fi

echo "this user is the admin"

# variables
command=$1

# case for the commands
case "$command" in
  "create")
    username=$2
    subscription=$3
    create $username $subscription
  ;;
  "role")
    roleaction=$2
    username=$3
    userrole=$4
    role $roleaction $username $userrole
  ;;
  "delete")
    username=$2
    delete $username
  ;;
  *)
    echo "Invalid command. Please use 'create' or 'role' or 'delete'" 1>&2
    exit 1
  ;;
esac

# to run use this syntax
# 'command' arguments
# example:
# ./part3.sh 'create'