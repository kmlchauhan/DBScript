#!/bin/bash
set -ex
function usage {
  echo "
  Arguments for this script are as follows:
  -a arguments to pass to ansible-playbook
  -b branch to deploy from
  -e environment to run in
  -l limit on hosts to run againts
  -h output this help info
  -p playbook to run
  -u user to run as
  " >&2
  exit 1
}
while getopts a:hb:e:l:p:u: option
do
  case "${option}" in
    a) ARGUMENTS=${OPTARG};;
    b) BRANCH=${OPTARG};;
    e) ENV=${OPTARG};;
    l) LIMIT=${OPTARG};;
    h) usage;;
    p) PLAYBOOOK=${OPTARG};;
    u) USER=${OPTARG};;
    *) usage;;
  esac
done
if [[ ! $BRANCH ]]
then
  BRANCH="master"
fi
if [[ ! $USER ]]
then
  USER="ec2-user"
fi
if [[ ! $PLAYBOOK ]]
then
  PLAYBOOK="post-provisioning.yml"
fi



#Exit if vars are undefined
if [[ ! $PLAYBOOK || ! $USER || ! $BRANCH ]]
then
  echo "Missing arguments!" >&2
  usage
  exit 1
fi
set -ux
  git \
    clone \
    --depth 1 \
    --branch ${BRANCH} \
    ssh://git@git.allegiantair.com:7999/devops/aws-inventory.git
  git \
    clone \
    --depth 1 \
    --branch ${BRANCH} \
    ssh://git@git.allegiantair.com:7999/devops/ansible-base.git
  cd ansible-base
  ./init.sh

ansible-playbook \
  -i ../aws-inventory/${ENV}.aws_ec2.yml \
  --limit=${LIMIT} \
  ${PLAYBOOK} \
  -u ${USER} \
  ${ARGUMENTS}
  

cd ..
rm -rf ansible-base aws-inventory
