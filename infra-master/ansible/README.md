# Ansible Project

## How to setup ansible project

1. Install ansible

`apt install ansible`

2. clone project form

3. install requirements

```
ansible-galaxy collection install --force -r requirements.yaml
ansible-galaxy role install -r requirements.yaml
```


```
ansible-playbook -i hosts play.yaml -bK
```

## for debug
ansible-playbook -i hosts play.yaml -bK --limit node02 --tags apache --diff --check

ansible-playbook -i hosts play.yaml -bK --limit nodes --tags swapfile --diff
ansible-playbook -i hosts play.yaml -bK --limit node01 --tags tamrin01 --diff
