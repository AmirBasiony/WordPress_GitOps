Run everything (what you just did)
ansible-playbook wordpress.yml

Run only MySQL role
ansible-playbook wordpress.yml --tags mysql

Run only WordPress role
ansible-playbook wordpress.yml --tags wordpress

Skip MySQL
ansible-playbook wordpress.yml --skip-tags mysql


If you don’t do any of the above → tags are ignored by design.
