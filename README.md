# sample ansible-playbooks

## IMS
- compilation of a COBOL program & free region

`ansible-playbook -i inventories pgm_compilation_v3.yml`

## CICS
- compilation of a COBOL program & Newcopy in CICS

`ansible-playbook -i inventories -e @secrets.enc --vault-password-file password_file CICS/compil_pgm_PBOOKCMN.yml`
- compilation of a COBOL program with SQL statemants & Newcopy in CICS

`ansible-playbook -i inventories -e @secrets.enc --vault-password-file password_file CICS/compil_pgm_PBOOKDB2.yml`
- add CICS resources

`ansible-playbook -i inventories -e @secrets.enc --vault-password-file password_file CICS/add_resources_zCEE_API-Requester.yml`

## z/OS Connect
- add API Provider

`ansible-playbook -i inventories zCEE_Deploy_war_API_Provider.yml`

- add API Requester

`ansible-playbook -i inventories zCEE_Deploy_war_API_Requester.yml`
