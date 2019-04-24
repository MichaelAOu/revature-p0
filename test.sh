#!/bin/bash

##### FUNCTIONS #####
## Creates the User
create()
{
  PASSWORD=revature2019!
  DOMAIN=michaelou23gmail.onmicrosoft.com
  userdisplayname=$1
  usersubscription=$2
  userprincipalname=$userdisplayname@$DOMAIN

  # validate arguments
  if [ -z "$userdisplayname" ]; then
    echo "must provide display name" 1>&2
    exit 1
  elif [ -z "$usersubscription" ]; then
    echo "must provide subscription" 1>&2
    exit 1
  fi

  # check if the user already exists
  user=$(az ad user list \
    --query [].userPrincipalName \
    | grep -E $userprincipalname)

  if [ -z "$user" ]; then
    echo "creating user"
    az ad user create \
      --display-name $userdisplayname \
      --password $PASSWORD \
      --user-principal-name $userprincipalname \
      --force-change-password-next-login \
      --subscription $usersubscription
  else
    echo "user already exists" 1>&2
    exit 1
  fi
}

## Assigns roles to a user
role()
{
  roleaction=$1
  username=$2
  userrole=$(echo "$3" | tr '[:upper:]' '[:lower:]')

  # validates arguments existence
  if [ -z "$roleaction" ]; then
    echo "must provide role action" 1>&2
    exit 1
  elif [ -z "$username" ]; then
    echo "must provide username" 1>&2
    exit 1
  elif [ -z "$userrole" ]; then
    echo "must provide role" 1>&2
    exit 1
  fi

  # validates roleaction
  if [ $roleaction != "create" ] && [ $roleaction != "delete" ]; then
    echo "invalid role action. please use create or delete" 1>&2
    exit 1
  fi

  # validates userrole
  if [ $userrole != "reader" ] && [ $userrole != "contributer" ]; then
    echo "invalid role. please use reader or contributor" 1>&2
    exit 1
  fi

  az role assignemnt $roleaction --assignee $username --role $userrole
}

## Deletes a non-admin user
delete()
{
  username=$1
  DOMAIN=@michaelou23gmail.onmicrosoft.com

  # validates arguments
  if [ -z "$username" ]; then
    echo "must provide username" 1>&2
    exit 1
  fi

  # do not delete if user is admin
  admincheck=$(az role assignment list \
    --include-classic-administrators \
    --query "[?id=='NA(classic admins)'].principalName" \
    | grep -E $username)

  if [ -n "$admincheck" ]; then
    echo "You may not delete another admin" 1>&2
    exit 1
  fi

  # check if the user exists
  user=$(az ad user list \
    --query [].userPrincipalName \
    | grep -E $username)

  if [ -z "$user" ]; then
    echo "user does not exist" 1>&2
    exit 1
  else
    echo "deleting user"
    az ad user delete --upn-or-object-id $username
  fi
}

##### VARIABLES #####
command=$1

##### MAIN #####
az=$(which az)

if [ -z "$az" ]; then
  echo "No azure-cli. Please install before continuing." 1>&2
  exit 1
fi

adminusername=$(az account show \
  --query user.name)

# must be admin to run commands
echo "checking if current user is an admin"
check=$(az role assignment list \
    --include-classic-administrators \
    --query "[?id=='NA(classic admins)'].principalName" \
    | grep -E $adminusername)

if [ -z "$check" ]; then
  echo "must be admin to run commands" 1>&2
  exit 1
fi

echo "validated as admin user"

# run command - 'create', 'role', or 'delete' with the arguments

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

# ./test.sh 'create' pupperstwo Revature