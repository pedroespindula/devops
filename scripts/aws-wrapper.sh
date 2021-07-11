OWNER=pedro

aws-ec2-ls() {
  aws ec2 describe-instances --query "Reservations[].Instances[].{Name: Tags[?Key=='Name']|[0].Value, Id: InstanceId, Status: State.Name, PrivateIp: NetworkInterfaces[0].PrivateIpAddress, PublicIp: NetworkInterfaces[0].PrivateIpAddresses[0].Association.PublicIp, LastStarted: LaunchTime, Tags: Tags}" "$@"
}

aws-ec2-ls-all() {
  aws ec2 describe-instances "$@" | jq
}

aws-ec2-ls-running() {
  aws-ec2-ls --filters Name=instance-state-name,Values=running "$@" 
}

aws-ec2-ls-mine-running() {
  aws-ec2-ls-mine --filters Name=instance-state-name,Values=running "$@" 
}

aws-ec2-ls-running-ids() {
  aws-ec2-ls-running "$@" | jq --raw-output '.[].Id' | tr "\n" " "
}

aws-ec2-ls-mine-running-ids() {
  aws-ec2-ls-mine-running "$@" | jq --raw-output '.[].Id' | tr "\n" " "
}

aws-ec2-ls-user() {
  aws-ec2-ls --filters Name=tag:User,Values="$@" 
}

aws-ec2-ls-mine() {
  aws-ec2-ls-user $OWNER "$@" 
}

aws-ec2-ls-mine-ids() {
  aws-ec2-ls-mine "$@" | jq --raw-output '.[].Id' | tr "\n" " "
}

aws-ec2-start() {
  aws ec2 start-instances --instance-ids "$@"
}

aws-ec2-stop() {
  aws ec2 stop-instances --instance-ids "$@"
}

aws-ec2-stop-running() {
  aws-ec2-stop $(aws-ec2-ls-running-ids) "$@" 
}

aws-ec2-stop-mine-running() {
  aws-ec2-stop $(aws-ec2-ls-mine-running-ids) "$@" 
}

aws-ec2-start-mine() {
  aws-ec2-start $(aws-ec2-ls-mine-ids) "$@" 
}

aws-ec2-stop-mine() {
  aws-ec2-stop $(aws-ec2-ls-mine-ids) "$@" 
}
