#!/bin/bash

# create function
create()
{
    pass=league2019!
    domain=michaelou23.onmicrosoft.com
    userdisplayname=$1
    usersubscription="${2}"
    userprincipalname=$userdisplayname@$DOMAIN

    # validate arguments
    if [ -z $userdisplayname ]; then
        echo "no display name please put one in" 1>&2
        exit 1
    fi

    if [ -z "${usersubscription}" ]; then
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
    elif [ -z $username ]; then
        echo "please give a username" 1>&2
        exit 1
    elif [ -z $role ]; then
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

    # add domain to username
    usernamecheck=$(echo "$username" | grep -E $domain)

    if [ -z $usernamecheck ]; then
        userprincipalname=${username}${domain}
    else
        userprincipalname=$username
    fi

    # admin check
    admincheck=$(az role assignment list \
        --include-classic-administrators \
        --query "[?id=='NA(classic admins)'].principalName" \
        | grep -E $userprincipalname)
    
    if [ -z $admincheck ]; then
        echo "you are not the admin and you cannot delete" 1>&2
        exit 1
    fi

     # user check and delete
    user=$(az ad user list \
        --query [].userPrincipalName \
        | grep -E $userprincipalname)

    if [ -z $user ]; then
        echo "user does not exist" 1>&2
        exit 1
    else
        echo "deleting user"
        az ad user delete --upn-or-object-id $userprincipalname
    fi

}

