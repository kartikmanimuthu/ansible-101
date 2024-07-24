aws ssm start-session --target i-0cd253c293e9e52ad

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

ansible-playbook -i hosts.ini install.yml

ansible-playbook -i hosts.ini install.yml -vvvv

ansible-playbook -i hosts.ini install.yml --check

ansible-playbook -i hosts.ini install.yml --syntax-check

cat /etc/os-release

ansible-playbook -i 'i-0971ca492522eb790,' -e "ansible_aws_ssm_bucket_name=ansible-ssm-bucket-vtg85uuq" -e "ansible_aws_ssm_region=us-east-1" playbook-install.yml

<!-- todo -->

ansible install mongodb - done

ansbile direct with terraform - done
terraform ansible provider - donr

ansible pem key - done

ansible roles - done
ansible galaxy - done

ansible amazonlinux machine bug fix - done

============================================================

Ansible Use Case

HA Database
ansible os system update
ansible ci/cd
