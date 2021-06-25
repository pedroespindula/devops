OWNER=pedro

aws-ec2-ls() {
  aws ec2 describe-instances --query "Reservations[].Instances[].{Name: Tags[?Key=='Name']|[0].Value, Id: InstanceId, Status: State.Name, Ip: NetworkInterfaces[0].PrivateIpAddress, LastStarted: LaunchTime, Tags: Tags}" "$@"
}

aws-ec2-ls-all() {
  aws ec2 describe-instances "$@" | jq
}

aws-ec2-ls-running() {
  aws-ec2-ls --filters Name=instance-state-name,Values=running
}

aws-ec2-ls-user() {
  aws-ec2-ls --filters Name=tag:Owner,Values=$1
}

aws-ec2-ls-mine() {
  aws-ec2-ls-user $OWNER
}

aws-ec2-ls-mine-ids() {
  aws-ec2-ls-mine | jq --raw-output '.[].Id' | tr "\n" " "
}

aws-ec2-start() {
  aws ec2 start-instances --instance-ids "$@"
}

aws-ec2-stop() {
  aws ec2 stop-instances --instance-ids "$@"
}

aws-ec2-start-mine() {
  aws-ec2-start $(aws-ec2-ls-mine-ids)
}

aws-ec2-stop-mine() {
  aws-ec2-stop $(aws-ec2-ls-mine-ids)
}
